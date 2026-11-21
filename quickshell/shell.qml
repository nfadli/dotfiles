
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.SystemTray

ShellRoot {
    id: root

    // --- State & Deteksi Niri ---
    property bool niriDetected: Quickshell.env("NIRI_SOCKET") !== ""
    property var workspaces: []

    // Mengambil daftar workspace awal & memperbarui saat ada event
    Process {
        id: wsFetcher
        command: ["niri", "msg", "--json", "workspaces"]
        running: root.niriDetected
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let list = JSON.parse(this.text);
                    // Urutkan berdasarkan indeks workspace Niri
                    list.sort((a, b) => a.idx - b.idx);
                    root.workspaces = list;
                } catch (e) {}
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
                if (line.includes("Workspace") || line.includes("Window")) {
                    wsFetcher.running = true;
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

            // Posisi bawah & ukuran ultra-tipis 14px (gaya i3status)
            anchors {
                bottom: true
                left: true
                right: true
            }
            implicitHeight: 14
            color: "#11111b" // Latar gelap minimalis

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 4
                anchors.rightMargin: 6
                spacing: 0

                // ==========================================
                // 1. KIRI: Workspace Niri (Pill + Dots Style)
                // ==========================================
                Row {
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 4
                    visible: root.niriDetected

                    Repeater {
                        // Filter workspace khusus untuk monitor aktif
                        model: root.workspaces.filter(ws => ws.output === bar.screen.name)

                        delegate: Rectangle {
                            required property var modelData
                            readonly property bool isFocused: modelData.is_focused
                            readonly property bool hasWindows: modelData.active_window_id !== null

                            // Gaya Niri: Pill memanjang jika aktif, titik kecil jika tidak aktif
                            width: isFocused ? (wsLabel.implicitWidth + 8) : 6
                            height: isFocused ? 11 : 6
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
                                font.pixelSize: 9
                                font.bold: true
                                font.family: "monospace"
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", String(modelData.idx)]);
                                }
                            }
                        }
                    }
                }

                // Fallback teks jika dijalankan di luar Niri
                Text {
                    visible: !root.niriDetected
                    text: "[niri tidak terdeteksi]"
                    color: "#f38ba8"
                    font.pixelSize: 9
                    font.family: "monospace"
                }

                // Spacer tengah
                Item { Layout.fillWidth: true }

                // ==========================================
                // 2. KANAN: System Tray & Waktu (2026 API)
                // ==========================================
                Row {
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 6

                    // System Tray (Quickshell.Services.SystemTray)
                    Row {
                        id: trayRow
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 4

                        Repeater {
                            model: SystemTray.items

                            delegate: Item {
                                required property var modelData
                                width: 12
                                height: 12
                                anchors.verticalCenter: parent.verticalCenter

                                Image {
                                    anchors.fill: parent
                                    source: modelData.icon
                                    sourceSize.width: 12
                                    sourceSize.height: 12
                                    smooth: true
                                }

                                // Menu klik kanan standar 2026 (QsMenuAnchor)
                                QsMenuAnchor {
                                    id: trayMenu
                                    menu: modelData.menu
                                    anchor.window: bar
                                    anchor.rect.x: parent.mapToItem(bar.contentItem, 0, 0).x
                                    anchor.rect.y: 0
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                                    onClicked: mouse => {
                                        if (mouse.button === Qt.LeftButton && !modelData.onlyMenu) {
                                            modelData.activate();
                                        } else if (modelData.hasMenu) {
                                            trayMenu.open();
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Pemisah vertikal tipis ala i3status
                    Rectangle {
                        width: 1
                        height: 9
                        anchors.verticalCenter: parent.verticalCenter
                        color: "#313244"
                        visible: SystemTray.items.values.length > 0
                    }

                    // Waktu & Tanggal
                    Text {
                        id: clockText
                        anchors.verticalCenter: parent.verticalCenter
                        color: "#cdd6f4"
                        font.pixelSize: 10
                        font.family: "monospace"
                        font.bold: true
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
