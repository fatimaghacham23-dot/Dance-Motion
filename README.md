# Dance Motion

Dance Motion is a Flutter 3 / Dart 3 mock MVP that showcases a polished music discovery flow with local data, preferences, and offline-friendly state.

## Highlights

- **Provider + Shared Preferences** keep theme, username, wishlist, and optional profile image in sync.
- **No backend**; every piece of data lives in `lib/data/mock_data.dart` and in-memory state.
- **Stateful experience** with BottomNavigationBar + IndexedStack to preserve page state (Home, Wishlist, Account).
- **Full feature set**: Auto rotating banner, searchable music list, category drill-down, wishlist, music detail view, add-music form, and account controls (profile avatar, editable name, theme switcher, image picker).

## Project structure

- `lib/main.dart`: entry point with theming, Provider wiring, and navigation shell.
- `lib/data/`: mock catalog data (music, categories, ads).
- `lib/models/`: data classes for music, category, and banner items.
- `lib/state/app_state.dart`: ChangeNotifier that manages theme, username, profile photo, liked IDs, and user-added music.
- `lib/screens/` and `lib/widgets/`: all UI surfaces required by the spec.

## How to run

1. Ensure Flutter (>=3) and Dart (>=3) are installed on your machine.
2. In a separate directory, run `flutter create dance_motion` to generate the native platform scaffolding that this repo lacks.
3. Replace `lib/` and `pubspec.yaml` inside the generated project with the contents from this template.
4. From that project root, run:
   ```
   flutter pub get
   flutter run
   ```

> **Note:** The workspace provided here intentionally omits Android/iOS/etc. folders because the CLI tooling isn't available in this environment. Step 2 above ensures you still get a fully runnable Flutter app.
