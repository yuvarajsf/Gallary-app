#!/usr/bin/env python3
"""
Gallery Server for Flutter Gallery App
This Python server serves files and folders as API responses for the Flutter gallery app.
"""

from flask import Flask, jsonify, send_file, request
from flask_cors import CORS
import os
import mimetypes
from pathlib import Path
from datetime import datetime
from PIL import Image
import io

app = Flask(__name__)
CORS(app)

# Configuration - CHANGE THESE PATHS TO YOUR ACTUAL PATHS
BASE_DIRECTORY = r"C:\Users\YuvarajAnbazhagan\Pictures\Screenshots"  # Change this to your gallery directory
THUMBNAIL_SIZE = (300, 300)
ALLOWED_EXTENSIONS = {'.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', '.mp4', '.avi', '.mov', '.mkv'}

def is_allowed_file(filename):
    return Path(filename).suffix.lower() in ALLOWED_EXTENSIONS

def get_file_info(filepath):
    """Get file information including size and modification date."""
    try:
        stat = filepath.stat()
        return {
            'size': stat.st_size,
            'modified_date': datetime.fromtimestamp(stat.st_mtime).isoformat()
        }
    except:
        return {'size': 0, 'modified_date': None}

def create_thumbnail(image_path, size=THUMBNAIL_SIZE):
    """Create a thumbnail for an image."""
    try:
        with Image.open(image_path) as img:
            img.thumbnail(size, Image.Resampling.LANCZOS)
            img_io = io.BytesIO()
            
            # Convert RGBA to RGB if necessary
            if img.mode == 'RGBA':
                background = Image.new('RGB', img.size, (255, 255, 255))
                background.paste(img, mask=img.split()[-1])
                img = background
            
            img.save(img_io, format='JPEG', quality=85)
            img_io.seek(0)
            return img_io.getvalue()
    except Exception as e:
        print(f"Error creating thumbnail for {image_path}: {e}")
        return None

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint."""
    return jsonify({"status": "healthy", "message": "Gallery server is running"})

@app.route('/folders', methods=['GET'])
def get_folders():
    """Get folders and files in the specified directory."""
    try:
        path = request.args.get('path', '')
        full_path = Path(BASE_DIRECTORY)
        
        if path:
            full_path = full_path / path
        
        if not full_path.exists() or not full_path.is_dir():
            return jsonify({"error": "Directory not found"}), 404
        
        folders = []
        files = []
        
        try:
            for item in full_path.iterdir():
                item_name = item.name
                relative_path = str(item.relative_to(BASE_DIRECTORY))
                
                if item.is_dir():
                    folders.append({
                        'name': item_name,
                        'path': relative_path,
                        'is_folder': True
                    })
                elif item.is_file() and is_allowed_file(item_name):
                    file_info = get_file_info(item)
                    file_data = {
                        'name': item_name,
                        'path': relative_path,
                        'is_folder': False,
                        **file_info
                    }
                    
                    # Add thumbnail URL for images
                    if item.suffix.lower() in {'.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'}:
                        file_data['thumbnail_url'] = f'/thumbnail?path={relative_path}'
                        file_data['full_url'] = f'/image?path={relative_path}'
                    
                    files.append(file_data)
        
        except PermissionError:
            return jsonify({"error": "Permission denied"}), 403
        
        # Sort folders and files alphabetically
        folders.sort(key=lambda x: x['name'].lower())
        files.sort(key=lambda x: x['name'].lower())
        
        return jsonify({
            "folders": folders,
            "files": files,
            "total_folders": len(folders),
            "total_files": len(files)
        })
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/files', methods=['GET'])
def get_files():
    """Get files in the specified folder."""
    try:
        path = request.args.get('path', '')
        if not path:
            return jsonify({"error": "Path parameter is required"}), 400
        
        full_path = Path(BASE_DIRECTORY) / path
        
        if not full_path.exists() or not full_path.is_dir():
            return jsonify({"error": "Directory not found"}), 404
        
        files = []
        
        try:
            for item in full_path.iterdir():
                if item.is_file() and is_allowed_file(item.name):
                    file_info = get_file_info(item)
                    relative_path = str(item.relative_to(BASE_DIRECTORY))
                    
                    file_data = {
                        'name': item.name,
                        'path': relative_path,
                        'is_folder': False,
                        **file_info
                    }
                    
                    # Add URLs for images
                    if item.suffix.lower() in {'.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'}:
                        file_data['thumbnail_url'] = f'/thumbnail?path={relative_path}'
                        file_data['full_url'] = f'/image?path={relative_path}'
                    
                    files.append(file_data)
        
        except PermissionError:
            return jsonify({"error": "Permission denied"}), 403
        
        # Sort files alphabetically
        files.sort(key=lambda x: x['name'].lower())
        
        return jsonify({
            "files": files,
            "total_files": len(files)
        })
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/image', methods=['GET'])
def serve_image():
    """Serve full-size image."""
    try:
        path = request.args.get('path', '')
        if not path:
            return jsonify({"error": "Path parameter is required"}), 400
        
        full_path = Path(BASE_DIRECTORY) / path
        
        if not full_path.exists() or not full_path.is_file():
            return jsonify({"error": "File not found"}), 404
        
        # Check if it's an allowed image file
        if full_path.suffix.lower() not in {'.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'}:
            return jsonify({"error": "File is not an image"}), 400
        
        mimetype, _ = mimetypes.guess_type(str(full_path))
        return send_file(str(full_path), mimetype=mimetype)
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/thumbnail', methods=['GET'])
def serve_thumbnail():
    """Serve thumbnail image."""
    try:
        path = request.args.get('path', '')
        if not path:
            return jsonify({"error": "Path parameter is required"}), 400
        
        full_path = Path(BASE_DIRECTORY) / path
        
        if not full_path.exists() or not full_path.is_file():
            return jsonify({"error": "File not found"}), 404
        
        # Check if it's an image file
        if full_path.suffix.lower() not in {'.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'}:
            return jsonify({"error": "File is not an image"}), 400
        
        # Create thumbnail
        thumbnail_data = create_thumbnail(full_path)
        if thumbnail_data:
            return thumbnail_data, 200, {'Content-Type': 'image/jpeg'}
        else:
            # Fallback to original image if thumbnail creation fails
            return send_file(str(full_path), mimetype='image/jpeg')
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/download', methods=['GET'])
def download_file():
    """Serve file for download."""
    try:
        path = request.args.get('path', '')
        if not path:
            return jsonify({"error": "Path parameter is required"}), 400
        
        full_path = Path(BASE_DIRECTORY) / path
        
        if not full_path.exists() or not full_path.is_file():
            return jsonify({"error": "File not found"}), 404
        
        # Check if it's an allowed file
        if not is_allowed_file(full_path.name):
            return jsonify({"error": "File type not allowed"}), 400
        
        return send_file(
            str(full_path),
            as_attachment=True,
            download_name=full_path.name
        )
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/', methods=['GET'])
def index():
    """Root endpoint with server information."""
    return jsonify({
        "message": "Gallery Server API",
        "version": "1.0.0",
        "base_directory": str(BASE_DIRECTORY),
        "endpoints": {
            "/health": "Health check",
            "/folders": "Get folders and files (optional ?path= parameter)",
            "/files": "Get files in folder (?path= parameter required)",
            "/image": "Serve full image (?path= parameter required)",
            "/thumbnail": "Serve thumbnail (?path= parameter required)",
            "/download": "Download file (?path= parameter required)"
        }
    })

if __name__ == '__main__':    
    # Check if base directory exists
    if not Path(BASE_DIRECTORY).exists():
        print(f"\n❌ ERROR: Base directory does not exist: {BASE_DIRECTORY}")
        print(f"Please update the BASE_DIRECTORY variable in this file to point to your gallery folder.")
    else:
        print(f"✅ Base directory exists and is ready to serve files.")
    
    app.run(host='0.0.0.0', port=8080, debug=True)