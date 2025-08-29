@echo off
echo Gallery App Complete Setup
echo ==========================
echo.

echo This script will help you set up both the Python server and Flutter app.
echo.

echo Step 1: Python Server Setup
echo ----------------------------
echo Installing Python dependencies...
cd python_server
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo ❌ Failed to install Python dependencies
    echo Please make sure Python and pip are installed
    pause
    exit /b 1
)
echo ✅ Python dependencies installed
cd ..
echo.

echo Step 2: Flutter App Setup
echo --------------------------
echo Installing Flutter dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo ❌ Failed to install Flutter dependencies
    echo Please make sure Flutter is installed and in PATH
    pause
    exit /b 1
)
echo ✅ Flutter dependencies installed
echo.

echo Step 3: Configuration
echo ---------------------
echo.
echo ⚠️  IMPORTANT: Before running the app, you need to:
echo.
echo 1. Edit python_server/gallery_server.py
echo    - Update BASE_DIRECTORY to your gallery folder path
echo    - Example: BASE_DIRECTORY = r"C:\Users\YourName\Pictures"
echo.
echo 2. Find your computer's IP address:
echo    - Windows: Open Command Prompt and run 'ipconfig'
echo    - Look for IPv4 Address under your active network connection
echo.
echo 3. Make sure your phone and computer are on the same WiFi network
echo.

echo Setup Complete!
echo ================
echo.
echo To run the application:
echo 1. First start the Python server: python_server\run_server.bat
echo 2. Then run the Flutter app: run_app.bat
echo.
echo The app will ask for your server URL on first launch.
echo Use: http://YOUR_IP_ADDRESS:5000
echo Example: http://192.168.1.100:5000
echo.
echo For detailed instructions, see README.md
echo.
pause