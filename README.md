# omarchy-bing-wallpaper

Bring **Bing's daily wallpaper** and **Windows Spotlight** images to [Omarchy](https://omarchy.org/) (Hyprland + swaybg).

There's no official Bing Wallpaper app for Linux, so this is a tiny self-contained replacement:

- Downloads the **Bing daily wallpaper** (last 8 days) and **Windows Spotlight** images (the curated lock/login-screen photos) — both at the best available resolution (UHD when offered).
- Keeps them **permanently cached** in `~/Pictures/bing` so you build up a growing gallery (~4–10 MB/day, roughly 1.5–3 GB/year).
- Cycle instantly with **`SUPER+ALT+→` / `SUPER+ALT+←`**.
- A **systemd user timer** fetches new images once a day.

## Requirements

Omarchy already ships everything: `curl`, `jq`, `swaybg`, `systemd`, Hyprland. `~/.local/bin` must be on your `PATH` (it is by default on Omarchy).

## Install

```bash
git clone https://github.com/albertolinard/omarchy-bing-wallpaper.git
cd omarchy-bing-wallpaper
./install.sh
```

The installer copies the script, enables the daily timer, adds the keybindings (idempotently), and sets today's wallpaper immediately.

## Usage

```bash
bing-wallpaper            # fetch everything, then show the newest image
bing-wallpaper fetch      # download new Bing + Spotlight images
bing-wallpaper bing       # Bing daily only
bing-wallpaper spotlight  # Windows Spotlight only
bing-wallpaper next       # next image in the archive (wraps around)
bing-wallpaper prev       # previous image
bing-wallpaper random     # random image
```

Keybindings (added to `~/.config/hypr/bindings.conf`):

| Keys | Action |
|------|--------|
| `SUPER + ALT + →` | Next wallpaper |
| `SUPER + ALT + ←` | Previous wallpaper |

## Configuration

Set environment variables (e.g. in `~/.config/uwsm/env` or before running):

| Variable | Default | Meaning |
|----------|---------|---------|
| `BING_MARKET` | `en-US` | Region/locale; use `auto` to let Bing choose by IP |
| `BING_RES` | `UHD` | Preferred Bing resolution; falls back to lower if unavailable |
| `BING_COUNT` | `8` | How many recent Bing days to fetch (max 8) |

## Notes

- Switching Omarchy **themes** runs `omarchy theme bg next`, which replaces the wallpaper with the theme's own background. Press `SUPER+ALT+→` to return to a Bing/Spotlight image.
- The Spotlight feed serves a rotating handful at a time; the archive fills out over several days as the daily timer runs.

## Uninstall

```bash
./uninstall.sh
```

Removes the script, timer, and keybindings. Your downloaded images in `~/Pictures/bing` are kept.

## License

MIT — see [LICENSE](LICENSE).
