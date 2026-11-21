import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.SystemTray

ShellRoot {
    id: root

    // --- Konfigurasi Font & State ---
    readonly property string barFont: "JetBrainsMono Nerd Font"
    property bool niriDetected: Quickshell.env("NIRI_SOCKET") !== ""
    property var workspaces: []
    property string activeWindowTitle: ""

    // Fungsi memotong teks maksimal 40 karakter
    function truncateTitle(str) {
        if (!str) return "";
        return str.length > 40 ? str.substring(0, 37) + "..." : str;
    }

    // Mengambil daftar workspace
    Process {
        id: wsFetcher
        command: ["niri", "msg", "--json", "workspaces"]
        running: root.niriDetected
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let list = JSON.parse(this.text);
                    list.sort((a, b) => a.idx - b.idx);
                    root.workspaces = list;
                } catch (e) {}
            }
        }
    }

    // Mengambil judul jendela yang sedang fokus
    Process {
        id: winFetcher
        command: ["niri", "msg", "--json", "focused-window"]
        running: root.niriDetected
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let win = JSON.parse(this.text);
                    root.activeWindowTitle = (win && win.title) ? root.truncateTitle(win.title) : "";
                } catch (e) {
                    root.activeWindowTitle = "";
                }
            }
        }
    }

    // Mendengarkan event stream Niri secara real-time
    Process {
        id: niriStream
        command: ["niri", "msg", "--json", "event-stream"]
        running: root.niriDetected
        stdout: SplitParser {
            onRead: line => {
                if (line.includes("Workspace")) {
                    wsFetcher.running = true;
                    winFetcher.running = true;
                } else if (line.includes("Window")) {
                    winFetcher.running = true;
                    if (line.includes("Opened") || line.includes("Closed")) {
                        wsFetcher.running = true;
                    }
                }
            }
        }
    }

    // --- Tampilan Bar di Setiap Monitor ---
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: bar
            property var modelData
            screen: modelData

            anchors {
                bottom: true
                left: true
                right: true
            }
            implicitHeight: 18
            color: "#11111b"

            Item {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8

                // ==========================================
                // 1. KIRI: Title Bar (Maksimal 40 Karakter)
                // ==========================================
                Text {
                    id: windowTitleText
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    visible: root.niriDetected
                    text: root.activeWindowTitle !== "" ? root.activeWindowTitle : "..."
                    color: root.activeWindowTitle !== "" ? "#bac2de" : "#6c7086"
                    font.pixelSize: 10
                    font.family: root.barFont
                    font.hintingPreference: Font.PreferFullHinting
                    renderType: Text.NativeRendering
                }

                // Fallback teks jika dijalankan di luar Niri
                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    visible: !root.niriDetected
                    text: "[niri tidak terdeteksi]"
                    color: "#f38ba8"
                    font.pixelSize: 10
                    font.family: root.barFont
                    font.hintingPreference: Font.PreferFullHinting
                    renderType: Text.NativeRendering
                }

                // ==========================================
                // 2. TENGAH: Workspace Niri (Tepat di Tengah)
                // ==========================================
                Row {
                    anchors.centerIn: parent
                    spacing: 5
                    visible: root.niriDetected

                    Repeater {
                        model: root.workspaces.filter(ws => ws.output === bar.screen.name)
                        delegate: Rectangle {
                            id: wsPill
                            required property var modelData
                            readonly property bool isFocused: modelData.is_focused
                            readonly property bool hasWindows: modelData.active_window_id !== null

                            width: isFocused ? (wsLabel.implicitWidth + 10) : 7
                            height: isFocused ? 13 : 7
                            radius: height / 2
                            anchors.verticalCenter: parent.verticalCenter
                            color: isFocused ? "#89b4fa" : (hasWindows ? "#a6adc8" : "#45475a")

                            Behavior on width { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
                            Behavior on color { ColorAnimation { duration: 120 } }

                            Text {
                                id: wsLabel
                                anchors.centerIn: parent
                                visible: isFocused
                                text: modelData.name ? modelData.name : modelData.idx
                                color: "#11111b"
                                font.pixelSize: 10
                                font.bold: true
                                font.family: root.barFont
                                font.hintingPreference: Font.PreferFullHinting
                                renderType: Text.NativeRendering
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    Quickshell.execDetached(["niri", "msg", "action", "focus-monitor", bar.screen.name]);
                                    Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", String(wsPill.modelData.idx)]);
                                }
                            }
                        }
                    }
                }

                // ==========================================
                // 3. KANAN: System Tray & Waktu
                // ==========================================
                Row {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    Row {
                        id: trayRow
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 5

                        Repeater {
                            model: SystemTray.items
                            delegate: Item {
                                id: trayItem
                                required property var modelData
                                width: 14
                                height: 14
                                anchors.verticalCenter: parent.verticalCenter

                                Image {
                                    anchors.fill: parent
                                    source: trayItem.modelData.icon
                                    sourceSize.width: 14
                                    sourceSize.height: 14
                                    smooth: true
                                }

                                QsMenuAnchor {
                                    id: trayMenu
                                    menu: trayItem.modelData.menu
                                    anchor.window: bar
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                                    onClicked: mouse => {
                                        if (mouse.button === Qt.LeftButton && !trayItem.modelData.onlyMenu) {
                                            trayItem.modelData.activate();
                                        } else if (trayItem.modelData.hasMenu) {
                                            let pos = trayItem.mapToItem(bar.contentItem, 0, 0);
                                            trayMenu.anchor.rect = Qt.rect(pos.x, pos.y, trayItem.width, trayItem.height);
                                            trayMenu.open();
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Pemisah vertikal tipis
                    Rectangle {
                        width: 1
                        height: 11
                        anchors.verticalCenter: parent.verticalCenter
                        color: "#313244"
                        visible: SystemTray.items.values.length > 0
                    }

                    // Waktu & Tanggal
                    Text {
                        id: clockText
                        anchors.verticalCenter: parent.verticalCenter
                        color: "#cdd6f4"
                        font.pixelSize: 11
                        font.family: root.barFont
                        font.bold: true
font.hintingPreference: Font.PreferFullHinting
renderType: Text.NativeRendering
text: Qt.formatDateTime(clock.date, "ddd dd MMM  HH:mm")
}
SystemClock {
id: clock
precision: SystemClock.Minutes
}
}
}
}
}
}
