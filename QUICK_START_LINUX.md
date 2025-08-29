# 🚀 Quick Start Guide - Linux

## Get Your Gallery App Running in 5 Minutes on Linux!

### ⚡ Step 1: Initial Setup (One-time only)

1. **Make scripts executable**:
   ```bash
   chmod +x setup.sh run_app.sh python_server/setup_server.sh python_server/run_server.sh
   ```

2. **Run the setup script**:
   ```bash
   ./setup.sh
   ```
   This installs all dependencies for both Python server and Flutter app.

### 📁 Step 2: Configure Your Gallery Folder

1. **Open** `python_server/gallery_server.py` in any text editor
2. **Find this line** (around line 13):
   ```python
   BASE_DIRECTORY = r"C:\Users\YourName\Pictures"
   ```
3. **Replace** with your actual gallery folder path (Linux format):
   ```python
   BASE_DIRECTORY = r"/home/john/Pictures"  # Your path here
   ```
4. **Save** the file

### 🌐 Step 3: Start the Python Server

1. **Run** the server script:
   ```bash
   ./python_server/run_server.sh
   ```
2. **Note down** the IP address shown (example: `192.168.1.100:5000`)
3. **Keep this terminal open** - the server needs to stay running

### 📱 Step 4: Run the Flutter App

1. **Connect your phone** via USB and enable USB Debugging
   - Or use an Android emulator
2. **Open a new terminal** and run:
   ```bash
   ./run_app.sh
   ```
3. **Choose option 1** for debug mode
4. Wait for the app to install and launch on your device

### 🔗 Step 5: Connect App to Server

1. **Enter the server URL** in the app (from Step 3)

### 📋 Linux-Specific Notes

- Use `python3` and `pip3` commands (handled automatically by the scripts)
- Default gallery path format: `/home/username/Pictures`
- Find your IP address with: `hostname -I` or `ip addr show`
- Make sure your firewall allows connections on port 5000
- Ensure your phone and computer are on the same WiFi network

### 🔧 Troubleshooting Linux Issues

**Permission Issues:**
```bash
# If you get permission errors, make scripts executable:
chmod +x *.sh python_server/*.sh
```

**Python Dependencies:**
```bash
# If pip3 is not found, install it:
sudo apt update
sudo apt install python3-pip

# Or use your distribution's package manager
```

**Flutter Issues:**
```bash
# Check Flutter installation:
flutter doctor

# If Flutter is not in PATH, add to ~/.bashrc:
export PATH="$PATH:/path/to/flutter/bin"
```

## 🎯 Quick Commands Summary

```bash
# One-time setup
chmod +x *.sh python_server/*.sh
./setup.sh

# Running the app
./python_server/run_server.sh    # Terminal 1 - Keep open
./run_app.sh                     # Terminal 2 - Choose option 1
```

That's it! Your gallery app should now be running on Linux! 🎉