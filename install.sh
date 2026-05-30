#!/bin/bash
# install.sh — install omarchy-bing-wallpaper for the current user.
#
# - copies the bing-wallpaper script to ~/.local/bin
# - installs and enables a systemd --user timer that fetches new images daily
# - adds SUPER+ALT+Left/Right keybindings to cycle wallpapers (idempotent)
# - downloads the first batch and sets today's image right away

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
UNIT_DIR="$HOME/.config/systemd/user"
BINDINGS="$HOME/.config/hypr/bindings.conf"
MARKER="# omarchy-bing-wallpaper bindings"

echo ":: Installing bing-wallpaper script -> $BIN_DIR"
mkdir -p "$BIN_DIR"
install -m 755 "$REPO_DIR/bin/bing-wallpaper" "$BIN_DIR/bing-wallpaper"

echo ":: Installing systemd --user timer -> $UNIT_DIR"
mkdir -p "$UNIT_DIR"
install -m 644 "$REPO_DIR/systemd/bing-wallpaper-fetch.service" "$UNIT_DIR/"
install -m 644 "$REPO_DIR/systemd/bing-wallpaper-fetch.timer" "$UNIT_DIR/"
systemctl --user daemon-reload
systemctl --user enable --now bing-wallpaper-fetch.timer

# Add keybindings once (idempotent — guarded by a marker comment)
if [[ -f "$BINDINGS" ]] && ! grep -qF "$MARKER" "$BINDINGS"; then
  echo ":: Adding SUPER+ALT+Left/Right keybindings -> $BINDINGS"
  cat >>"$BINDINGS" <<EOF

$MARKER
bindd = SUPER ALT, LEFT, Previous Bing wallpaper, exec, bing-wallpaper prev
bindd = SUPER ALT, RIGHT, Next Bing wallpaper, exec, bing-wallpaper next
EOF
  command -v hyprctl >/dev/null && hyprctl reload >/dev/null 2>&1 || true
else
  echo ":: Keybindings already present (or no Hyprland config found) — skipping"
fi

echo ":: Fetching first batch and applying today's wallpaper"
"$BIN_DIR/bing-wallpaper" default

cat <<'DONE'

Done! 🎉
  - SUPER+ALT+Right : next wallpaper
  - SUPER+ALT+Left  : previous wallpaper
  - New images download daily; archive lives in ~/Pictures/bing
  - Run "bing-wallpaper --help"-style commands: fetch | bing | spotlight | next | prev | random
DONE
