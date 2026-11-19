#!/usr/bin/env bash
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$DIR"
CFG="$HOME/.config"
TARGETS=(
  "fish"
  "gitconfig"
  "nvim"
  "alacritty"
)
[ -d "$SRC" ] || {
  echo "Error: $SRC not found"
  exit 1
}

if [ "$1" == "reset" ]; then
  echo "Resetting dotfiles..."
  for name in "${TARGETS[@]}"; do
    [[ "$name" =~ ^\. ]] && continue
    item="$SRC/$name"
    [ -e "$item" ] || continue
    if [ -d "$item" ]; then
      case "$name" in
      "nvim")
        find "$CFG/nvim" -maxdepth 1 -name "*.lua" -delete 2>/dev/null || true
        ;;
      "Code")
        if [ -d "$item/User" ]; then
          for f in "$item/User"/*; do
            [ -e "$f" ] && rm -rf "$CFG/Code/User/$(basename "$f")"
          done
        fi
        ;;
      "hypr")
        # Hanya hapus isi file di dalam hypr, jangan hapus foldernya agar Hyprland tidak error
        find "$CFG/hypr" -mindepth 1 -delete 2>/dev/null || true
        ;;
      *)
        # Untuk folder lain selain hypr, tetap bisa hapus total atau sesuaikan
        rm -rf "$CFG/$name"
        ;;
      esac
      echo " -> [FOLDER] Reset $name"
    elif [ -f "$item" ]; then
      rm -f "$HOME/.${name#.}"
      echo " -> [FILE] Reset $name"
    fi
  done
  echo "Reset complete."
  exit 0
fi

echo "Deploying dotfiles..."
mkdir -p "$CFG"
for name in "${TARGETS[@]}"; do
  if [[ "$name" =~ ^\. ]]; then
    echo " -> [SKIP] Mengabaikan dotfile: $name"
    continue
  fi
  item="$SRC/$name"
  if [ ! -e "$item" ]; then
    echo "Warning: Deklarasi '$name' tidak ditemukan di $SRC, dilewati."
    continue
  fi
  if [ -d "$item" ]; then
    target="$CFG/$name"
    mkdir -p "$target"
    case "$name" in
    "nvim")
      rsync -a --exclude='*lock.json' "$item/" "$target/" 2>/dev/null || cp -rf "$item"/* "$target/"
      ;;
    "Code")
      mkdir -p "$target/User"
      cp -rf "$item/User/"* "$target/User/" 2>/dev/null || true
      ;;
    "hypr")
      # Timpa/salin isi folder hypr secara langsung tanpa menghapus foldernya
      cp -rf "$item"/* "$target/" 2>/dev/null || true
      ;;
    *)
      # Untuk folder lain, gunakan timpa langsung (cp -rf tanpa rm -rf target)
      cp -rf "$item"/. "$target/" 2>/dev/null || cp -rf "$item"/* "$target/" 2>/dev/null || true
      ;;
    esac
    echo " -> [FOLDER] $name"
  elif [ -f "$item" ]; then
    cp -f "$item" "$HOME/.${name#.}"
    echo " -> [FILE] $name"
  fi
done
echo "Done."
