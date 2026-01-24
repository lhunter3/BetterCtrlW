using System.Text.Json;

namespace BetterCtrlW;

public class AppConfig
{
    public List<string> ExcludedProcesses { get; set; } = new();
    public bool AutoStartupEnabled { get; set; } = false;

    public static AppConfig Load(string filePath)
    {
        try
        {
            if (!File.Exists(filePath))
            {
                var defaultConfig = CreateDefault();
                Save(filePath, defaultConfig);
                return defaultConfig;
            }

            var json = File.ReadAllText(filePath);
            return JsonSerializer.Deserialize<AppConfig>(json) ?? CreateDefault();
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error loading config: {ex.Message}");
            return CreateDefault();
        }
    }

    public static void Save(string filePath, AppConfig config)
    {
        try
        {
            var options = new JsonSerializerOptions { WriteIndented = true };
            var json = JsonSerializer.Serialize(config, options);
            File.WriteAllText(filePath, json);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error saving config: {ex.Message}");
        }
    }

    private static AppConfig CreateDefault()
    {
        return new AppConfig
        {
            ExcludedProcesses = new List<string>
            {
                "chrome",
                "firefox",
                "msedge",
                "brave",
                "opera",
                "vivaldi",
                "code",
                "devenv",
                "rider",
                "pycharm",
                "webstorm",
                "intellij",
                "eclipse",
                "explorer",
                "excel",
                "winword",
                "powerpnt",
                "outlook",
                "notepad++",
                "sublime_text",
                "atom",
                "discord",
                "slack",
                "teams",
                "spotify",
                "steam",
                "cmd",
                "powershell",
                "windowsterminal"
            }
        };
    }
}
