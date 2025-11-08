import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const _channel = MethodChannel('com.example.gallery_app/notifications');
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await _channel.invokeMethod('getNotifications');
      final List list = jsonDecode(res as String);
      _items = list.cast<Map>().map((e) => e.cast<String, dynamic>()).toList();
    } catch (e) {
      _items = [];
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _clear() async {
    await _channel.invokeMethod('clearNotifications');
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded),
            tooltip: 'Clear',
            onPressed: _items.isEmpty ? null : _clear,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? Center(
                  child: Text(
                    'No notifications captured yet.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final n = _items[_items.length - 1 - i]; // newest first
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.notifications_rounded),
                        title: Text(n['title']?.toString() ?? ''),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if ((n['text']?.toString() ?? '').isNotEmpty)
                              Text(n['text'].toString()),
                            const SizedBox(height: 4),
                            Text(
                              n['package']?.toString() ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                            if (n['timestamp'] != null)
                              Text(
                                DateTime.fromMillisecondsSinceEpoch(
                                        (n['timestamp'] as num).toInt())
                                    .toLocal()
                                    .toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _load,
        icon: const Icon(Icons.refresh_rounded),
        label: const Text('Refresh'),
      ),
    );
  }
}
