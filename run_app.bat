@echo off
echo Flutter Gallery App Setup and Run Script
echo ==========================================
echo.

echo Checking Flutter installation...
flutter doctor --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter is not installed or not in PATH
    echo Please install Flutter from https://flutter.dev/docs/get-started/install
    echo.
    pause
    exit /b 1
)

echo ✅ Flutter is installed
echo.

echo Installing dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo ❌ Failed to install dependencies
    pause
    exit /b 1
)

echo ✅ Dependencies installed
echo.

echo Available options:
echo 1. Run app in debug mode (recommended for development)
echo 2. Build APK for release
echo 3. Clean and rebuild
echo 4. Connect to device and run
echo 5. Show connected devices
echo.

set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" (
    echo Starting app in debug mode...
    flutter run
) else if "%choice%"=="2" (
    echo Building APK for release...
    flutter build apk --release
    echo ✅ APK built successfully!
    echo Location: build\app\outputs\flutter-apk\app-release.apk
) else if "%choice%"=="3" (
    echo Cleaning project...
    flutter clean
    echo Installing dependencies...
    flutter pub get
    echo Starting app...
    flutter run
) else if "%choice%"=="4" (
    echo Connecting to device and running app...
    flutter run --release
) else if "%choice%"=="5" (
    echo Showing connected devices...
    flutter devices
) else (
    echo Invalid choice
)

echo.
pause