import 'package:flutter/material.dart';

import '../services/notification_service.dart';
import '../services/preferences_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _preferences = PreferencesService.instance;
  final _notifications = NotificationService.instance;

  AppSettings? _settings;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final settings = await _preferences.loadSettings();
    if (!mounted) return;
    setState(() => _settings = settings);
  }

  Future<void> _update(AppSettings settings) async {
    setState(() {
      _settings = settings;
      _saving = true;
    });
    await _preferences.saveSettings(settings);
    await _notifications.reschedule(settings);
    if (!mounted) return;
    setState(() => _saving = false);
  }

  Future<void> _pickTime({required bool morning}) async {
    final settings = _settings;
    if (settings == null) return;
    final selected = await showTimePicker(
      context: context,
      initialTime: morning ? settings.morningTime : settings.eveningTime,
    );
    if (selected == null) return;
    await _update(
      settings.copyWith(
        morningTime: morning ? selected : null,
        eveningTime: morning ? null : selected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = _settings;
    if (settings == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'Notifications',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
            if (_saving)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Choose your own reminder times.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: <Widget>[
              SwitchListTile(
                title: const Text('Morning reminder'),
                subtitle: Text(settings.morningTime.format(context)),
                value: settings.morningEnabled,
                onChanged: (value) =>
                    _update(settings.copyWith(morningEnabled: value)),
              ),
              ListTile(
                enabled: settings.morningEnabled,
                leading: const Icon(Icons.schedule),
                title: const Text('Morning time'),
                trailing: Text(settings.morningTime.format(context)),
                onTap: () => _pickTime(morning: true),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: <Widget>[
              SwitchListTile(
                title: const Text('Evening reminder'),
                subtitle: Text(settings.eveningTime.format(context)),
                value: settings.eveningEnabled,
                onChanged: (value) =>
                    _update(settings.copyWith(eveningEnabled: value)),
              ),
              ListTile(
                enabled: settings.eveningEnabled,
                leading: const Icon(Icons.schedule),
                title: const Text('Evening time'),
                trailing: Text(settings.eveningTime.format(context)),
                onTap: () => _pickTime(morning: false),
              ),
              SwitchListTile(
                title: const Text('Follow-up reminder'),
                subtitle: const Text('One hour after the evening reminder.'),
                value: settings.followUpEnabled,
                onChanged: settings.eveningEnabled
                    ? (value) =>
                        _update(settings.copyWith(followUpEnabled: value))
                    : null,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () async {
            final granted = await _notifications.requestPermission();
            if (!context.mounted) return;
            if (!granted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notification permission was not granted.'),
                ),
              );
              return;
            }
            await _notifications.reschedule(settings);
            await _notifications.showTestNotification();
          },
          icon: const Icon(Icons.notifications_active_outlined),
          label: const Text('Enable and test notifications'),
        ),
        const SizedBox(height: 12),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'KiLife stores your settings and completion history only on this phone. No account or cloud service is required.',
            ),
          ),
        ),
      ],
    );
  }
}
