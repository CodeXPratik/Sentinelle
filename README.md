# Sentinelle - Smart Tourist Safety App (Internal Documentation)

Welcome to the **Sentinelle** development team! This document provides information for team members to get started and contribute to the project.

## Development Workflow

1.  **Branching**: Create a new branch for each feature or bug fix (`feature/your-feature` or `bugfix/your-fix`).
2.  **Pull Requests**: Submit a PR for review before merging into the `main` branch.
3.  **Code Style**: Follow standard Flutter/Dart linting rules. Ensure `flutter analyze` passes before pushing.

## Setup for Team Members

### 1. Environment Configuration
Ensure you have the following installed:
- Flutter SDK (Check `pubspec.yaml` for required version)
- Dart SDK
- Android SDK & Xcode (for iOS)
- Firebase CLI (`npm install -g firebase-tools`)
- FlutterFire CLI (`dart pub global activate flutterfire_cli`)

### 2. Firebase Access
- Ask the Project Admin to add your email to the Firebase Project.
- Run `flutterfire configure` to update your local `firebase_options.dart`.

### 3. Google Maps API
- Obtain the Google Maps API Key from the team lead.
- Ensure the key is added to your local `local.properties` (or as specified in `AndroidManifest.xml`).

### 4. Running the App
```bash
flutter pub get
flutter run
```

## Project Architecture

- **UI Layer**: Located in `lib/views/`. We use a widget-based approach for UI components (`lib/views/widgets/`) and screens (`lib/views/pages/`).
- **State Management**: Currently using `StatefulWidget`. (Note: We may transition to a state management solution like Provider or Riverpod as the project grows).
- **Backend Services**: Firebase integration is handled via `firebase_core`, `firebase_auth`, and `cloud_firestore`.
- **Navigation**: Managed via `WidgetTree` for auth-state dependent navigation.

## Key Files & Directories

- `lib/main.dart`: App entry point and Firebase initialization.
- `lib/views/widget_tree.dart`: Handles authentication state and navigation flow.
- `lib/views/widgets/glass_container.dart`: Custom glassmorphism container used across the app.
- `lib/firebase_options.dart`: Auto-generated configuration (do not edit manually).

## Contribution Guidelines

- **Commit Messages**: Use clear and descriptive commit messages (e.g., `feat: add real-time tracking to TrackingScreen`).
- **Testing**: Run `flutter test` to ensure no regressions are introduced.
- **Documentation**: Document any new widgets or complex logic with comments.

## Contact

If you have any questions, please reach out to the Project Lead or post in the team's communication channel.
