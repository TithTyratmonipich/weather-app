# Weather App

A Flutter app for displaying current weather, hourly/daily forecasts, and user-set alerts for conditions like rain or high winds. Built with clean architecture, latest Flutter, state management (Provider), API integration (OpenWeatherMap via Dio), local notifications (awesome_notifications), and tests.

## Features
- Fetch current weather, hourly forecasts, and daily overviews for a specified location (using geolocator for device position or fallback).
- User-configurable alerts for weather conditions (e.g., rain probability >50%, wind >30 km/h) with local scheduled notifications.
- UI with Material 3 design, Pull refresh indicator, and settings screen for alerts.
- Cross-platform (Android/iOS tested).

## Setup and Running
1. Clone the repo: `git clone https://github.com/TithTyratmonipich/weather-app.git`
2. Install dependencies: `flutter pub get`
3. Add OpenWeatherMap API key: In `constants.dart`, set `defaultApiKey = 'your_key_here';` (get free key from https://openweathermap.org/api).
4. Run the app: `flutter run` (Android/iOS emulator/device).
5. Build release: `flutter build apk --release` or `flutter build ios --release`.

### Assumptions
- API key required for weather data (free tier sufficient).
- Location permissions handled with fallback to default (Phnom Penh).
- Hourly forecast approximated from each day data (as API provides 48-hour forecast).
- Daily forecast approximated from each day data (as API provides 8-day forecast).
- Alerts are local (no push server); test by advancing device time.

### Testing
- Unit tests: `flutter test` (covers models, usecases like alerts).
- Integration/End-to-End tests: `flutter test integration_test` (covers fetch, parsing, UI updates, alerts).
- Mocks generation: `flutter pub run build_runner build` for Mockito mocks.

### CI Configuration
- Workflow in `.github/workflows/flutter_ci.yaml`: Runs on push/PR—analyze, tests, build APK/iOS.

### Video Demo
(https://youtu.be/-pdbqebPOaI) - Shows app launch, location fetch, weather display, alert setup, and notification trigger (via time advance).

Built by TITH Tyratmonipich.
