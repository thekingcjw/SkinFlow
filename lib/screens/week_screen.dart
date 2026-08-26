import 'package:flutter/material.dart';

import '../data/routine_schedule.dart';
import '../models/routine.dart';

class WeekScreen extends StatelessWidget {
  const WeekScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: <Widget>[
        Text(
          'Weekly schedule',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Morning and body care are the same every day. Night routine changes by day.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 16),
        for (var weekday = DateTime.monday;
            weekday <= DateTime.sunday;
            weekday++)
          _DayTile(
            weekday: weekday,
            routine: eveningRoutineForWeekday(weekday),
          ),
      ],
    );
  }
}

class _DayTile extends StatelessWidget {
  const _DayTile({required this.weekday, required this.routine});

  final int weekday;
  final RoutinePlan routine;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: CircleAvatar(
          child: Text(weekdayName(weekday).substring(0, 1)),
        ),
        title: Text(
          weekdayName(weekday),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(routine.typeLabel ?? routine.title),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: <Widget>[
          for (final step in routine.steps)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(step.icon),
              title: Text(step.title),
              subtitle: Text(step.subtitle),
            ),
          const Divider(),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(bodyRoutine.steps.first.icon),
            title: Text(bodyRoutine.steps.first.title),
            subtitle: const Text('Body care · Daily after shower'),
          ),
        ],
      ),
    );
  }
}
