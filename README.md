# SmartScribe

A Flutter-based smart note-taking and transcription application.

---

## 📋 Requirements

### Flutter & Dart SDK

| Tool | Version |
|------|---------|
| Flutter | >= 3.x (stable channel) |
| Dart SDK | ^3.9.0 |

### Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `permission_handler` | ^11.3.1 | Handle runtime permissions (mic, storage, etc.) |
| `google_sign_in` | ^6.2.1 | Google OAuth authentication |
| `file_picker` | ^8.0.0 | Pick files from device storage |
| `flutter_sound` | ^9.2.13 | Audio recording and playback |
| `path_provider` | ^2.1.2 | Access device file system paths |
| `provider` | ^6.1.2 | State management |
| `intl` | ^0.20.2 | Internationalization and date formatting |
| `share_plus` | ^7.2.1 | Share content to other apps |
| `flutter_local_notifications` | ^17.2.2 | Local push notifications |
| `timezone` | ^0.9.2 | Timezone support for notifications |
| `shared_preferences` | ^2.2.2 | Persist simple key-value data locally |
| `pdf` | ^3.11.3 | Generate PDF documents |
| `printing` | ^5.11.0 | Print and preview PDFs |
| `flutter_quill` | ^9.2.0 | Rich text editor |
| `firebase_core` | ^2.25.4 | Firebase SDK core |
| `firebase_auth` | ^4.17.4 | Firebase Authentication |
| `cloud_firestore` | ^4.15.4 | Cloud Firestore database |
| `flutter_keyboard_visibility` | ^6.0.0 | Detect keyboard visibility changes |
| `cupertino_icons` | ^1.0.8 | iOS-style icons |

### Dev Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_launcher_icons` | ^0.13.1 | Generate app icons for Android & iOS |
| `flutter_lints` | ^5.0.0 | Recommended lint rules |
| `flutter_test` | SDK | Flutter testing framework |

---

## 🚀 Getting Started

### Prerequisites

1. Install [Flutter](https://docs.flutter.dev/get-started/install) (stable channel recommended)
2. Verify your setup:
   ```bash
   flutter doctor
   ```
3. Set up a [Firebase project](https://firebase.google.com/) and add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the respective platform folders.

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/smartscribe.git
   cd smartscribe
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

---

## 🏗️ Build

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web
```

---

## 📁 Assets

Place the following files in the `assets/` directory before running:

- `assets/logo.png`
- `assets/img.png`

---

## 🔧 Platform Setup

### Android
- Minimum SDK version: 21+ recommended
- Add microphone, storage, and notification permissions to `AndroidManifest.xml`

### iOS
- Add usage descriptions in `Info.plist` for microphone (`NSMicrophoneUsageDescription`) and file access permissions

---

## 📄 License

This project is private and not published to pub.dev.
