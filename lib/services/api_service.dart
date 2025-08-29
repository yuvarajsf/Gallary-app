import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gallery_item.dart';
import '../utils/constants.dart';

class ApiService {
  static String? _baseUrl;
  
  static void setBaseUrl(String url) {
    _baseUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }
  
  static String? get baseUrl => _baseUrl;

  static Future<bool> testConnection() async {
    if (_baseUrl == null) return false;
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<List<GalleryItem>> getFolders({String path = ''}) async {
    if (_baseUrl == null) throw Exception('Base URL not set');
    
    try {
      final uri = Uri.parse('$_baseUrl/folders')
          .replace(queryParameters: path.isNotEmpty ? {'path': path} : null);
      
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final items = <GalleryItem>[];
        
        if (jsonData['folders'] != null) {
          for (var folder in jsonData['folders']) {
            items.add(GalleryItem.fromJson({...folder, 'is_folder': true}));
          }
        }
        
        if (jsonData['files'] != null) {
          for (var file in jsonData['files']) {
            items.add(GalleryItem.fromJson({...file, 'is_folder': false}));
          }
        }
        
        return items;
      } else {
        throw Exception('Failed to load folders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<List<GalleryItem>> getFiles(String folderPath) async {
    if (_baseUrl == null) throw Exception('Base URL not set');
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/files').replace(
          queryParameters: {'path': folderPath}
        ),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final files = <GalleryItem>[];
        
        if (jsonData['files'] != null) {
          for (var file in jsonData['files']) {
            files.add(GalleryItem.fromJson({...file, 'is_folder': false}));
          }
        }
        
        return files;
      } else {
        throw Exception('Failed to load files: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static String getImageUrl(String imagePath) {
    if (_baseUrl == null) return '';
    return '$_baseUrl/image?path=${Uri.encodeComponent(imagePath)}';
  }

  static String getThumbnailUrl(String imagePath) {
    if (_baseUrl == null) return '';
    return '$_baseUrl/thumbnail?path=${Uri.encodeComponent(imagePath)}';
  }
}