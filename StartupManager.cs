using Microsoft.Win32;
using System.Reflection;

namespace BetterCtrlW;

public static class StartupManager
{
    private const string RunKey = @"Software\Microsoft\Windows\CurrentVersion\Run";
    private const string AppName = "BetterCtrlW";

    public static bool IsEnabled()
    {
        try
        {
            using var key = Registry.CurrentUser.OpenSubKey(RunKey, false);
            var value = key?.GetValue(AppName);
            return value != null;
        }
        catch
        {
            return false;
        }
    }

    public static bool Enable()
    {
        try
        {
            var exePath = Assembly.GetExecutingAssembly().Location;

            // For single-file published apps, use Environment.ProcessPath
            if (string.IsNullOrEmpty(exePath) || exePath.EndsWith(".dll"))
            {
                exePath = Environment.ProcessPath ?? exePath;
            }

            using var key = Registry.CurrentUser.OpenSubKey(RunKey, true);
            key?.SetValue(AppName, $"\"{exePath}\"");
            return true;
        }
        catch
        {
            return false;
        }
    }

    public static bool Disable()
    {
        try
        {
            using var key = Registry.CurrentUser.OpenSubKey(RunKey, true);
            key?.DeleteValue(AppName, false);
            return true;
        }
        catch
        {
            return false;
        }
    }
}
