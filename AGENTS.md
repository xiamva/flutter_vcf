# Flutter VCF - Mobile App

**Generated:** 2026-01-22
**Commit:** 6228c4f
**Branch:** main

## OVERVIEW

Flutter mobile app for palm oil mill operators. Handles QC sampling, lab testing, and unloading workflows for CPO/POME/PK commodities.

## STRUCTURE

```text
lib/
├── main.dart              # App entry, MaterialApp setup
├── login.dart             # Auth screen + navigation hub
├── api_service.dart       # Retrofit API definitions
├── api_service.g.dart     # Generated (DO NOT EDIT)
├── CPO/                   # Crude Palm Oil screens
│   ├── Sample CPO/        # QC sampling
│   ├── Lab CPO/           # Lab testing
│   └── Unloading CPO/     # Unloading
├── PK/                    # Palm Kernel (same structure)
├── POME/                  # Palm Oil Mill Effluent (same structure)
├── Manager/               # Ticket verification screens
│   ├── CPO/
│   ├── PK/
│   └── POME/
└── models/                # Data models (mostly generated)
    ├── response/          # API response models
    ├── pk/response/
    ├── pome/response/
    └── master/            # Tank, Hole models
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Add API endpoint | `lib/api_service.dart` | Then run build_runner |
| New response model | `lib/models/{commodity}/response/` | Add .dart, run build_runner |
| Commodity screen | `lib/{CPO,PK,POME}/{action}/` | Follow existing pattern |
| Manager screens | `lib/Manager/{commodity}/` | Ticket verification |
| Auth token | `login.dart` | SharedPreferences key: `token` |

## CONVENTIONS

### File Naming
- Screens: `home_{feature}.dart`, `input_{feature}.dart`, `add_{feature}.dart`
- Models: `{entity}_response.dart` + `.g.dart` (generated)

### Screen Pattern
Each commodity has 3 workflows, each with:
- `home_*.dart` - List/statistics view
- `input_*.dart` - Form input (large files, 500-1000 lines)
- `add_*.dart` - Add new item flow

### API Usage
```dart
// Get token from SharedPreferences
final prefs = await SharedPreferences.getInstance();
final token = prefs.getString('jwt_token') ?? '';

// Use Retrofit client with AppConfig
final api = ApiService(AppConfig.createDio());
final response = await api.getQcSamplingStats("Bearer $token");
```

### State Management
- **NO** state management library (Provider, Riverpod, Bloc)
- Uses `StatefulWidget` with `setState()`
- API calls in `initState()` or button handlers

## ANTI-PATTERNS (FORBIDDEN)

- **NEVER** edit `*.g.dart` files - they're generated
- **NEVER** hardcode API URL - use `AppConfig.createDio()` from `config.dart`
- **NEVER** skip `flutter pub run build_runner build` after model changes
- **NEVER** mix commodities in single screen - keep CPO/PK/POME separate

## COMMANDS

```bash
# Install dependencies
flutter pub get

# Generate API client + models (REQUIRED after changes)
flutter pub run build_runner build --delete-conflicting-outputs

# Run on device/emulator
flutter run

# Build APK
flutter build apk
```

## DEPENDENCIES

| Package | Purpose |
|---------|---------|
| dio | HTTP client |
| retrofit | API code generation |
| json_serializable | Model code generation |
| shared_preferences | Local storage (auth token) |
| image_picker | Photo capture |
| flutter_image_compress | Image compression |

## NOTES

- API base URL configured in `lib/config.dart` via `AppConfig.apiBaseUrl`
- Photos sent as base64 strings
- PK commodity has resampling counter (0/1/2)
- Large input_*.dart files (500-1000 lines) - consider refactoring
- Directory names with spaces (`Lab CPO/`) - use URL encoding in imports
