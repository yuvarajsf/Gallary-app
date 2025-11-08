import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import '../utils/theme_notifier.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appearance'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ColorTile(
            title: 'Primary Color',
            color: theme.primary,
            onChanged: (c) => theme.setPrimary(c),
          ),
          _ColorTile(
            title: 'Secondary Color',
            color: theme.secondary,
            onChanged: (c) => theme.setSecondary(c),
          ),
          _ColorTile(
            title: 'Accent Color',
            color: theme.accent,
            onChanged: (c) => theme.setAccent(c),
          ),
          _ColorTile(
            title: 'Font Color',
            color: theme.fontColor,
            onChanged: (c) => theme.setFontColor(c),
          ),
          const SizedBox(height: 12),
          Text(
            'Preview',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Headline', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    'This is body text that previews your selected font color and theme.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Button'),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('Outlined'),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Text'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorTile extends StatelessWidget {
  final String title;
  final Color color;
  final ValueChanged<Color> onChanged;

  const _ColorTile({
    required this.title,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color),
        title: Text(title),
        subtitle: Text('#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}'),
        trailing: const Icon(Icons.color_lens_rounded),
        onTap: () async {
          final selected = await showDialog<Color>(
            context: context,
            builder: (_) => _ColorPickerDialog(initial: color),
          );
          if (selected != null) onChanged(selected);
        },
      ),
    );
  }
}

class _ColorPickerDialog extends StatefulWidget {
  final Color initial;
  const _ColorPickerDialog({required this.initial});

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick a color'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: _current,
          onColorChanged: (c) => setState(() => _current = c),
          labelTypes: const [],
          enableAlpha: false,
          pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _current),
          child: const Text('Select'),
        ),
      ],
    );
  }
}
