using System.Diagnostics;
using System.Runtime.InteropServices;

namespace BetterCtrlW;

public class KeyboardHook : IDisposable
{
    private IntPtr _hookId = IntPtr.Zero;
    private readonly Win32.LowLevelKeyboardProc _hookCallback;
    private AppConfig _config;

    public KeyboardHook(AppConfig config)
    {
        _config = config;
        _hookCallback = HookCallback;
    }

    public void UpdateConfig(AppConfig newConfig)
    {
        _config = newConfig;
    }

    public void Install()
    {
        _hookId = SetHook(_hookCallback);
    }

    public void Uninstall()
    {
        if (_hookId != IntPtr.Zero)
        {
            Win32.UnhookWindowsHookEx(_hookId);
            _hookId = IntPtr.Zero;
        }
    }

    private IntPtr SetHook(Win32.LowLevelKeyboardProc proc)
    {
        using var curProcess = Process.GetCurrentProcess();
        using var curModule = curProcess.MainModule;

        if (curModule?.ModuleName == null)
            return IntPtr.Zero;

        return Win32.SetWindowsHookEx(
            Win32.WH_KEYBOARD_LL,
            proc,
            Win32.GetModuleHandle(curModule.ModuleName),
            0
        );
    }

    private IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam)
    {
        if (nCode >= 0 && wParam == (IntPtr)Win32.WM_KEYDOWN)
        {
            var hookStruct = Marshal.PtrToStructure<Win32.KBDLLHOOKSTRUCT>(lParam);

            // Check if Ctrl is currently pressed
            bool ctrlDown = (Win32.GetAsyncKeyState(Win32.VK_CONTROL) & 0x8000) != 0;

            // Detect Ctrl+W
            if (ctrlDown && hookStruct.vkCode == Win32.VK_W)
            {
                if (ShouldCloseWindow())
                {
                    CloseActiveWindow();
                    return (IntPtr)1; // Suppress the key press
                }
            }
        }

        return Win32.CallNextHookEx(_hookId, nCode, wParam, lParam);
    }

    private bool ShouldCloseWindow()
    {
        var activeWindow = Win32.GetForegroundWindow();
        if (activeWindow == IntPtr.Zero)
            return false;

        // Check if window is fullscreen
        if (IsWindowFullscreen(activeWindow))
            return false;

        // Check if process is excluded
        if (IsProcessExcluded(activeWindow))
            return false;

        return true;
    }

    private bool IsWindowFullscreen(IntPtr hWnd)
    {
        try
        {
            // Get window rectangle
            if (!Win32.GetWindowRect(hWnd, out var windowRect))
                return false;

            // Get monitor info
            var hMonitor = Win32.MonitorFromWindow(hWnd, Win32.MONITOR_DEFAULTTONEAREST);
            var monitorInfo = new Win32.MONITORINFO();
            monitorInfo.cbSize = (uint)Marshal.SizeOf(monitorInfo);

            if (!Win32.GetMonitorInfo(hMonitor, ref monitorInfo))
                return false;

            // Compare window size to monitor size
            var windowWidth = windowRect.Right - windowRect.Left;
            var windowHeight = windowRect.Bottom - windowRect.Top;
            var monitorWidth = monitorInfo.rcMonitor.Right - monitorInfo.rcMonitor.Left;
            var monitorHeight = monitorInfo.rcMonitor.Bottom - monitorInfo.rcMonitor.Top;

            // Consider fullscreen if window covers the entire monitor
            return windowWidth >= monitorWidth && windowHeight >= monitorHeight;
        }
        catch
        {
            return false;
        }
    }

    private bool IsProcessExcluded(IntPtr hWnd)
    {
        try
        {
            Win32.GetWindowThreadProcessId(hWnd, out uint processId);
            var process = Process.GetProcessById((int)processId);
            var processName = process.ProcessName;

            return _config.ExcludedProcesses.Any(excluded =>
                processName.Equals(excluded, StringComparison.OrdinalIgnoreCase));
        }
        catch
        {
            return false;
        }
    }

    private void CloseActiveWindow()
    {
        var activeWindow = Win32.GetForegroundWindow();
        if (activeWindow != IntPtr.Zero)
        {
            Win32.SendMessage(activeWindow, Win32.WM_CLOSE, IntPtr.Zero, IntPtr.Zero);
        }
    }

    public void Dispose()
    {
        Uninstall();
    }
}
