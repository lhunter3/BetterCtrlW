using BetterCtrlW;
using System.Drawing;
using System.Windows.Forms;

ApplicationConfiguration.Initialize();

var configPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Config.json");
var config = AppConfig.Load(configPath);

// Sync auto-startup state on launch
if (config.AutoStartupEnabled && !StartupManager.IsEnabled())
{
    StartupManager.Enable();
}
else if (!config.AutoStartupEnabled && StartupManager.IsEnabled())
{
    StartupManager.Disable();
}

var hook = new KeyboardHook(config);
hook.Install();

// Load custom icon from embedded resource or fall back to system icon
Icon appIcon;
var iconPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "app.ico");
if (File.Exists(iconPath))
{
    appIcon = new Icon(iconPath);
}
else
{
    appIcon = SystemIcons.Application;
}

using var trayIcon = new NotifyIcon
{
    Icon = appIcon,
    Visible = true,
    Text = "Better Ctrl+W - Window Closer"
};

var contextMenu = new ContextMenuStrip();

// Reload Config menu item
contextMenu.Items.Add("Reload Config", null, (s, e) =>
{
    var newConfig = AppConfig.Load(configPath);
    hook.UpdateConfig(newConfig);
    config = newConfig;
    MessageBox.Show("Configuration reloaded!", "Better Ctrl+W", MessageBoxButtons.OK, MessageBoxIcon.Information);
});

// Start with Windows menu item
var startupMenuItem = new ToolStripMenuItem("Start with Windows")
{
    Checked = StartupManager.IsEnabled(),
    CheckOnClick = true
};
startupMenuItem.Click += (s, e) =>
{
    var menuItem = (ToolStripMenuItem)s!;
    if (menuItem.Checked)
    {
        if (StartupManager.Enable())
        {
            config.AutoStartupEnabled = true;
            AppConfig.Save(configPath, config);
        }
        else
        {
            menuItem.Checked = false;
            MessageBox.Show("Failed to enable auto-startup. Please run as administrator.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
    }
    else
    {
        if (StartupManager.Disable())
        {
            config.AutoStartupEnabled = false;
            AppConfig.Save(configPath, config);
        }
        else
        {
            menuItem.Checked = true;
            MessageBox.Show("Failed to disable auto-startup.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
    }
};
contextMenu.Items.Add(startupMenuItem);

// Separator and Exit
contextMenu.Items.Add(new ToolStripSeparator());
contextMenu.Items.Add("Exit", null, (s, e) =>
{
    hook.Dispose();
    Application.Exit();
});

trayIcon.ContextMenuStrip = contextMenu;

trayIcon.BalloonTipTitle = "Better Ctrl+W";
trayIcon.BalloonTipText = "Ctrl+W window closer is now running!";
trayIcon.ShowBalloonTip(2000);

Application.Run();
