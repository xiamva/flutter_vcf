# flutter_vcf

Vehicle Control System - Flutter Mobile App

## Getting Started

### Prerequisites

- Flutter SDK (3.9.2+)
- Dart SDK (3.9.2+)
- Backend API running (Laravel)

### Running the App

#### Development Mode (Local API)

```bash
flutter run --dart-define=USE_LOCAL_DEV=true
```

**For specific devices:**
```bash
# Android emulator
flutter run --dart-define=USE_LOCAL_DEV=true -d android

# iOS simulator
flutter run --dart-define=USE_LOCAL_DEV=true -d ios
```

#### Production Mode

```bash
flutter run --dart-define=USE_LOCAL_DEV=false
```

### API Configuration

The app uses different API URLs based on the `USE_LOCAL_DEV` flag:

- **Development (USE_LOCAL_DEV=true)**:
  - Android Emulator: `http://10.0.2.2:8000/api/`
  - iOS Simulator/macOS: `http://localhost:8000/api/`

- **Production (USE_LOCAL_DEV=false)**:
  - Production URL: `https://your-server.com/api/` (configure in `lib/config.dart`)

### Environment Variables

Unlike Node.js, Flutter doesn't use `.env` files by default. Instead, we use `--dart-define` flags:

```bash
# Development
flutter run --dart-define=USE_LOCAL_DEV=true

# Production
flutter run --dart-define=USE_LOCAL_DEV=false
```

### Other Commands

```bash
# Install dependencies
flutter pub get

# Generate API client + models (REQUIRED after model changes)
flutter pub run build_runner build --delete-conflicting-outputs

# Build APK
flutter build apk --dart-define=USE_LOCAL_DEV=false

# Build iOS
flutter build ios --dart-define=USE_LOCAL_DEV=false
```

### Troubleshooting

**Issue: App connects to production URL instead of local**
- Make sure you're running with `--dart-define=USE_LOCAL_DEV=true`
- Check console logs for `🔧 [CONFIG]` messages to see which URL is being used

**Issue: Cannot connect to local API on Android**
- Android emulator uses `10.0.2.2` instead of `localhost`
- Make sure your backend is running and accessible

**Issue: Cannot connect to local API on iOS**
- Make sure your backend is running on `localhost:8000`
- Check firewall settings

## Project Structure

See `AGENTS.md` for detailed project structure and conventions.

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)