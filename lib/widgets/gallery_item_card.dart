import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/gallery_item.dart';
import '../services/api_service.dart';
import 'loading_shimmer.dart';

class GalleryItemCard extends StatelessWidget {
  final GalleryItem item;
  final VoidCallback onTap;

  const GalleryItemCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: item.isFolder
                        ? [
                            Theme.of(context).colorScheme.primary.withOpacity(0.8),
                            Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                          ]
                        : [
                            Colors.grey.withOpacity(0.1),
                            Colors.grey.withOpacity(0.2),
                          ],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: _buildItemPreview(),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Icon(
                          item.isFolder ? Icons.folder : _getFileIcon(),
                          size: 16,
                          color: item.isFolder 
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.isFolder ? 'Folder' : item.formattedSize,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemPreview() {
    if (item.isFolder) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.withOpacity(0.1),
              Colors.purple.withOpacity(0.1),
            ],
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.folder_rounded,
            size: 48,
            color: Colors.white,
          ),
        ),
      );
    }

    if (item.isImage && item.thumbnailUrl != null) {
      return CachedNetworkImage(
        imageUrl: ApiService.getThumbnailUrl(item.path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => LoadingShimmer(
          child: Container(
            color: Colors.grey[300],
          ),
        ),
        errorWidget: (context, url, error) => _buildFileIcon(),
      );
    }

    return _buildFileIcon();
  }

  Widget _buildFileIcon() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.withOpacity(0.1),
            Colors.grey.withOpacity(0.2),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          _getFileIcon(),
          size: 48,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  IconData _getFileIcon() {
    if (item.isImage) return Icons.image_rounded;
    if (item.isVideo) return Icons.video_file_rounded;
    
    final extension = item.name.toLowerCase().split('.').last;
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'doc':
      case 'docx':
        return Icons.description_rounded;
      case 'txt':
        return Icons.text_snippet_rounded;
      case 'zip':
      case 'rar':
        return Icons.archive_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }
}