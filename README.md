# 🐧 Arch Linux Dotfiles

Personal system configurations (dotfiles) for **Arch Linux** featuring a minimal, dark, and productive workflow powered by the **Niri** Wayland compositor and **Quickshell**.

> **Note:** Parts of the configurations, scripts, and structure in this dotfiles repository were created and refined with the assistance of **AI** (Artificial Intelligence).

---

## 🛠️ System Specifications & Core Components

| Component | Application / Config | Description |
| :--- | :--- | :--- |
| **OS** | [Arch Linux](https://archlinux.org) | Rolling release Linux distribution |
| **Window Manager** | [Niri](https://github.com/niri-wm/niri) | Scrollable-tiling Wayland compositor (*Default config* + dark variant) |
| **Status Bar / Shell** | [Quickshell](https://quickshell.org) | Custom QML-based configuration for desktop bars & widgets |
| **Terminal** | [Alacritty](https://alacritty.org) | GPU-accelerated terminal emulator |
| **Shell** | [Fish](https://fishshell.com) | Friendly interactive shell |
| **Text Editor** | [Neovim](https://neovim.io) & VS Code | Custom Lua-based Neovim configuration |
| **GTK Theme** | [adw-gtk3-dark](https://github.com/lassekongo83/adw-gtk3) | The theme from libadwaita ported to GTK-3 |

---

## 📂 Directory Structure

```text
.
├── alacritty/          # Alacritty terminal configuration (fonts, colors, opacity)
├── Code/
│   └── User/           # Visual Studio Code settings and keybindings
├── fish/               # Fish shell configuration, aliases, and functions
├── niri/               # Main Niri configuration (default config)
├── niri-dark/          # Dark theme variant configuration for Niri
├── nvim/
│   └── lua/
│       └── config/     # Custom Lua-based Neovim configuration
├── quickshell/         # Custom Quickshell bar, menu, and widget modules
└── scripts/            # Collection of automation and system utility scripts
```

---

## 🎨 Appearance & Theme

* **GTK Theme:** Uses `adw-gtk3-dark` to ensure legacy GTK3 applications match the modern dark aesthetic of GTK4/Libadwaita apps.
* **Window Management:** Uses Niri's *default config* for smooth scrollable-tiling navigation, paired with `niri-dark` for dark-mode adjustments.

## 🤖 Credits & Development Notes

The configurations in this repository—particularly the QML modules in **Quickshell**, the Lua setup in **Neovim**, and the automation utilities inside `scripts/`—were developed and debugged with **AI** assistance. Feel free to use, fork, and adapt them to fit your own setup.
