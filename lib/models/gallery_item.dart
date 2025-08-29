class GalleryItem {
  final String name;
  final String path;
  final bool isFolder;
  final String? thumbnailUrl;
  final String? fullUrl;
  final int? size;
  final DateTime? modifiedDate;

  GalleryItem({
    required this.name,
    required this.path,
    required this.isFolder,
    this.thumbnailUrl,
    this.fullUrl,
    this.size,
    this.modifiedDate,
  });

  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    return GalleryItem(
      name: json['name'] ?? '',
      path: json['path'] ?? '',
      isFolder: json['is_folder'] ?? false,
      thumbnailUrl: json['thumbnail_url'],
      fullUrl: json['full_url'],
      size: json['size'],
      modifiedDate: json['modified_date'] != null 
          ? DateTime.tryParse(json['modified_date']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'is_folder': isFolder,
      'thumbnail_url': thumbnailUrl,
      'full_url': fullUrl,
      'size': size,
      'modified_date': modifiedDate?.toIso8601String(),
    };
  }

  bool get isImage {
    if (isFolder) return false;
    final extension = name.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(extension);
  }

  bool get isVideo {
    if (isFolder) return false;
    final extension = name.toLowerCase().split('.').last;
    return ['mp4', 'avi', 'mov', 'wmv', 'flv', 'webm', 'mkv'].contains(extension);
  }

  String get formattedSize {
    if (size == null) return '';
    
    if (size! < 1024) return '$size B';
    if (size! < 1024 * 1024) return '${(size! / 1024).toStringAsFixed(1)} KB';
    if (size! < 1024 * 1024 * 1024) return '${(size! / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(size! / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}