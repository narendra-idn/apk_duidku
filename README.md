# Duidku

A comprehensive personal finance tracking app built with Flutter. Track your income, expenses.

## Features

### ✅ Implemented Core Features

- **Clean Architecture**: Feature-first folder structure with domain, data, and presentation layers
- **Local Storage**: Hive database with migration-ready schema
- **State Management**: Flutter Riverpod for reactive state management
- **Material Design 3**: Modern UI with light and dark themes
- **Navigation**: Bottom navigation with 3 main screens
- **Monthly Dashboard**: Summary cards showing income, expenses, and net amount

### 🚧 Features In Development

- **Transaction Management**: Add income and expense entries
- **Categories**: Default and custom categories with icons and colors
- **Financial Goals**: Goal creation, progress tracking, and linking to transactions
- **Recurring Transactions**: Daily, weekly, and monthly recurring entries
- **Data Backup**: JSON export/import functionality

## Tech Stack

- **Flutter**: Latest stable version with null safety
- **State Management**: flutter_riverpod
- **Local Database**: Hive with code generation
- **Charts**: fl_chart
- **Date/Number Formatting**: intl
- **Architecture**: Clean Architecture with Repository pattern

## Setup Instructions

### Prerequisites

- Flutter SDK (3.8.0 or later)
- Dart SDK (included with Flutter)
- Android Studio / Xcode for platform-specific builds

### Installation

1. **Install dependencies**

   ```bash
   flutter pub get
   ```

2. **Generate code (Hive adapters)**

   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

3. **Enable Developer Mode (Windows)**
   ```bash
   start ms-settings:developers
   ```
   Enable Developer Mode to support symlinks required by some packages.

### Running the App

1. **Run on emulator/device**

   ```bash
   flutter run
   ```

2. **Run in release mode**
   ```bash
   flutter run --release
   ```

## Current Status

The app currently has a working foundation with:

- ✅ Complete architecture setup
- ✅ Hive database initialization
- ✅ Riverpod state management
- ✅ Basic dashboard with monthly summary
- ✅ Bottom navigation
- ✅ Theme system (light/dark)
- ✅ Default categories seeding

**Next Steps**: Implement transaction add/edit screens, category management, and complete the core transaction flows.

This is a solid foundation for a professional finance tracking app with proper architecture, state management, and extensibility.
