# Better Ctrl+W

<p align="center">
  <img src="https://img.shields.io/badge/Windows-10%20%7C%2011-0078D4?style=for-the-badge&logo=windows" alt="Windows 10 | 11">
  <img src="https://img.shields.io/badge/version-1.0.0-blue?style=for-the-badge" alt="Version 1.0.0.1">
  <img src="https://img.shields.io/badge/license-MIT-green?style=for-the-badge" alt="MIT License">
  <img src="https://img.shields.io/badge/.NET-8.0-512BD4?style=for-the-badge&logo=dotnet" alt=".NET 8.0">
</p>

**Close any window with Ctrl+W - just like in your browser!**

<p align="center">
  <img src="docs/demo.gif" alt="Better Ctrl+W Demo" width="600">
</p>

<p align="center">
  <a href="#-installation">Installation</a> •
  <a href="#-how-to-use">How to Use</a> •
  <a href="#-customizing-which-apps-are-excluded">Customize</a> •
  <a href="#-troubleshooting">Troubleshooting</a> •
  <a href="#-frequently-asked-questions-faq">FAQ</a>
</p>

## 🎯 What is this?

Building this because windows didnt. Universal hotkey that will Close **any** Windows program with Ctrl+W.

If you use a web browser, you know that **Ctrl+W** closes tabs instantly. But try it in Notepad, Paint, or others.. nothing happens.

**Better Ctrl+W** makes Ctrl+W work **everywhere**. 

### ✨ Features at a Glance

| Feature | What it does |
|---------|--------------|
| 🪟 **Universal Window Closing** | Press Ctrl+W to close any window, anywhere |
| 🧠 **Smart Exclusions** | Automatically skips browsers and apps that already use Ctrl+W |
| 🎮 **Fullscreen Protection** | Won't close your games or fullscreen videos |
| 🚀 **Auto-Start Option** | Optionally starts with Windows - set it and forget it |
| ⚙️ **Fully Customizable** | Easy config file to add or remove exclusions |



## ⚡ Quick Reference Guide

**New to Better Ctrl+W? Start here:**

1. **Download & Install** → Get `BetterCtrlW-Setup.exe` from [releases](https://github.com/lhunter3/BetterCtrlW/releases)
2. **Run it** → Double-click the installer, click Next a few times.
2. **Configure it** → Update & reload config.
4. **Done** → Universal CtrlW functionality within non-excluded apps.
5. **Optional: Auto-start** → Right-click tray icon → Check "Start with Windows"

**Quick Tips:**
- 💡 Config File: Edit `C:\Users\{username}\AppData\Local\Better Ctrl+W`
- 💡 Disable: Right-click tray icon → Exit

---

## 📥 Installation

### Quick Install (3 Steps)

> **TL;DR:** Download → Double-click → Done!

1. **Download** `BetterCtrlW-Setup.exe` from the [**Releases Page**](https://github.com/lhunter3/BetterCtrlW/releases) ⬇️
2. **Run** the installer (double-click the downloaded file)
3. **Click** through the wizard (Next → Next → Install)


### 📂 Installation Location

| What | Where |
|------|-------|
| **Settings** | `C:\Users\{username}\AppData\Local\Better Ctrl+W` |
| **Start Menu Shortcut** | Search "Better Ctrl+W" in Start Menu |
| **Uninstaller** | Windows Settings → Apps → Installed apps |
---

## 🚀 How to Use

### It Just Works™

Once installed, **nothing to configure** - just start pressing **Ctrl+W** to close windows!

 💥 Notepad closes instantly!


### ⛔ Where It Doesn't Interfere

Better Ctrl+W **passes through** in these apps (Ctrl+W works normally):

| App Type | What Happens |
|----------|--------------|
| 🌐 **Web Browsers** | Ctrl+W closes tabs (Chrome, Firefox, Edge, etc.) |
| 💻 **Code Editors** | Ctrl+W closes tabs/files (VS Code, Notepad++, etc.) |
| 🖥️ **IDEs** | Normal Ctrl+W behavior preserved |
| 🎮 **Fullscreen Games** | Ignored completely (won't close your game!) |
| 📺 **Fullscreen Videos** | Ignored (won't interrupt your movie) |

### System Tray Menu

**Right-click** the tray icon to access settings:

- **Reload Config** - Reload settings after changing the config file
- **Start with Windows** - Check this to run Better Ctrl+W every time you start your computer
- **Exit** - Close the application


## Customizing Which Apps Are Excluded

Better Ctrl+W is already configured to skip apps that use Ctrl+W for their own purposes (like closing browser tabs). But you can customize this list!

### What's Already Excluded?

These apps are excluded by default, so Ctrl+W works normally in them:

- **Web Browsers**: Chrome, Firefox, Edge, Brave, Opera, Vivaldi
- **Code Editors**: VS Code, Visual Studio, Notepad++, Sublime Text, Atom
- **Developer Tools**: PyCharm, WebStorm, IntelliJ, Eclipse, Rider
- **Microsoft Office**: Word, Excel, PowerPoint, Outlook
- **Terminals**: Command Prompt, PowerShell, Windows Terminal
- **Communication**: Discord, Slack, Teams
- **Other**: Spotify, Steam, File Explorer

### How to Add or Remove Apps from the Exclusion List

**Step 1: Find the Config File**

The settings are stored in a file called `Config.json` located at:
```
C:\Users\{username}\AppData\Local\Better Ctrl+W
```

**Step 2: Open It in Notepad**

1. Right-click the **Better Ctrl+W tray icon** → **Exit** (the app must be closed first)
2. Press **Windows Key + R** to open Run
3. Type: `notepad "C:\Users\{username}\AppData\Local\Better Ctrl+W"`
4. Press **Enter**

**Step 3: Edit the List**

You'll see something like this:

```json
{
  "ExcludedProcesses": [
    "chrome",
    "firefox",
    "code",
    "notepad++"
  ],
  "AutoStartupEnabled": false
}
```

- **To add an app**: Add a line with the app's process name (see below)
- **To remove an app**: Delete the line with that app's name

**Step 4: Find an App's Process Name**

If you want to exclude a specific app:

1. Open the app you want to exclude
2. Press **Ctrl+Shift+Esc** to open Task Manager
3. Click the **"Details"** tab
4. Find your app in the list - the **"Name"** column shows the process name
5. Remove the `.exe` part (e.g., `myapp.exe` → use `myapp`)

**Step 5: Save and Reload**

1. Save the file in Notepad (Ctrl+S)
2. Close Notepad
3. Start Better Ctrl+W again from the Start Menu
4. Your changes are now active!

**Example: Excluding Photoshop**

If you want Ctrl+W to NOT close Photoshop windows:

1. Open Photoshop
2. Check Task Manager → Details tab → Find "Photoshop.exe"
3. Add `"photoshop"` to the list in Config.json:

```json
{
  "ExcludedProcesses": [
    "chrome",
    "firefox",
    "photoshop"
  ],
  "AutoStartupEnabled": false
}
```

**⚠️ Important**: Don't forget the commas between items! The last item in the list should NOT have a comma.

---

## 💡 Tips & Tricks

### Keyboard Shortcuts Cheat Sheet

| Shortcut | What it does |
|----------|--------------|
| **Ctrl+W** | Close current window (in non-excluded apps) |
| **Ctrl+Shift+Esc** | Open Task Manager (to find process names) |
| **Windows Key + R** | Open Run dialog (to edit Config.json) |
| **Alt+F4** | Close window (still works as backup!) |

### Pro Tips

💡 **Create custom exclusions** - If you have a work app where you don't want Ctrl+W to close windows, just add it to the config!

💡 **Use with AutoHotkey** - Better Ctrl+W works great alongside other keyboard automation tools

💡 **Perfect for multi-monitor setups** - Quickly close windows across all your screens

💡 **Great for cleaning up clutter** - Have 20 File Explorer windows? Ctrl+W through them in seconds!

---

## ❓ Frequently Asked Questions (FAQ)

### Does this replace Alt+F4?

No! Alt+F4 still works exactly as before. Better Ctrl+W just gives you an additional, more convenient option.

### Will this break my browser?

Absolutely not! Better Ctrl+W is **pre-configured** to skip all major browsers. In Chrome, Firefox, Edge, etc., Ctrl+W will continue to close tabs normally.

### Can I disable it temporarily?

Yes! Just right-click the tray icon and select "Exit". Launch it again from the Start Menu when you want it back.

### Does it work with keyboard shortcuts apps like AutoHotkey?

Yes! Better Ctrl+W works alongside other keyboard automation tools without conflicts.

### Why can't I close some windows?

Windows protects certain system windows (like Task Manager) from being closed by third-party apps. This is a security feature built into Windows.

### Does this work on Windows 11?

Yes! Works perfectly on both Windows 10 and Windows 11.

### Can I use this on multiple computers?

Yes! Just install it on each computer. The config file is separate for each installation.

### Is my data safe?

Absolutely. Better Ctrl+W runs **completely offline**, collects **no data**, and has **no internet access**. It only monitors for Ctrl+W keypresses to close windows.

---

## 🔧 Troubleshooting

### 🚫 Nothing happens when I press Ctrl+W

<details>
<summary><b>Click to expand troubleshooting steps</b></summary>

**Step 1: Check if the app is running**
- Look for the Better Ctrl+W icon in your **system tray** (bottom-right corner, near the clock)
- Don't see it? Click the **up arrow (^)** to show hidden icons
- Still not there? Open it from the **Start Menu** (search "Better Ctrl+W")

**Step 2: Test in a simple app**
```
1. Press Windows Key
2. Type "notepad"
3. Press Enter to open Notepad
4. Press Ctrl+W
5. ✅ Notepad should close instantly
```

**Step 3: Check if you're in fullscreen**
- Better Ctrl+W **won't close fullscreen windows** (games, videos, presentations)
- Press **Escape** or **F11** to exit fullscreen, then try Ctrl+W again

**Step 4: Check if the app is excluded**
- The program might be on the exclusion list (see Config.json)
- This is normal for browsers, code editors, and terminals

</details>

### 🎯 Ctrl+W doesn't work in a specific program

<details>
<summary><b>The program is probably excluded - here's how to check</b></summary>

This is **normal** for browsers and code editors! They're intentionally excluded.

**To check if a program is excluded:**
1. Right-click the tray icon → **Exit**
2. Press **Windows Key + R**
3. Type: `notepad "C:\Users\{username}\AppData\Local\Better Ctrl+W"`
4. Press **Enter**
5. Look for the program name in the `ExcludedProcesses` list
6. Remove it if you want Ctrl+W to close that program
7. Save (Ctrl+S) and restart Better Ctrl+W

</details>

### ⏱️ "Start with Windows" doesn't work

<details>
<summary><b>Try this fix</b></summary>

1. Right-click the tray icon
2. Make sure **"Start with Windows"** has a **checkmark** ✅
3. Try **unchecking** it, then **checking** it again
4. Restart your computer to test
5. If still not working, the registry entry might need manual attention (see developer section)

</details>

### 🔒 I can't close certain windows (Task Manager, Settings, etc.)

<details>
<summary><b>This is normal - Windows security feature</b></summary>

Some Windows **system windows** are protected by Windows and **cannot** be closed by third-party programs. This includes:
- Task Manager
- Windows Security
- UAC dialogs
- System Settings (some windows)

This is a **security feature** built into Windows to prevent malicious programs from closing critical system windows.

**Workaround:** Use **Alt+F4** for these protected windows.

</details>

### 🐛 Something else not working?

[Open an issue on GitHub](https://github.com/lhunter3/BetterCtrlW/issues) with:
- What you were trying to do
- What happened (or didn't happen)
- What app you were using
- Screenshots if possible

---

## 🗑️ Uninstalling

### Easy Uninstall (2 Methods)

**Method 1: Windows Settings**
```
1. Press Windows Key
2. Type "Add or remove programs"
3. Find "Better Ctrl+W"
4. Click → Uninstall
5. Confirm
```

**Method 2: Settings App**
```
Settings → Apps → Installed apps → Better Ctrl+W → ⋮ → Uninstall
```

The uninstaller **removes everything automatically** including:
- ✅ The program file
- ✅ The configuration file
- ✅ Start Menu shortcuts
- ✅ Auto-startup registry entry (if enabled)

---

## 🔒 Privacy & Security

### Is This Safe?

**Yes!** Better Ctrl+W is designed with privacy and security in mind.

### ✅ What Better Ctrl+W Does

| Feature | Details |
|---------|---------|
| 🔌 **Completely Offline** | No internet connection needed or used |
| 🚫 **Zero Data Collection** | Doesn't send any information anywhere |
| 👁️ **Open Source** | All code is publicly available on GitHub for review |
| 🛡️ **No Admin Rights** | Runs with standard user permissions |
| 🪟 **Standard Windows APIs** | Only uses official Windows features |

### 🔍 What It Can Access

Better Ctrl+W can **only**:
- ✅ See which window is currently active (to decide if it should close)
- ✅ Detect when you press **Ctrl+W**
- ✅ Send a "close window" command (same as clicking the X button)

### 🚫 What It CANNOT Do

Better Ctrl+W **cannot**:
- ❌ Read your files or documents
- ❌ See what you're typing (except detecting Ctrl+W)
- ❌ Access the internet or network
- ❌ Modify other programs
- ❌ Change Windows system settings (except its own startup entry)
- ❌ Run without your permission

### 🔐 Technical Security Details

<details>
<summary><b>For the security-conscious (click to expand)</b></summary>

**Permissions Used:**
- Keyboard hook (`SetWindowsHookEx`) - to detect Ctrl+W
- Window enumeration (`GetForegroundWindow`) - to identify active window
- Process access (`GetWindowThreadProcessId`) - to check exclusion list
- Registry write (optional) - only for "Start with Windows" feature

**No Network Access:**
- Does not request internet permissions
- Does not open sockets or connections
- Cannot send or receive data

**Code Signing:**
- Future releases will include code signing for additional verification

**Open Source:**
- Full source code available at https://github.com/lhunter3/BetterCtrlW
- Build it yourself if you prefer!

</details>

---

## 💻 System Requirements

| Requirement | Details |
|-------------|---------|
| **Operating System** | Windows 10 or Windows 11 (64-bit) |
| **Disk Space** | ~100 MB |
| **RAM** | Minimal (uses ~20-30 MB when running) |
| **Processor** | Any modern CPU (no special requirements) |
| **Dependencies** | None! Installer includes .NET runtime |
| **Permissions** | Standard user (admin not required) |

### Compatibility

✅ Works with all Windows 10 versions (build 1809 or later)
✅ Works with Windows 11
✅ Compatible with multi-monitor setups
✅ Works alongside other keyboard automation tools
✅ Supports all keyboard layouts and languages

---

## 📋 Changelog

### Version 1.0.0 (Initial Release)

✨ **Features:**
- Global Ctrl+W keyboard hook for closing windows
- Smart exclusion system for browsers and code editors
- Fullscreen window detection
- System tray integration
- Auto-startup with Windows option
- Customizable JSON configuration
- Inno Setup installer

---

## 💖 Support This Project

If Better Ctrl+W makes your life easier, consider:

- ⭐ **Star this repo** on GitHub
- 🐛 **Report bugs** or suggest features via [GitHub Issues](https://github.com/lhunter3/BetterCtrlW/issues)
- 📢 **Share it** with friends and colleagues
- 🔧 **Contribute** code improvements or translations

Every bit helps make Better Ctrl+W better for everyone!

---

## 👨‍💻 For Developers

### Building from Source

**Prerequisites:**
- .NET 8.0 SDK
- Windows 10/11
- Inno Setup 6.0+ (for creating installer)

**Quick Build:**

```bash
# Clone the repository
git clone https://github.com/lhunter3/BetterCtrlW.git
cd BetterCtrlW

# Build and run
dotnet build
dotnet run
```

**Create distributable installer:**

```powershell
# Build single-file executable
dotnet publish -c Release -r win-x64 --self-contained true /p:PublishSingleFile=true

# Create installer (requires Inno Setup installed)
.\build-installer.ps1
```

Output: `Output\BetterCtrlW-Setup.exe`

See [BUILD.md](BUILD.md) for detailed build instructions.

### How It Works (Technical)

1. **Keyboard Hook**: Uses Windows low-level keyboard hooks (`SetWindowsHookEx` Win32 API) to intercept Ctrl+W globally
2. **Fullscreen Detection**: Compares window dimensions to monitor dimensions using `GetWindowRect` and `GetMonitorInfo`
3. **Process Detection**: Gets the active window's process name via `GetForegroundWindow` and checks against the exclusion list
4. **Window Closing**: Sends `WM_CLOSE` message to gracefully close the window

**Decision Flow:**
```
Ctrl+W pressed → Is fullscreen? → Yes → Ignore
                      ↓ No
                Is excluded? → Yes → Pass through
                      ↓ No
                Send WM_CLOSE
```

### Project Structure

- `Program.cs` - Main entry point and system tray setup
- `KeyboardHook.cs` - Global keyboard hook and window closing logic
- `Win32.cs` - Win32 API declarations (P/Invoke)
- `AppConfig.cs` - Configuration file management
- `StartupManager.cs` - Windows Registry auto-startup management
- `Config.json` - User configuration (exclusion list, settings)
- `installer.iss` - Inno Setup installer script
- `build-installer.ps1` - Build automation script

### Contributing

Contributions are welcome! Please feel free to:
- Report bugs or issues
- Suggest new features
- Submit pull requests

### License

MIT License - see [LICENSE](LICENSE) file for details.

### 🐛 Bug Reports & Feature Requests

Found a bug or have an idea? [Open an issue on GitHub](https://github.com/lhunter3/BetterCtrlW/issues)!

### 🗺️ Roadmap / Future Features

Considering for future releases:
- 🎨 Custom tray icon
- 🌐 Multiple language support
- ⌨️ Customizable hotkey (not just Ctrl+W)
- 📊 Usage statistics (optional, privacy-first)
- 🔄 Auto-update functionality
- 🎯 Window-specific rules (e.g., "close Chrome windows but not tabs")

**Have an idea?** [Suggest it here!](https://github.com/lhunter3/BetterCtrlW/issues/new)

---

<p align="center">
  <b>Made with ❤️ by Lucas Hunter</b>
  <br><br>
  <a href="https://github.com/lhunter3/BetterCtrlW">
    <img src="https://img.shields.io/badge/GitHub-View%20Source-181717?style=for-the-badge&logo=github" alt="View Source">
  </a>
  <a href="https://github.com/lhunter3/BetterCtrlW/issues">
    <img src="https://img.shields.io/badge/Issues-Report%20Bug-red?style=for-the-badge&logo=github" alt="Report Bug">
  </a>
  <a href="https://github.com/lhunter3/BetterCtrlW/releases">
    <img src="https://img.shields.io/badge/Download-Latest%20Release-blue?style=for-the-badge&logo=github" alt="Download">
  </a>
</p>

<p align="center">
  <sub>If Better Ctrl+W saves you time, consider giving it a ⭐ on GitHub!</sub>
</p>
