using System;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Runtime.Versioning;
using System.Threading;
using System.Windows.Forms;

namespace CoTray
{
    [SupportedOSPlatform("windows")]
    internal static class Program
    {
        private static NotifyIcon? _tray;
        private static FileSystemWatcher? _watcher;
        private static System.Windows.Forms.Timer? _poll;
        private static string Home => Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);
        private static string StatusDir => Path.Combine(Home, "CoTemps", "status");
        private static string CoCacheDir => Path.Combine(Home, "CoCache");
        private static string CoHeartbeatScript => Path.Combine(Home, "Documents", "WindowsPowerShell", "Modules", "CoBPOE", "CoHeartbeat.ps1");
        private static DateTime _lastUpdate = DateTime.MinValue;

        [STAThread]
        static void Main()
        {
            Application.SetHighDpiMode(HighDpiMode.SystemAware);
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            Directory.CreateDirectory(StatusDir);

            _tray = new NotifyIcon { Visible = true, Text = "CoAgent OE Monitor" };

            var menu = new ContextMenuStrip();
            menu.Items.Add("Rotate Session Now", null, (_, __) => TouchOk());
            menu.Items.Add(new ToolStripSeparator());
            menu.Items.Add("Pause Heartbeat (Stop Job)", null, (_, __) => RunPwsh("Stop-Job -Name CoHeartbeat -ErrorAction SilentlyContinue"));
            menu.Items.Add("Resume Heartbeat", null, (_, __) =>
                RunPwsh($"Start-Job -Name CoHeartbeat -FilePath '{CoHeartbeatScript.Replace("'", "''")}' -ArgumentList 60 | Out-Null"));
            menu.Items.Add(new ToolStripSeparator());
            menu.Items.Add("Open CoCache folder", null, (_, __) => Open(CoCacheDir));
            menu.Items.Add("Open Status folder", null, (_, __) => Open(StatusDir));
            menu.Items.Add(new ToolStripSeparator());
            menu.Items.Add("Exit", null, (_, __) => { _tray!.Visible = false; Application.Exit(); });
            _tray.ContextMenuStrip = menu;

            _watcher = new FileSystemWatcher(StatusDir)
            {
                NotifyFilter = NotifyFilters.LastWrite | NotifyFilters.FileName | NotifyFilters.CreationTime,
                Filter = "SESSION_*.txt",
                IncludeSubdirectories = false,
                EnableRaisingEvents = true
            };
            _watcher.Changed += (_, __) => DebouncedRefresh();
            _watcher.Created += (_, __) => DebouncedRefresh();
            _watcher.Deleted += (_, __) => DebouncedRefresh();
            _watcher.Renamed += (_, __) => DebouncedRefresh();

            _poll = new System.Windows.Forms.Timer { Interval = 5000 };
            _poll.Tick += (_, __) => RefreshState();
            _poll.Start();

            RefreshState();
            Application.Run();
        }

        private static readonly object _debounceLock = new();
        private static System.Threading.Timer? _debounceTimer;
        private static void DebouncedRefresh()
        {
            lock (_debounceLock)
            {
                _debounceTimer?.Dispose();
                _debounceTimer = new System.Threading.Timer(_ => RefreshState(), null, 250, Timeout.Infinite);
            }
        }

        private static void RefreshState()
        {
            try
            {
                (string glyph, string label, Icon icon) = GetState();
                _tray!.Icon = icon;
                _tray.Text = $"OE:{label}";
                _lastUpdate = DateTime.Now;
            }
            catch
            {
                _tray!.Icon = SystemIcons.Application;
                _tray.Text = "OE:unknown";
            }
        }

        private static (string glyph, string label, Icon icon) GetState()
        {
            var ok   = File.Exists(Path.Combine(StatusDir, "SESSION_OK.txt"));
            var warn = File.Exists(Path.Combine(StatusDir, "SESSION_WARN.txt"));
            var fail = File.Exists(Path.Combine(StatusDir, "SESSION_FAIL.txt"));

            if (fail) return ("✖", "FAIL", SystemIcons.Error);
            if (warn) return ("▲", "WARN", SystemIcons.Warning);
            if (ok)   return ("✔", "OK",   SystemIcons.Information);
            return ("·", "IDLE", SystemIcons.Application);
        }

        private static void TouchOk()
        {
            try
            {
                Directory.CreateDirectory(StatusDir);
                var f = Path.Combine(StatusDir, "SESSION_OK.txt");
                File.WriteAllText(f, DateTime.UtcNow.ToString("o"));
                RefreshState();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Rotate failed: {ex.Message}", "CoAgent", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private static void Open(string path)
        {
            try
            {
                Directory.CreateDirectory(path);
                Process.Start(new ProcessStartInfo("explorer.exe", path) { UseShellExecute = true });
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Open failed: {ex.Message}", "CoAgent", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private static void RunPwsh(string command)
        {
            try
            {
                var shell = FindExeInPath("pwsh.exe") ?? FindExeInPath("powershell.exe") ?? "powershell.exe";
                var psi = new ProcessStartInfo(shell, $"-NoLogo -NoProfile -Command {EscapeForShell(command)}")
                {
                    UseShellExecute = false,
                    CreateNoWindow = true
                };
                Process.Start(psi);
            }
            catch (Exception ex)
            {
                MessageBox.Show($"PowerShell command failed: {ex.Message}", "CoAgent", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private static string? FindExeInPath(string name)
        {
            var paths = (Environment.GetEnvironmentVariable("PATH") ?? "").Split(Path.PathSeparator);
            foreach (var p in paths)
            {
                try
                {
                    var candidate = Path.Combine(p.Trim(), name);
                    if (File.Exists(candidate)) return candidate;
                }
                catch {}
            }
            return null;
        }

        private static string EscapeForShell(string s) => $"\"{s.Replace("\"", "`\"")}\"";
    }
}
