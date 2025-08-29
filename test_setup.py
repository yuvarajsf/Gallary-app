#!/usr/bin/env python3
"""
Test script to verify the gallery app setup is working correctly.
"""

import os
import sys
import subprocess
import requests
from pathlib import Path

def check_python_dependencies():
    """Check if required Python packages are installed."""
    print("🔍 Checking Python dependencies...")
    
    required_packages = ['flask', 'flask-cors', 'pillow']
    missing_packages = []
    
    for package in required_packages:
        try:
            __import__(package.replace('-', '_'))
            print(f"  ✅ {package}")
        except ImportError:
            print(f"  ❌ {package}")
            missing_packages.append(package)
    
    if missing_packages:
        print(f"\n❌ Missing packages: {', '.join(missing_packages)}")
        print("Run: pip install -r python_server/requirements.txt")
        return False
    
    print("✅ All Python dependencies are installed")
    return True

def check_flutter_setup():
    """Check if Flutter is properly installed."""
    print("\n🔍 Checking Flutter setup...")
    
    try:
        result = subprocess.run(['flutter', 'doctor'], 
                              capture_output=True, text=True, timeout=30)
        if result.returncode == 0:
            print("✅ Flutter is installed and configured")
            return True
        else:
            print("❌ Flutter doctor found issues")
            print(result.stdout)
            return False
    except FileNotFoundError:
        print("❌ Flutter is not installed or not in PATH")
        return False
    except subprocess.TimeoutExpired:
        print("❌ Flutter doctor timed out")
        return False

def check_gallery_directory():
    """Check if gallery directory is configured and exists."""
    print("\n🔍 Checking gallery directory configuration...")
    
    server_file = Path("python_server/gallery_server.py")
    if not server_file.exists():
        print("❌ Server file not found")
        return False
    
    with open(server_file, 'r') as f:
        content = f.read()
    
    # Find BASE_DIRECTORY line
    lines = content.split('\n')
    base_dir = None
    
    for line in lines:
        if 'BASE_DIRECTORY' in line and '=' in line and not line.strip().startswith('#'):
            # Extract the directory path
            parts = line.split('=', 1)
            if len(parts) == 2:
                base_dir = parts[1].strip().strip('"').strip("'").strip('r"').strip("r'")
                break
    
    if not base_dir:
        print("❌ BASE_DIRECTORY not found in server configuration")
        return False
    
    if base_dir == "C:\\Users\\YourName\\Pictures":
        print("❌ BASE_DIRECTORY is still set to default placeholder")
        print("   Please edit python_server/gallery_server.py and set your actual gallery path")
        return False
    
    if not os.path.exists(base_dir):
        print(f"❌ Gallery directory does not exist: {base_dir}")
        print("   Please check the path in python_server/gallery_server.py")
        return False
    
    print(f"✅ Gallery directory configured: {base_dir}")
    
    # Count files in directory
    try:
        file_count = 0
        for root, dirs, files in os.walk(base_dir):
            file_count += len([f for f in files if any(f.lower().endswith(ext) 
                             for ext in ['.jpg', '.jpeg', '.png', '.gif', '.bmp'])])
            if file_count > 0:  # Don't count all files for performance
                break
        
        if file_count > 0:
            print(f"✅ Found images in gallery directory")
        else:
            print("⚠️  No images found in gallery directory")
    except Exception as e:
        print(f"⚠️  Could not scan gallery directory: {e}")
    
    return True

def test_server_startup():
    """Test if server can start (briefly)."""
    print("\n🔍 Testing server startup...")
    
    try:
        # Start server in background
        server_process = subprocess.Popen([
            sys.executable, "python_server/gallery_server.py"
        ], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        
        # Wait a few seconds for server to start
        import time
        time.sleep(3)
        
        # Test if server is responding
        try:
            response = requests.get("http://localhost:5000/health", timeout=5)
            if response.status_code == 200:
                print("✅ Server started successfully")
                result = True
            else:
                print(f"❌ Server responded with status {response.status_code}")
                result = False
        except requests.RequestException as e:
            print(f"❌ Could not connect to server: {e}")
            result = False
        
        # Stop server
        server_process.terminate()
        server_process.wait(timeout=5)
        
        return result
        
    except Exception as e:
        print(f"❌ Error testing server: {e}")
        return False

def check_project_structure():
    """Check if all required files exist."""
    print("\n🔍 Checking project structure...")
    
    required_files = [
        "lib/main.dart",
        "pubspec.yaml",
        "python_server/gallery_server.py",
        "python_server/requirements.txt",
        "android/app/build.gradle",
        "android/app/src/main/AndroidManifest.xml"
    ]
    
    missing_files = []
    for file_path in required_files:
        if not os.path.exists(file_path):
            missing_files.append(file_path)
    
    if missing_files:
        print("❌ Missing required files:")
        for file_path in missing_files:
            print(f"  - {file_path}")
        return False
    
    print("✅ All required files present")
    return True

def main():
    """Run all tests."""
    print("🧪 Gallery App Setup Test")
    print("=" * 50)
    
    tests = [
        ("Project Structure", check_project_structure),
        ("Python Dependencies", check_python_dependencies),
        ("Flutter Setup", check_flutter_setup),
        ("Gallery Directory", check_gallery_directory),
        ("Server Startup", test_server_startup)
    ]
    
    results = []
    
    for test_name, test_func in tests:
        try:
            result = test_func()
            results.append((test_name, result))
        except Exception as e:
            print(f"❌ {test_name} test failed with error: {e}")
            results.append((test_name, False))
    
    print("\n" + "=" * 50)
    print("📊 Test Results Summary")
    print("=" * 50)
    
    passed = 0
    total = len(results)
    
    for test_name, result in results:
        status = "✅ PASS" if result else "❌ FAIL"
        print(f"{status} {test_name}")
        if result:
            passed += 1
    
    print(f"\nResults: {passed}/{total} tests passed")
    
    if passed == total:
        print("\n🎉 All tests passed! Your setup is ready.")
        print("\nNext steps:")
        print("1. Run python_server/run_server.bat")
        print("2. Run run_app.bat")
        print("3. Connect your phone and enjoy your gallery app!")
    else:
        print(f"\n⚠️  {total - passed} test(s) failed. Please fix the issues above.")
        print("Check README.md for detailed setup instructions.")
    
    return passed == total

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)