# Argos

[![Build](https://github.com/ZanogeaDumitru/Argos/actions/workflows/release.yml/badge.svg)](https://github.com/ZanogeaDumitru/Argos/actions/workflows/release.yml)

**Keep your Mac from going idle**

Argos sits in your menu bar and silently moves your cursor by 1 pixel at regular intervals — just enough to keep your Mac from going idle, so you can even stay "active" on apps even when you're away from your desk.

---

## Download & Install

1. Go to [GitHub Releases](https://github.com/ZanogeaDumitru/Argos/releases) and download `Argos.app.zip`
2. Unzip and drag `Argos.app` to your `/Applications` folder
3. **First launch:** right-click → Open (this bypasses Gatekeeper for unsigned apps)
4. Go to **System Settings → Privacy & Security → Accessibility** and enable Argos

> Argos needs Accessibility permission to move the cursor. Without it, the app will prompt you automatically.

---

## Usage

After launching, Argos appears in your menu bar:

| Icon | Status |
|------|--------|
| 👁 (green) | Active — cursor is being nudged |
| 👁‍🗨 (grey) | Inactive — paused |

**Menu options:**

- **Start / Stop** — toggle the nudge on or off
- **Interval** — choose how often the cursor moves: 5, 10, 15, 30, or 60 seconds (default: 10s)
- **Launch at Login** — start Argos automatically when you log in
- **Quit Argos** — exit the app

> The cursor movement is imperceptible — it moves 1 pixel and immediately returns to its original position.

---

## Requirements

- macOS 13 Ventura or later

---

## License

MIT — see [LICENSE](LICENSE)
