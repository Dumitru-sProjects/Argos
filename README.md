# Argos

[![Build](https://github.com/ZanogeaDumitru/Argos/actions/workflows/release.yml/badge.svg)](https://github.com/ZanogeaDumitru/Argos/actions/workflows/release.yml)

**Keep your Mac from going idle**

Argos sits in your menu bar and silently moves your cursor by 1 pixel at regular intervals — just enough to keep your Mac from going idle, so you can even stay "active" on apps even when you're away from your desk.

---

## Download & Install

1. Go to [GitHub Releases](https://github.com/ZanogeaDumitru/Argos/releases) and download `Argos.app.zip`
2. Unzip the file
3. Open **Terminal** (press `⌘ Space`, type `Terminal`, press Enter)
4. Run this command to remove the macOS quarantine flag:
   ```bash
   xattr -cr ~/Downloads/Argos.app
   ```
5. Drag `Argos.app` to your `/Applications` folder
6. Double-click to open — macOS will no longer block it
7. Go to **System Settings → Privacy & Security → Accessibility** and enable Argos

> **Why the Terminal step?** Argos is not signed with an Apple Developer certificate ($99/year). macOS blocks unsigned apps downloaded from the internet by default. The `xattr -cr` command removes that restriction — it's safe and standard practice for open source apps.

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
