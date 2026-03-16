import 'package:flutter/material.dart';
import 'package:mak_logs/mak_logs.dart';

void main() {
  /// STEP 1: Global Initialization (Optional but Recommended)
  /// Always call this BEFORE runApp() to set your global theme.
  /// You can use direct Material Colors or ANSI strings from MakColors.
  MakLog.init(
    successColor: Colors.orangeAccent, // Using direct Material Color
    jsonColor: Colors.amber,          // Box UI theme color
    successSymbol: '✅',               // Custom success icon
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MakLogs Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const MakLogsDemoPage(),
    );
  }
}

/// A comprehensive demo page to showcase all logging capabilities.
class MakLogsDemoPage extends StatelessWidget {
  const MakLogsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🚀 MakLogs Demo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SectionHeader(title: "Simple Logs"),
            
            /// Demonstrating Success Log
            _LogButton(
              label: "Log Success",
              icon: Icons.check_circle,
              color: Colors.green,
              onPressed: () => MakLog.success(
                "User authentication successful!",
                tag: "AUTH", // Categorize your logs using tags
              ),
            ),
            
            /// Demonstrating Error Log
            _LogButton(
              label: "Log Error",
              icon: Icons.error,
              color: Colors.red,
              onPressed: () => MakLog.error(
                "Failed to connect to server",
                tag: "SVR_404",
              ),
            ),
            
            /// Demonstrating Warning Log
            _LogButton(
              label: "Log Warning",
              icon: Icons.warning,
              color: Colors.orange,
              onPressed: () => MakLog.warning(
                "Battery level is below 15%",
                tag: "SYSTEM",
              ),
            ),
            
            /// Demonstrating Info Log
            _LogButton(
              label: "Log Info",
              icon: Icons.info,
              color: Colors.blue,
              onPressed: () => MakLog.info(
                "Application cache has been cleared",
                tag: "CACHE",
              ),
            ),
            
            /// Demonstrating Debug Log
            _LogButton(
              label: "Log Debug",
              icon: Icons.bug_report,
              color: Colors.purple,
              onPressed: () => MakLog.debug(
                "Rendering took 16.6ms at Frame #402",
                tag: "GFX",
              ),
            ),
            
            const SizedBox(height: 30),
            const _SectionHeader(title: "The Box UI (JSON)"),
            
            /// Demonstrating the sophisticated Box UI for structured data.
            _LogButton(
              label: "Log API Response (JSON)",
              icon: Icons.terminal,
              color: Colors.cyan,
              onPressed: () {
                final Map<String, dynamic> sampleData = {
                  "id": 101,
                  "name": "Ahamddev",
                  "projects": ["MakLogs", "CustomPickers", "SchoolManager"],
                  "status": "Online",
                  "stats": {"commits": 1240, "stars": 450},
                };
                
                /// Renders the data in an organized, framed box in the console.
                MakLog.logJson(
                  sampleData, 
                  title: "GET_USER_PROFILE", // Title displayed in the top border
                );
              },
            ),
            
            const SizedBox(height: 30),
            const _SectionHeader(title: "On-the-fly Customization"),
            
            /// Show how logs can be re-configured even after initial setup.
            _LogButton(
              label: "Theme: Neon Cyan",
              icon: Icons.palette,
              color: Colors.cyan,
              onPressed: () {
                MakLog.init(
                  successColor: MakColors.brightCyan,
                  jsonColor: MakColors.brightCyan,
                  successSymbol: '🚀',
                );
                
                MakLog.success("Global colors updated to Cyan via init()!");
                MakLog.logJson({"status": "Initialized cleanly"});
              },
            ),
            
            /// Reset to original neon defaults.
            _LogButton(
              label: "Reset to Default",
              icon: Icons.refresh,
              color: Colors.white,
              onPressed: () {
                MakLog.init(
                  successColor: MakColors.brightGreen,
                  jsonColor: MakColors.magenta,
                  successSymbol: '✅',
                );
                
                MakLog.info("Logger reset via init()");
              },
            ),
            
            const SizedBox(height: 20),
            const Text(
              "Check your debug console to see the magic! ✨",
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

/// Internal helper for section titles in the UI.
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: Colors.grey,
        ),
      ),
    );
  }
}

/// A custom styled button for triggering logs in the demo.
class _LogButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _LogButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.2), // Highlighing with subtle background
          side: BorderSide(color: color, width: 1.5),  // Bold border to match neon theme
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
