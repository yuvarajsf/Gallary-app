# 🚀 Quick Start Guide

## Get Your Gallery App Running in 5 Minutes!

### ⚡ Step 1: Initial Setup (One-time only)

1. **Run the setup script**:
   ```
   Double-click setup.bat
   ```
   This installs all dependencies for both Python server and Flutter app.

### 📁 Step 2: Configure Your Gallery Folder

1. **Open** `python_server/gallery_server.py` in any text editor
2. **Find this line** (around line 13):
   ```python
   BASE_DIRECTORY = r"C:\Users\YourName\Pictures"
   ```
3. **Replace** with your actual gallery folder path:
   ```python
   BASE_DIRECTORY = r"C:\Users\John\Pictures"  # Your path here
   ```
4. **Save** the file

### 🌐 Step 3: Start the Python Server

1. **Double-click** `python_server/run_server.bat`
2. **Note down** the IP address shown (example: `192.168.1.100:5000`)
3. **Keep this window open** - the server needs to stay running

### 📱 Step 4: Run the Flutter App

1. **Connect your phone** via USB and enable USB Debugging
   - Or use an Android emulator
2. **Double-click** `run_app.bat`
3. **Choose option 1** for debug mode
4. Wait for the app to install and launch on your device

### 🔗 Step 5: Connect App to Server

1. **Enter the server URL** in the app (from Step 3)
   - Example: `http://192.168.1.100:5000`
2. **Tap "Connect to Server"**
3. **Start browsing** your gallery!

---

## ❓ Need Help?

### Common Issues:

**❌ "Connection Failed"**
- Make sure both devices are on the same WiFi network
- Check if the server is still running
- Try using your computer's actual IP, not `localhost`

**❌ "Flutter not found"**
- Install Flutter from [flutter.dev](https://flutter.dev/docs/get-started/install)
- Add Flutter to your system PATH

**❌ "Python not found"**
- Install Python from [python.org](https://python.org)
- Make sure to check "Add Python to PATH" during installation

### Finding Your IP Address:

**Windows:**
```cmd
ipconfig
```
Look for "IPv4 Address"

**Mac:**
```bash
ifconfig
```

### Still Need Help?
Check the full `README.md` for detailed instructions and troubleshooting.

---

## 🎉 That's It!

Your gallery app should now be running and connected to your server. Enjoy browsing your photos with this beautiful mobile interface!