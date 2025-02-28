# Flutter Project

This is a Flutter application.

## Google Drive apk

- [StoreTest Apk for android](https://drive.google.com/file/d/1BqBenVrpOa_kzOIDjydXA3--b_J_16v6/view?usp=sharing)

## Prerequisites

Before running this project, ensure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (Version used to develop: 3.29.0)
- [Dart](https://dart.dev/get-dart) (Version used to develop: 3.7.0)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)
- Xcode (for iOS development)
- An emulator or physical device
- Git
- Java 17 (Required by Flutter)

## Getting Started

1. **Clone the repository:**
   ```sh
   git clone git@github.com:AngelDevXiii/StoreTest.git
   cd StoreTest (or name of the folder with the project)
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Generate necessary files:**
   ```sh
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the application:**
   ```sh
   flutter run
   ```
   - To run on Android: Ensure an Android emulator or device is connected.
   - To run on iOS: Ensure Xcode is installed and an iOS simulator or device is connected.

## Debugging the Application

To debug your application, use:

- **Start debugging in VS Code:** Press `F5` or run:
  ```sh
  flutter run --debug
  ```
- **Debug on a specific device:**
  ```sh
  flutter run -d <device_id>
  ```
  Use `flutter devices` to list available devices.
- **Enable hot reload (during development):**
  Press `r` in the terminal while the app is running.
- **Enable hot restart:**
  Press `R` in the terminal.

## Troubleshooting

- **Check Flutter installation:**
  ```sh
  flutter doctor
  ```
- If you face issues with dependencies, try:
  ```sh
  flutter clean
  flutter pub get
  ```
- Ensure your device or emulator is properly connected by running:
  ```sh
  flutter devices
  ```

## License

This project is licensed under the [MIT License](LICENSE).

