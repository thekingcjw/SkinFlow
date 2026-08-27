import 'package:flutter/material.dart';

import '../data/routine_schedule.dart';
import '../models/progress_metrics.dart';
import '../services/completion_repository.dart';
import '../theme/skinflow_theme.dart';
import '../widgets/routine_card.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final _history = CompletionRepository.instance;
  final Set<String> _savingPeriods = <String>{};

  late DateTime _weekStart;
  late DateTime _weekEnd;
  late Stream<List<CompletionRecord>> _weekEntries;

  DateTime get _today => DateTime.now();

  @override
  void initState() {
    super.initState();
    _resetWeekStream();
  }

  void _resetWeekStream() {
    final today = _dayOnly(_today);
    _weekStart = today.subtract(
      Duration(days: today.weekday - DateTime.monday),
    );
    _weekEnd = _weekStart.add(const Duration(days: 6));
    _weekEntries = _history.watchEntriesBetween(_weekStart, _weekEnd);
  }

  Future<void> _refresh() async {
    setState(_resetWeekStream);
    try {
      await _history.entriesBetween(_weekStart, _weekEnd);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Couldn’t load routine history. Pull down to retry.'),
        ),
      );
    }
  }

  Future<void> _setComplete(String period, bool value) async {
    if (!_savingPeriods.add(period)) return;

    try {
      await _history.setComplete(_today, period, value);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Couldn’t update progress. Try again.')),
      );
    } finally {
      _savingPeriods.remove(period);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CompletionRecord>>(
      stream: _weekEntries,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 96, 24, 24),
              children: const <Widget>[
                Icon(Icons.error_outline, size: 40),
                SizedBox(height: 12),
                Text(
                  'Routine history couldn’t load. Pull down to retry.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: SkinFlowColors.secondaryText),
                ),
              ],
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final today = _dayOnly(_today);
        final entries = snapshot.data!;
        final morningComplete = _isComplete(entries, today, 'am');
        final eveningComplete = _isComplete(entries, today, 'pm');
        final weeklyCompleted = countCompletedSessions(entries);
        final eveningRoutine = eveningRoutineForWeekday(today.weekday);

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: <Widget>[
              Text(
                _dateLabel(today),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: SkinFlowColors.secondaryText,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Today',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: SkinFlowColors.primaryText,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${morningRoutine.displayLabel} · ${eveningRoutine.displayLabel}',
                style: const TextStyle(
                  color: SkinFlowColors.secondaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              _ProgressCard(completed: weeklyCompleted),
              const SizedBox(height: 12),
              RoutineCard(
                routine: morningRoutine,
                complete: morningComplete,
                onChanged: (value) => _setComplete('am', value),
              ),
              const SizedBox(height: 12),
              RoutineCard(
                routine: eveningRoutine,
                complete: eveningComplete,
                onChanged: (value) => _setComplete('pm', value),
              ),
              const SizedBox(height: 12),
              const RoutineCard(routine: bodyRoutine),
              const SizedBox(height: 12),
              const _SafetyNote(),
            ],
          ),
        );
      },
    );
  }
}

DateTime _dayOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

bool _isComplete(
  Iterable<CompletionRecord> entries,
  DateTime day,
  String period,
) {
  return entries.any(
    (entry) =>
        entry.complete && entry.period == period && _dayOnly(entry.day) == day,
  );
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
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'THIS WEEK',
                        style: TextStyle(
                          color: SkinFlowColors.secondaryText,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.7,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Face routines',
                        style: TextStyle(
                          color: SkinFlowColors.primaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '$completed / $total',
                  style: const TextStyle(
                    color: SkinFlowColors.primaryText,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: progress.clamp(0.0, 1.0).toDouble(),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '7 mornings + 7 evenings · Body Care is not counted',
              style: TextStyle(
                color: SkinFlowColors.secondaryText,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SafetyNote extends StatelessWidget {
  const _SafetyNote();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Icon(
              Icons.shield_outlined,
              color: SkinFlowColors.recovery,
              size: 22,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Pause actives if irritated',
                    style: TextStyle(
                      color: SkinFlowColors.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Switch tonight to Recovery Night: Cleanser, Skin Drip, and Air-Whip. Never combine retinal with the exfoliating cleanser.',
                    style: TextStyle(
                      color: SkinFlowColors.secondaryText,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _dateLabel(DateTime day) {
  const months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${weekdayName(day.weekday)}, ${months[day.month - 1]} ${day.day}';
}
