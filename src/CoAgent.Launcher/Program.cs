using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Runtime.Versioning;
using System.Windows.Forms;

namespace CoAgent.Launcher
{
    [SupportedOSPlatform("windows")]
    internal static class Program
    {
        private static string Home => Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);
        private static string CoAgentDir => Path.Combine(Home, ".CoAgent");
        private static string ConsentPath => Path.Combine(CoAgentDir, "consent.json");
        private static string CoTrayExe => Path.Combine(Home, "Documents", "GitHub", "CoAgent", "src", "CoTray", "bin", "Release", "net8.0-windows", "CoTray.exe");

        [STAThread]
        static void Main()
        {
            Application.SetHighDpiMode(HighDpiMode.SystemAware);
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            if (!HasAccepted())
            {
                var r = MessageBox.Show(
                    "Start a BPOE session?\n\n- Nothing autostarts.\n- You can revoke consent anytime by deleting ~/.CoAgent/consent.json.\n- See docs/policy/AUTOSTART_AND_CONSENT.md",
                    "CoAgent — Consent",
                    MessageBoxButtons.OKCancel,
                    MessageBoxIcon.Information);

                if (r != DialogResult.OK) return;

                Directory.CreateDirectory(CoAgentDir);
                File.WriteAllText(ConsentPath, "{ \"version\": 1, \"accepted\": true, \"autostart\": false }");
            }

            // Start CoTray (helper), but only if present
            if (File.Exists(CoTrayExe))
            {
                try { Process.Start(new ProcessStartInfo(CoTrayExe) { UseShellExecute = true }); }
                catch (Exception ex)
                {
                    MessageBox.Show($"Failed to launch CoTray: {ex.Message}", "CoAgent", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
            else
            {
                MessageBox.Show("CoTray not found. Build it first: dotnet build src/CoTray/CoTray.csproj -c Release", "CoAgent", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }

            // TODO: kick off BPOE heartbeat/guard jobs here if/when the user chooses (e.g., another dialog)
            // For now, exit after starting helper to keep behavior explicit.
        }

        private static bool HasAccepted()
        {
            try
            {
                if (!File.Exists(ConsentPath)) return false;
                var json = File.ReadAllText(ConsentPath);
                return json.Contains("\"accepted\":", StringComparison.OrdinalIgnoreCase)
                    && json.Contains("true", StringComparison.OrdinalIgnoreCase);
            }
            catch { return false; }
        }
    }
}
