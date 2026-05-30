#!/bin/bash
# uninstall.sh — remove omarchy-bing-wallpaper. Your downloaded images are kept.

set -euo pipefail

BIN_DIR="$HOME/.local/bin"
UNIT_DIR="$HOME/.config/systemd/user"
BINDINGS="$HOME/.config/hypr/bindings.conf"
MARKER="# omarchy-bing-wallpaper bindings"

echo ":: Disabling timer"
systemctl --user disable --now bing-wallpaper-fetch.timer 2>/dev/null || true

echo ":: Removing files"
rm -f "$BIN_DIR/bing-wallpaper"
rm -f "$UNIT_DIR/bing-wallpaper-fetch.service" "$UNIT_DIR/bing-wallpaper-fetch.timer"
systemctl --user daemon-reload

# Strip the marker block (marker line + the two bindd lines that follow it)
if [[ -f "$BINDINGS" ]] && grep -qF "$MARKER" "$BINDINGS"; then
  echo ":: Removing keybindings from $BINDINGS"
  sed -i "/$MARKER/,+2d" "$BINDINGS"
  command -v hyprctl >/dev/null && hyprctl reload >/dev/null 2>&1 || true
fi

echo ":: Done. Images in ~/Pictures/bing were left untouched."
