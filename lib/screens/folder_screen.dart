import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/gallery_item.dart';
import '../services/api_service.dart';
import '../widgets/gallery_item_card.dart';
import '../widgets/loading_shimmer.dart';
import 'image_viewer_screen.dart';

class FolderScreen extends StatefulWidget {
  final String folderPath;
  final String folderName;

  const FolderScreen({
    super.key,
    required this.folderPath,
    required this.folderName,
  });

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  List<GalleryItem> _items = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final items = await ApiService.getFolders(path: widget.folderPath);
      if (mounted) {
        setState(() {
          _items = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    await _loadData();
  }

  void _onItemTap(GalleryItem item) {
    if (item.isFolder) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FolderScreen(
            folderPath: item.path,
            folderName: item.name,
          ),
        ),
      );
    } else if (item.isImage) {
      final imageItems = _items.where((item) => item.isImage).toList();
      final initialIndex = imageItems.indexOf(item);
      
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ImageViewerScreen(
            images: imageItems,
            initialIndex: initialIndex >= 0 ? initialIndex : 0,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          widget.folderName,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            icon: Icon(_isGridView ? Icons.list_rounded : Icons.grid_view_rounded),
            tooltip: _isGridView ? 'List View' : 'Grid View',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _isGridView ? const GridLoadingShimmer() : const ListLoadingShimmer();
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Loading Error',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _onRefresh,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.folder_open_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Empty Folder',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This folder doesn\'t contain any files or subfolders.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _isGridView ? _buildGridView() : _buildListView();
  }

  Widget _buildGridView() {
    // Separate folders and files
    final folders = _items.where((item) => item.isFolder).toList();
    final files = _items.where((item) => !item.isFolder).toList();
    final images = files.where((item) => item.isImage).toList();
    final otherFiles = files.where((item) => !item.isImage).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Folders section
          if (folders.isNotEmpty) ...[
            Text(
              'Folders',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: folders.length,
              itemBuilder: (context, index) {
                return GalleryItemCard(
                  item: folders[index],
                  onTap: () => _onItemTap(folders[index]),
                );
              },
            ),
            const SizedBox(height: 24),
          ],

          // Images section
          if (images.isNotEmpty) ...[
            Text(
              'Images',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return GalleryItemCard(
                  item: images[index],
                  onTap: () => _onItemTap(images[index]),
                );
              },
            ),
            const SizedBox(height: 24),
          ],

          // Other files section
          if (otherFiles.isNotEmpty) ...[
            Text(
              'Files',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: otherFiles.length,
              itemBuilder: (context, index) {
                return GalleryItemCard(
                  item: otherFiles[index],
                  onTap: () => _onItemTap(otherFiles[index]),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: item.isFolder
                      ? [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ]
                      : item.isImage
                          ? [Colors.blue.shade300, Colors.purple.shade300]
                          : [Colors.grey.shade300, Colors.grey.shade400],
                ),
              ),
              child: Icon(
                item.isFolder 
                    ? Icons.folder_rounded 
                    : item.isImage
                        ? Icons.image_rounded
                        : Icons.insert_drive_file_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            title: Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              item.isFolder ? 'Folder' : item.formattedSize,
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () => _onItemTap(item),
          ),
        );
      },
    );
  }
}