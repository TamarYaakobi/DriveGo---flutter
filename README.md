# DriveGo (Flutter) 🚗📱

The mobile (Flutter) version of DriveGo, a car rental app. Users can browse and search cars, view details and reviews, sign up/sign in via Firebase Auth, save favorites, and add cars to the fleet — with offline support via a local SQLite cache.

## Features

- Browse & search cars (`cars_screen.dart`)
- Car details with reviews (`car_details_screen.dart`)
- Sign up / sign in with Firebase Authentication
- Favorites, persisted via `favorites_provider.dart`
- Add a new car, with image upload (`add_car_screen.dart`, `image_picker`)
- About Us screen
- Local caching with `sqflite` for offline access
- Connectivity awareness (`connectivity_plus`)

## Project Structure

```
lib/
├── models/       # Data models (Car, Review, User)
├── providers/     # State management (Provider package) — auth, cars, favorites, reviews
├── screens/        # App screens (Home, Cars, CarDetails, SignIn, SignUp, AddCar, Favorites, AboutUs)
├── services/        # Firebase/API calls, local SQLite (database_helper.dart), shared prefs
├── theme/            # App-wide theming
├── widgets/           # Reusable UI widgets (nav bar, favorite button)
├── firebase_options.dart
└── main.dart
```

## Getting Started

### Prerequisites
- Flutter SDK (^3.10.7)
- A configured Firebase project (Auth, Firestore, Storage)

### Installation

```bash
flutter pub get
```

### Firebase Setup

This project uses Firebase (Auth, Firestore, Storage). Make sure you have:
- `google-services.json` in `android/app/` (Android)
- `GoogleService-Info.plist` in `ios/Runner/` (iOS)
- `lib/firebase_options.dart` generated via `flutterfire configure`

> These files are environment-specific and should **not** be committed — see `.gitignore`.

### Run

```bash
flutter run
```

## Tech Stack

- Flutter & Dart
- Firebase (Auth, Cloud Firestore, Storage)
- Provider (state management)
- sqflite (local/offline storage)
- image_picker, url_launcher, connectivity_plus, shared_preferences
