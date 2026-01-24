High-Level Plan: Ctrl+W Window Closer (Exclude Apps with Native Support)
Project Type: Console Application (.NET 6+)
Core Components:

Config.json

List of excluded process names (chrome, firefox, code, explorer, excel, etc.)
Apps that already handle Ctrl+W/tabs natively


Global Keyboard Hook

Intercept Ctrl+W system-wide using SetWindowsHookEx
Win32 API via P/Invoke


Fullscreen Detection

Check if active window is fullscreen before acting
Compare window dimensions to screen dimensions
If fullscreen: Don't execute (pass through or ignore)


Process Detection Logic

Get active window handle (GetForegroundWindow)
Get process name from handle
Check against exclusion list


Decision Flow

If fullscreen: Do nothing
Else if excluded: Pass Ctrl+W through (do nothing)
Else: Send WM_CLOSE to active window


System Tray Integration

Runs in background
Right-click: Exit, Reload Config



File Structure:

Program.cs - Main entry, hook setup
Config.json - Exclusion list
AppConfig.cs - Config loading
Win32.cs - Win32 API declarations
KeyboardHook.cs - Hook + fullscreen detection + close logic

Outcome: Simple, reliable. Fullscreen apps unaffected. Apps with native tab support excluded. Everything else gets Ctrl+W window closing.