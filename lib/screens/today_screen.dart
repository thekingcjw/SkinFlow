import 'package:flutter/material.dart';

import '../data/routine_schedule.dart';
import '../services/preferences_service.dart';
import '../widgets/routine_card.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final _preferences = PreferencesService.instance;
  bool _loading = true;
  bool _morningComplete = false;
  bool _eveningComplete = false;
  int _weeklyCompleted = 0;

  DateTime get _today => DateTime.now();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final results = await Future.wait<Object>(<Future<Object>>[
      _preferences.isComplete(_today, 'am'),
      _preferences.isComplete(_today, 'pm'),
      _preferences.completedCountForWeek(_today),
    ]);
    if (!mounted) return;
    setState(() {
      _morningComplete = results[0] as bool;
      _eveningComplete = results[1] as bool;
      _weeklyCompleted = results[2] as int;
      _loading = false;
    });
  }

  Future<void> _setComplete(String period, bool value) async {
    await _preferences.setComplete(_today, period, value);
    if (!mounted) return;
    setState(() {
      if (period == 'am') {
        _morningComplete = value;
      } else {
        _eveningComplete = value;
      }
      _weeklyCompleted += value ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final eveningRoutine = eveningRoutineForWeekday(_today.weekday);
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        children: <Widget>[
          Text(
            weekdayName(_today.weekday),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Today’s routine is ready.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          _ProgressCard(completed: _weeklyCompleted),
          const SizedBox(height: 16),
          RoutineCard(
            routine: morningRoutine,
            complete: _morningComplete,
            onChanged: (value) => _setComplete('am', value),
          ),
          const SizedBox(height: 12),
          RoutineCard(
            routine: eveningRoutine,
            complete: _eveningComplete,
            onChanged: (value) => _setComplete('pm', value),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Never use the retinal serum and exfoliating cleanser in the same routine.',
                    ),
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

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.completed});

  final int completed;

  @override
  Widget build(BuildContext context) {
    const total = 14;
    final progress = completed / total;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(Icons.insights_outlined),
                const SizedBox(width: 8),
                Text(
                  'This week',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const Spacer(),
                Text('$completed / $total'),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: progress.clamp(0.0, 1.0).toDouble()),
          ],
        ),
      ),
    );
  }
}
