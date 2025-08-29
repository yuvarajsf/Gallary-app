# Gallery Mobile App

A beautiful Flutter-based gallery application that connects to your local Python server to browse and view images and folders.

## 📱 Features

- **Beautiful UI**: Modern, responsive design with smooth animations
- **Server Configuration**: Easy setup to connect to your Python service
- **Folder Navigation**: Browse through folders and subfolders
- **Image Viewing**: High-quality image viewer with zoom and pan
- **Thumbnail Loading**: Fast thumbnail generation for quick browsing
- **Grid/List Views**: Switch between grid and list viewing modes
- **Skeleton Loading**: Elegant loading animations
- **Dark/Light Theme**: Automatic theme switching based on system preference

## 🚀 Getting Started

### Prerequisites

1. **Flutter SDK**: Download and install Flutter from [flutter.dev](https://flutter.dev)
2. **Python 3.7+**: For running the gallery server
3. **Android Studio/VS Code**: For development (optional)

### 🔧 Server Setup

1. **Install Python Dependencies**:
   ```bash
   cd python_server
   pip install -r requirements.txt
   ```

2. **Configure Gallery Directory**:
   Edit `python_server/gallery_server.py` and update the `BASE_DIRECTORY` variable:
   ```python
   BASE_DIRECTORY = r"C:\Users\YourName\Pictures"  # Change this path
   ```

3. **Run the Server**:
   ```bash
   python gallery_server.py
   ```
   Or run `python_server/run_server.bat` on Windows.

   The server will be available at:
   - `http://localhost:5000` (for local testing)
   - `http://YOUR_IP_ADDRESS:5000` (for mobile access)

### 📱 Mobile App Setup

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run on Device/Emulator**:
   ```bash
   flutter run
   ```

3. **Build for Release**:
   ```bash
   # Android APK
   flutter build apk --release
   
   # Android App Bundle
   flutter build appbundle --release
   ```

## 🌐 Network Configuration

### Finding Your Computer's IP Address

**Windows**:
```cmd
ipconfig
```
Look for "IPv4 Address" under your active network connection.

**macOS/Linux**:
```bash
ifconfig
```
Look for the IP address of your active network interface.

### Firewall Configuration

Make sure your firewall allows incoming connections on port 5000:

**Windows Firewall**:
1. Go to Windows Defender Firewall
2. Click "Allow an app or feature through Windows Defender Firewall"
3. Add Python or allow port 5000

## 📁 Project Structure

```
gallery_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/
│   │   └── gallery_item.dart     # Data model for gallery items
│   ├── screens/
│   │   ├── splash_screen.dart    # Splash screen
│   │   ├── server_config_screen.dart # Server configuration
│   │   ├── home_screen.dart      # Main gallery screen
│   │   ├── folder_screen.dart    # Folder browsing
│   │   └── image_viewer_screen.dart # Image viewer
│   ├── services/
│   │   └── api_service.dart      # API communication
│   ├── utils/
│   │   ├── constants.dart        # App constants
│   │   ├── storage_helper.dart   # Local storage
│   │   └── theme_data.dart       # App theming
│   └── widgets/
│       ├── gallery_item_card.dart # Gallery item card widget
│       └── loading_shimmer.dart  # Loading animations
├── python_server/
│   ├── gallery_server.py         # Python Flask server
│   ├── requirements.txt          # Python dependencies
│   ├── setup_server.bat          # Server setup script
│   └── run_server.bat           # Server run script
└── android/                     # Android configuration
```

## 🎨 Customization

### Theme Colors
Edit `lib/utils/theme_data.dart` to customize the app's color scheme:

```dart
static const Color primaryColor = Color(0xFF6366F1);
static const Color secondaryColor = Color(0xFF8B5CF6);
static const Color accentColor = Color(0xFFEC4899);
```

### Server Configuration
Edit `python_server/gallery_server.py` to customize server settings:

```python
BASE_DIRECTORY = r"Your\Gallery\Path"
THUMBNAIL_SIZE = (300, 300)
```

## 📱 Building for Production

### Android APK
```bash
flutter build apk --release
```
The APK will be available at: `build/app/outputs/flutter-apk/app-release.apk`

### Install on Device
```bash
flutter install
```

## 🔧 API Endpoints

The Python server provides these endpoints:

- `GET /health` - Health check
- `GET /folders?path=<path>` - Get folders and files
- `GET /files?path=<path>` - Get files in specific folder
- `GET /image?path=<path>` - Serve full-size image
- `GET /thumbnail?path=<path>` - Serve thumbnail image

## 📋 Configuration Files

### Common Configuration Values

If you need to change static values, update these files:

1. **Server URL**: Saved automatically in app preferences
2. **Base Directory**: `python_server/gallery_server.py` → `BASE_DIRECTORY`
3. **App Name**: `pubspec.yaml` → `name` and `description`
4. **Colors**: `lib/utils/theme_data.dart`
5. **Package Name**: `android/app/build.gradle` → `applicationId`

## 🐛 Troubleshooting

### Common Issues

1. **Connection Failed**: 
   - Check if Python server is running
   - Verify IP address is correct
   - Check firewall settings

2. **Images Not Loading**:
   - Verify BASE_DIRECTORY path is correct
   - Check file permissions
   - Ensure images are in supported formats

3. **App Crashes**:
   - Check Flutter version compatibility
   - Run `flutter clean` and `flutter pub get`
   - Check device/emulator Android version

### Debug Commands

```bash
# Check Flutter doctor
flutter doctor

# Clean and rebuild
flutter clean
flutter pub get

# Run with verbose logging
flutter run --verbose
```

## 📄 License

This project is open-source and available under the MIT License.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

**Note**: Make sure your phone and computer are on the same network for the app to connect to your Python server.