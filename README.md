# English with Dari — AI Learning App

Flutter chat app for Dari speakers learning English (Gemini API, no backend).

## Folder structure

```
english_with_dari/
├── pubspec.yaml
├── .env.example
├── codemagic.yaml
└── lib/
    ├── main.dart
    ├── config/api_config.dart
    ├── models/chat_message.dart
    ├── services/gemini_service.dart
    ├── screens/chat_screen.dart
    └── widgets/
        ├── message_bubble.dart
        └── chat_input.dart
```

## 1. Setup (one-time)

Requires Flutter SDK + Android command-line tools (no Android Studio GUI needed).

```bash
flutter create --org com.darienglish --platforms android .
```

Run this inside the `english_with_dari` folder (it generates the `android/` folder).
Then overwrite/keep `lib/` and `pubspec.yaml` as provided.

```bash
flutter pub get
```

## 2. API key (secure handling)

1. Get a free Gemini API key: https://aistudio.google.com/app/apikey
2. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```
3. Open `.env` and set:
   ```
   GEMINI_API_KEY=your_real_key_here
   ```
4. `.env` is gitignored — never commit it.

## 3. Run on device/emulator

```bash
flutter run
```

## 4. Build APK (Flutter CLI, no Android Studio)

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

## 5. Build APK with Codemagic (alternative)

1. Push project to GitHub/GitLab (without `.env`).
2. Connect repo to Codemagic.
3. In Codemagic → Environment variables, create group `gemini_keys` with variable `GEMINI_API_KEY` (mark as secret).
4. Codemagic uses the included `codemagic.yaml` to write `.env` and build the APK automatically.
5. Download the APK from the build artifacts.
