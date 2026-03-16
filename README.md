# MakLogs 🚀

[![Pub Version](https://img.shields.io/badge/pub-v1.0.0-blue.svg)](https://pub.dev/packages/mak_logs)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%E2%9C%93-brightgreen.svg)](https://flutter.dev)
[![Style: Lint](https://img.shields.io/badge/style-lint-000000.svg)](https://pub.dev/packages/flutter_lints)

**MakLogs** is a premium, high-visibility debugging toolkit for Flutter developers. It transforms your standard, monochrome console into a vibrant, traceable, and structured debugging dashboard.

---

## 📖 Table of Contents
- [✨ Key Features](#-key-features)
- [📸 Visual Showcase](#-visual-showcase)
- [📦 Installation](#-installation)
- [🛠 Quick Start](#-quick-start)
- [🎨 Professional Customization](#-professional-customization)
- [🔗 Smart Traceability](#-smart-traceability)
- [🚀 Performance & Safety](#-performance--safety)
- [📄 License](#-license)

---

## ✨ Key Features

- 🌈 **Vibrant ANSI Palette**: Instantly distinguish log levels with high-intensity neon colors.
- 📦 **The Box UI**: Elegant framing for nested JSON and API responses using UTF-8 box-drawing.
- 🔗 **Zero-Config Traceability**: Every log comes with a clickable link to the exact line of code.
- ⚙️ **Global Persistence**: Configure your theme once in `main()` and it propagates app-wide.
- ⚡ **Optimized for Speed**: Logic is automatically stripped from Release builds via `kDebugMode`.

---

## 📸 Visual Showcase

| Level | Preview |
|-------|---------|
| **Success** | ![Success](https://yyqgkczdxdjfqrvieuiz.supabase.co/storage/v1/object/public/ossisfarm/logger/warninglogs.PNG) |
| **Error** | ![Error](https://yyqgkczdxdjfqrvieuiz.supabase.co/storage/v1/object/public/ossisfarm/logger/errorlogs.PNG) |
| **Warning** | ![Warning](https://yyqgkczdxdjfqrvieuiz.supabase.co/storage/v1/object/public/ossisfarm/logger/warninglogs.PNG) |
| **Info** | ![Info](https://yyqgkczdxdjfqrvieuiz.supabase.co/storage/v1/object/public/ossisfarm/logger/infologs.PNG) |
| **Debug** | ![Debug](https://yyqgkczdxdjfqrvieuiz.supabase.co/storage/v1/object/public/ossisfarm/logger/debug.PNG) |
| **JSON Box** | ![Customization](https://yyqgkczdxdjfqrvieuiz.supabase.co/storage/v1/object/public/ossisfarm/logger/customization.PNG) |

---

## 📦 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  mak_logs: ^1.0.0
```

Run the command:
```bash
flutter pub get
```

---

## 🛠 Quick Start

### Basic Logging
Import the package and start logging immediately with the default neon theme:

```dart
import 'package:mak_logs/mak_logs.dart';

// Simple status logs
MakLog.success("Payment verified", tag: "STRIPE");
MakLog.error("User not found", tag: "DB");
MakLog.info("Cache cleared");
```

### Logging JSON/API Responses
`MakLog.logJson` automatically detects `Map`, `List`, or `String` and renders a structured box.

```dart
final userProfile = {
  "uid": "ax192",
  "name": "Ahamddev",
  "meta": {"verified": true}
};

MakLog.logJson(userProfile, title: "USER_DATA");
```

---

## 🎨 Professional Customization

For a truly customized developer experience, initialize `MakLogs` in your `main()` method.

```dart
void main() {
  MakLog.init(
    successColor: MakColors.brightCyan,   // Custom neon cyan
    successSymbol: '🚀',                   // Custom symbol
    jsonColor: MakColors.brightMagenta,    // Custom box color
    boxWidth: 100,                         // Adjust width for large screens
  );
  
  runApp(const MyApp());
}
```

### Color Palette (`MakColors`)
You can use any of these predefined static constants:
`brightRed`, `brightGreen`, `brightYellow`, `brightBlue`, `brightMagenta`, `brightCyan`, `white`.

---

## 🔗 Smart Traceability
Tired of searching where a log came from? **MakLogs** automatically appends a **Clickable File Link** at the bottom of every log.

> **Note:** On IDEs like VS Code and IntelliJ, the link (📂 `package:project/file.dart:42`) is clickable and takes you directly to the source.

---

## 🚀 Performance & Safety

**MakLogs** is designed with production in mind:
- **Zero Overhead**: In Release builds, all logging methods are short-circuited. No code execution, no console noise.
- **Truncation Support**: Handles long strings by intelligently splitting them, preventing the console from truncating your data.

---

## 🤝 Contributing
Contributions are welcome! If you have ideas for new box styles or color schemes, feel free to open a PR or Issue.

---

## 📄 License
Distributed under the **MIT License**. Created with ❤️ by **Ahamddev**.
