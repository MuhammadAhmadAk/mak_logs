import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// ANSI Color constants for easy customization
class MakColors {
  static const String reset = '\x1B[0m';
  
  // Standard escape codes for simple use
  static const String brightRed = '\x1B[91m';
  static const String brightGreen = '\x1B[92m';
  static const String brightYellow = '\x1B[93m';
  static const String brightBlue = '\x1B[94m';
  static const String magenta = '\x1B[35m';
  static const String brightCyan = '\x1B[96m';

  /// Converts a Flutter [Color] to an ANSI 24-bit truecolor escape sequence
  static String fromColor(Color color) {
    return '\x1B[38;2;${color.red};${color.green};${color.blue}m';
  }
}

/// MakLog - A high-visibility, color-coded debugging class for Flutter.
class MakLog {
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

  /// Initialize global defaults once in your main().
  /// Supports both ANSI strings and Flutter [Color] objects.
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

  static String _parseColor(dynamic color) {
    if (color is String) return color;
    if (color is Color) return MakColors.fromColor(color);
    return MakColors.reset;
  }

  // --- LOG METHODS ---

  static void success(String message, {String? tag}) {
    _log(message, tag ?? 'SUCCESS', 'SUCCESS', _successColor, _successSymbol);
  }

  static void error(String message, {String? tag}) {
    _log(message, tag ?? 'ERROR', 'ERROR', _errorColor, _errorSymbol);
  }

  static void warning(String message, {String? tag}) {
    _log(message, tag ?? 'WARNING', 'WARNING', _warningColor, _warningSymbol);
  }

  static void info(String message, {String? tag}) {
    _log(message, tag ?? 'INFO', 'INFO', _infoColor, _infoSymbol);
  }

  static void debug(String message, {String? tag}) {
    _log(message, tag ?? 'DEBUG', 'DEBUG', _debugColor, _debugSymbol);
  }

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
    
    final String topBorder = '┌' + '─' * leftPadding + ' $title ' + '─' * rightPadding + '┐';
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
    
    debugPrint('$color└' + '─' * innerWidth + '┘${MakColors.reset}');
    debugPrint('$color📂 $trace${MakColors.reset}\n');
  }

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
