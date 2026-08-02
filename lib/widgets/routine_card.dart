import 'package:flutter/material.dart';

import '../models/routine.dart';

class RoutineCard extends StatelessWidget {
  const RoutineCard({
    super.key,
    required this.routine,
    required this.complete,
    required this.onChanged,
  });

  final RoutinePlan routine;
  final bool complete;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final accent = _accentFor(routine.kind, colors);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(_iconFor(routine.kind), color: accent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        routine.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        routine.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            for (var index = 0; index < routine.steps.length; index++) ...<Widget>[
              _StepRow(step: routine.steps[index], accent: accent),
              if (index != routine.steps.length - 1)
                Padding(
                  padding: const EdgeInsets.only(left: 17),
                  child: Container(
                    height: 18,
                    width: 2,
                    color: colors.outlineVariant,
                  ),
                ),
            ],
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => onChanged(!complete),
                icon: Icon(complete ? Icons.check_circle : Icons.circle_outlined),
                label: Text(complete ? 'Completed' : 'Mark complete'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _accentFor(RoutineKind kind, ColorScheme colors) {
    return switch (kind) {
      RoutineKind.morning => colors.tertiary,
      RoutineKind.retinal => colors.primary,
      RoutineKind.exfoliation => colors.secondary,
      RoutineKind.recovery => colors.primaryContainer,
    };
  }

  IconData _iconFor(RoutineKind kind) {
    return switch (kind) {
      RoutineKind.morning => Icons.wb_sunny_outlined,
      RoutineKind.retinal => Icons.science_outlined,
      RoutineKind.exfoliation => Icons.auto_awesome_outlined,
      RoutineKind.recovery => Icons.shield_outlined,
    };
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step, required this.accent});

  final RoutineStep step;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(step.icon, size: 20, color: accent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  step.subtitle.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                ),
                const SizedBox(height: 2),
                Text(step.title),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
