# Economic Influence

A Flutter application for tracking and visualizing the economic influence of spending decisions by showing where money flows to major shareholders.

## Features

- Monthly, weekly, and daily spending reports
- Visualization of spending flow to major shareholders
- Receipt scanning capability
- Manual purchase entry
- Public record tracking of shareholder actions

## Getting Started

This project requires Flutter SDK ^3.10.7.

### Prerequisites

- Flutter SDK
- Dart SDK

### Installation

```bash
flutter pub get
```

### Running the App

```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 - App entry point
├── models/                   - Data models
│   └── monthly_report.dart  - Spending report models
├── screens/                  - App screens
│   ├── monthly_report_screen.dart
│   ├── add_purchase_screen.dart
│   └── receipt_scanner_screen.dart
├── widgets/                  - Reusable UI components
├── services/                 - Business logic services
├── data/                     - Data providers and generators
└── theme/                    - App theming
```

## Dependencies

- cupertino_icons: ^1.0.8
- uuid: ^4.0.0
- image_picker: ^1.0.0
- google_mlkit_text_recognition: ^0.11.0
- sqflite: ^2.4.0
- path: ^1.8.4
- shared_preferences: ^2.1.2

## License

This project is private and not published to pub.dev.
