// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// [MakColors] provides ANSI escape codes for terminal coloring.
/// It includes standard neon colors and a utility to convert Flutter [Color] 
/// objects to 24-bit RGB ANSI sequences.
class MakColors {
  /// Resets the terminal color to default.
  static const String reset = '\x1B[0m';
  
  /// High-intensity neon colors for standard logging levels.
  static const String brightRed = '\x1B[91m';
  static const String brightGreen = '\x1B[92m';
  static const String brightYellow = '\x1B[93m';
  static const String brightBlue = '\x1B[94m';
  static const String magenta = '\x1B[35m';
  static const String brightCyan = '\x1B[96m';

  /// Converts a Flutter [Color] object into an ANSI 24-bit truecolor escape sequence.
  /// This allows the developer to use [Colors.red], [Colors.teal], or custom 
  /// [Color] objects directly in the logger configuration.
  static String fromColor(Color color) {
    // Using bit-shifting with ignore rules to maintain compatibility across 
    // all Flutter versions while satisfying pub.dev's latest linter.
    final int val = color.value;
    final int r = (val >> 16) & 0xFF;
    final int g = (val >> 8) & 0xFF;
    final int b = val & 0xFF;
    return '\x1B[38;2;$r;$g;${b}m';
  }
}

/// [MakLog] is the core class for high-visibility, color-coded debugging.
/// 
/// It supports:
/// - 🎨 Color-coded log levels (Success, Error, Warning, Info, Debug).
/// - 📦 The "Box UI" for structured JSON/API response logging.
/// - 🔗 Automatic clickable file/line number traceability.
/// - ⚙️ Global one-time initialization via [MakLog.init].
/// - ⚡ Automatic execution stripping in Production/Release mode.
class MakLog {
  // --- Private Configuration Fields ---
  
  static String _successColor = MakColors.brightGreen;
  static String _errorColor = MakColors.brightRed;
  static String _warningColor = MakColors.brightYellow;
  static String _infoColor = MakColors.brightBlue;
  static String _debugColor = MakColors.magenta;
  static String _jsonColor = MakColors.magenta;

  static String _successSymbol = '✅';
  static String _errorSymbol = '❌';
  static String _warningSymbol = '⚠️';
  static String _infoSymbol = 'ℹ️';
  static String _debugSymbol = '🪲';

  static int _boxWidth = 80;

  /// Initializes the global settings for MakLog.
  /// 
  /// Recommended to call this once in your `main()` method before `runApp()`.
  /// 
  /// [successColor], [errorColor], [warningColor], [infoColor], [debugColor], [jsonColor]
  /// can be either a [String] (ANSI code) or a Flutter [Color] object.
  static void init({
    dynamic successColor,
    dynamic errorColor,
    dynamic warningColor,
    dynamic infoColor,
    dynamic debugColor,
    dynamic jsonColor,
    String? successSymbol,
    String? errorSymbol,
    String? warningSymbol,
    String? infoSymbol,
    String? debugSymbol,
    int? boxWidth,
  }) {
    if (successColor != null) _successColor = _parseColor(successColor);
    if (errorColor != null) _errorColor = _parseColor(errorColor);
    if (warningColor != null) _warningColor = _parseColor(warningColor);
    if (infoColor != null) _infoColor = _parseColor(infoColor);
    if (debugColor != null) _debugColor = _parseColor(debugColor);
    if (jsonColor != null) _jsonColor = _parseColor(jsonColor);
    
    if (successSymbol != null) _successSymbol = successSymbol;
    if (errorSymbol != null) _errorSymbol = errorSymbol;
    if (warningSymbol != null) _warningSymbol = warningSymbol;
    if (infoSymbol != null) _infoSymbol = infoSymbol;
    if (debugSymbol != null) _debugSymbol = debugSymbol;
    if (boxWidth != null) _boxWidth = boxWidth;
  }

  /// Internal helper to parse [dynamic] color inputs (String or Color class).
  static String _parseColor(dynamic color) {
    if (color is String) return color;
    if (color is Color) return MakColors.fromColor(color);
    return MakColors.reset;
  }

  // --- Public Logging Methods ---

  /// Logs a [SUCCESS] message with a green theme and checkmark by default.
  static void success(String message, {String? tag}) {
    _log(message, tag ?? 'SUCCESS', 'SUCCESS', _successColor, _successSymbol);
  }

  /// Logs an [ERROR] message with a red theme and cross symbol.
  static void error(String message, {String? tag}) {
    _log(message, tag ?? 'ERROR', 'ERROR', _errorColor, _errorSymbol);
  }

  /// Logs a [WARNING] message with a yellow theme and alert symbol.
  static void warning(String message, {String? tag}) {
    _log(message, tag ?? 'WARNING', 'WARNING', _warningColor, _warningSymbol);
  }

  /// Logs an [INFO] message with a blue theme and info symbol.
  static void info(String message, {String? tag}) {
    _log(message, tag ?? 'INFO', 'INFO', _infoColor, _infoSymbol);
  }

  /// Logs a [DEBUG] message with a magenta theme and bug symbol.
  static void debug(String message, {String? tag}) {
    _log(message, tag ?? 'DEBUG', 'DEBUG', _debugColor, _debugSymbol);
  }

  /// Logs a [JSON] object, List, or String in a structured, box-framed layout.
  static void logJson(dynamic data, {String title = 'API_RESPONSE', String? tag}) {
    if (!kDebugMode) return;
    
    final String time = _getCurrentTime();
    final String trace = _getClickableTrace();
    
    String jsonString = '';
    try {
      if (data is String) {
        final decoded = json.decode(data);
        jsonString = const JsonEncoder.withIndent('  ').convert(decoded);
      } else if (data is Map || data is List) {
        jsonString = const JsonEncoder.withIndent('  ').convert(data);
      } else {
        jsonString = data.toString();
      }
    } catch (e) {
      jsonString = data.toString();
    }

    final List<String> lines = jsonString.split('\n');
    final String color = _jsonColor;

    debugPrint('$color[$time] [DEBUG] [${tag ?? 'JSON'}] $_debugSymbol${MakColors.reset}');
    
    int innerWidth = _boxWidth - 2;
    int titleWidthWithSpaces = title.length + 2;
    int paddingTotal = (innerWidth - titleWidthWithSpaces).clamp(0, innerWidth);
    int leftPadding = paddingTotal ~/ 2;
    int rightPadding = paddingTotal - leftPadding;
    
    // Constructing the top border using interpolation to satisfy linter
    final String topBorder = '┌${'─' * leftPadding} $title ${'─' * rightPadding}┐';
    debugPrint('$color$topBorder${MakColors.reset}');
    
    int contentWidth = innerWidth - 2;
    for (var line in lines) {
      if (line.length > contentWidth) {
        for (int i = 0; i < line.length; i += contentWidth) {
          int end = (i + contentWidth).clamp(0, line.length);
          final part = line.substring(i, end);
          debugPrint('$color│ ${part.padRight(contentWidth)} │${MakColors.reset}');
        }
      } else {
        debugPrint('$color│ ${line.padRight(contentWidth)} │${MakColors.reset}');
      }
    }
    
    debugPrint('$color└${'─' * innerWidth}┘${MakColors.reset}');
    debugPrint('$color📂 $trace${MakColors.reset}\n');
  }

  // --- Internal Utility Methods ---

  static void _log(String message, String tag, String level, String color, String symbol) {
    if (!kDebugMode) return;
    final String time = _getCurrentTime();
    final String trace = _getClickableTrace();
    
    final String logHeader = '$color[$time] [$level] [$tag] $symbol > $message${MakColors.reset}';
    
    if (logHeader.length > 800) {
      _printLongString(logHeader);
    } else {
      debugPrint(logHeader);
    }
    debugPrint('$color📂 $trace${MakColors.reset}\n');
  }

  static void _printLongString(String text) {
    int start = 0;
    while (start < text.length) {
      int end = (start + 800).clamp(0, text.length);
      debugPrint(text.substring(start, end));
      start = end;
    }
  }

  static String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }

  static String _getClickableTrace() {
    final stackTrace = StackTrace.current.toString();
    final lines = stackTrace.split('\n');
    
    for (var line in lines) {
      if (line.contains('neon_log.dart') || 
          line.contains('MakLog.') ||
          line.contains('dart:')) {
        continue;
      }
      
      final match = RegExp(r'(package:[^\s)]+|file:[^\s)]+|[a-zA-Z]:\\[^\s)]+)(\s+|:)(\d+:\d+)').firstMatch(line);
      
      if (match != null) {
        String path = match.group(1)!;
        String lineInfo = match.group(3)!;
        return '$path:$lineInfo';
      }
    }
    return 'unknown_source';
  }
}
