#!/bin/bash

echo "Flutter Gallery App Setup and Run Script"
echo "=========================================="
echo ""

echo "Checking Flutter installation..."
flutter doctor --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "❌ Flutter is not installed or not in PATH"
    echo "Please install Flutter from https://flutter.dev/docs/get-started/install"
    echo ""
    read -p "Press Enter to continue..."
    exit 1
fi

echo "✅ Flutter is installed"
echo ""

echo "Installing dependencies..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    read -p "Press Enter to continue..."
    exit 1
fi

echo "✅ Dependencies installed"
echo ""

echo "Available options:"
echo "1. Run app in debug mode (recommended for development)"
echo "2. Build APK for release"
echo "3. Clean and rebuild"
echo "4. Connect to device and run"
echo "5. Show connected devices"
echo ""

read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        echo "Starting app in debug mode..."
        flutter run
        ;;
    2)
        echo "Building APK for release..."
        flutter build apk --release
        echo "✅ APK built successfully!"
        echo "Location: build/app/outputs/flutter-apk/app-release.apk"
        ;;
    3)
        echo "Cleaning project..."
        flutter clean
        echo "Installing dependencies..."
        flutter pub get
        echo "Starting app..."
        flutter run
        ;;
    4)
        echo "Connecting to device and running app..."
        flutter run --release
        ;;
    5)
        echo "Showing connected devices..."
        flutter devices
        ;;
    *)
        echo "Invalid choice"
        ;;
esac

echo ""
read -p "Press Enter to continue..."