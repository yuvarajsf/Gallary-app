import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DownloadService {
  static final Dio _dio = Dio();

  /// Request storage permissions for downloading files
  static Future<bool> requestStoragePermission() async {
    try {
      // For Android 13+ (API 33+), we need specific media permissions
      if (Platform.isAndroid) {
        final androidInfo = await _getAndroidSdkInt();
        
        if (androidInfo >= 33) {
          // Android 13+ - Request READ_MEDIA_IMAGES permission
          final status = await Permission.photos.request();
          return status == PermissionStatus.granted;
        } else if (androidInfo >= 30) {
          // Android 11-12 - Request MANAGE_EXTERNAL_STORAGE for scoped storage
          final status = await Permission.manageExternalStorage.request();
          if (status == PermissionStatus.granted) {
            return true;
          }
          // Fallback to basic storage permission
          final storageStatus = await Permission.storage.request();
          return storageStatus == PermissionStatus.granted;
        } else {
          // Android 10 and below - Use traditional storage permission
          final status = await Permission.storage.request();
          return status == PermissionStatus.granted;
        }
      }
      return true; // iOS doesn't need explicit storage permissions for downloads
    } catch (e) {
      debugPrint('Error requesting storage permission: $e');
      return false;
    }
  }

  /// Get Android SDK version
  static Future<int> _getAndroidSdkInt() async {
    try {
      if (Platform.isAndroid) {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.version.sdkInt ?? 30;
      }
      return 33; // Default to latest for non-Android platforms
    } catch (e) {
      debugPrint('Error getting Android SDK version: $e');
      return 30; // Default to Android 11 behavior for safety
    }
  }

  /// Download file to Downloads directory
  static Future<String> downloadFile({
    required String url,
    required String fileName,
    required Function(double) onProgress,
  }) async {
    try {
      // Request permission first
      final hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        throw Exception('Storage permission denied');
      }

      // Get Downloads directory
      Directory? downloadsDir;
      
      if (Platform.isAndroid) {
        // Try to get the Downloads directory
        try {
          downloadsDir = Directory('/storage/emulated/0/Download');
          if (!await downloadsDir.exists()) {
            // Fallback to external storage directory
            final externalDir = await getExternalStorageDirectory();
            if (externalDir != null) {
              downloadsDir = Directory('${externalDir.path}/Download');
              if (!await downloadsDir.exists()) {
                await downloadsDir.create(recursive: true);
              }
            }
          }
        } catch (e) {
          // Final fallback to app's external files directory
          final externalDir = await getExternalStorageDirectory();
          downloadsDir = externalDir;
        }
      } else {
        // iOS - use Documents directory
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      if (downloadsDir == null) {
        throw Exception('Could not access Downloads directory');
      }

      final filePath = '${downloadsDir.path}/$fileName';
      
      // Download the file
      final response = await _dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = received / total;
            onProgress(progress);
          }
        },
      );

      if (response.statusCode == 200) {
        return filePath;
      } else {
        throw Exception('Download failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Download error: $e');
    }
  }

  /// Check if file already exists in downloads
  static Future<bool> fileExistsInDownloads(String fileName) async {
    try {
      Directory? downloadsDir;
      
      if (Platform.isAndroid) {
        downloadsDir = Directory('/storage/emulated/0/Download');
        if (!await downloadsDir.exists()) {
          final externalDir = await getExternalStorageDirectory();
          if (externalDir != null) {
            downloadsDir = Directory('${externalDir.path}/Download');
          }
        }
      } else {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      if (downloadsDir == null) return false;

      final file = File('${downloadsDir.path}/$fileName');
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Get readable download path for user display
  static Future<String> getDownloadPath() async {
    if (Platform.isAndroid) {
      final downloadsDir = Directory('/storage/emulated/0/Download');
      if (await downloadsDir.exists()) {
        return 'Downloads folder';
      } else {
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          return '${externalDir.path}/Download';
        }
      }
    } else {
      final dir = await getApplicationDocumentsDirectory();
      return dir.path;
    }
    return 'Downloads folder';
  }
}