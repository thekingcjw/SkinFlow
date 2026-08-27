import 'package:flutter/material.dart';

import '../models/routine.dart';
import '../theme/skinflow_theme.dart';

class RoutineCard extends StatelessWidget {
  const RoutineCard({
    super.key,
    required this.routine,
    this.complete,
    this.onChanged,
  });

  final RoutinePlan routine;
  final bool? complete;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final accent = _accentFor(routine.kind);
    final showCompletionAction = complete != null && onChanged != null;
    final isComplete = complete == true;
    final faceStepLabel = routine.steps.length == 1 ? 'step' : 'steps';
    final summary = routine.countsTowardFaceProgress
        ? '${routine.steps.length} face $faceStepLabel ${isComplete ? 'complete' : 'ready'}'
        : 'Daily after shower · Not counted';

    return Card(
      clipBehavior: Clip.antiAlias,
      color: isComplete
          ? SkinFlowColors.selectedContainer
          : SkinFlowColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: isComplete ? accent.withAlpha(150) : Colors.transparent,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    (routine.typeLabel ?? routine.title).toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF3A2B40),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                if (isComplete)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: accent),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'COMPLETE',
                      style: TextStyle(
                        color: accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              routine.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: SkinFlowColors.primaryText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              summary,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: SkinFlowColors.secondaryText,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              routine.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: SkinFlowColors.secondaryText,
                height: 1.35,
              ),
            ),
            if (showCompletionAction) ...<Widget>[
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  minHeight: 6,
                  value: isComplete ? 1 : 0,
                  color: accent,
                  backgroundColor: SkinFlowColors.appBackground,
                ),
              ),
            ],
            const SizedBox(height: 20),
            for (
              var index = 0;
              index < routine.steps.length;
              index++
            ) ...<Widget>[
              _StepRow(
                number: index + 1,
                step: routine.steps[index],
                accent: accent,
                complete: isComplete,
              ),
              if (index != routine.steps.length - 1) const SizedBox(height: 12),
            ],
            if (showCompletionAction) ...<Widget>[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => onChanged!(!complete!),
                  style: FilledButton.styleFrom(
                    backgroundColor: isComplete
                        ? SkinFlowColors.cardEmphasized
                        : accent,
                    foregroundColor: isComplete
                        ? SkinFlowColors.primaryText
                        : const Color(0xFF3A2B40),
                  ),
                  child: Text(_actionLabel(routine.kind, isComplete)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _actionLabel(RoutineKind kind, bool isComplete) {
    if (isComplete) return 'MARK AS NOT COMPLETE';
    return switch (kind) {
      RoutineKind.morning => 'MARK MORNING COMPLETE',
      RoutineKind.retinal => 'MARK RETINAL COMPLETE',
      RoutineKind.exfoliation => 'MARK EXFOLIATION COMPLETE',
      RoutineKind.recovery => 'MARK RECOVERY COMPLETE',
      RoutineKind.body => 'BODY CARE IS NOT COUNTED',
    };
  }

  Color _accentFor(RoutineKind kind) {
    return switch (kind) {
      RoutineKind.morning => SkinFlowColors.morning,
      RoutineKind.retinal => SkinFlowColors.retinal,
      RoutineKind.exfoliation => SkinFlowColors.exfoliation,
      RoutineKind.recovery => SkinFlowColors.recovery,
      RoutineKind.body => SkinFlowColors.body,
    };
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.number,
    required this.step,
    required this.accent,
    required this.complete,
  });

  final int number;
  final RoutineStep step;
  final Color accent;
  final bool complete;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 52),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: complete ? accent : SkinFlowColors.cardEmphasized,
              shape: BoxShape.circle,
              border: Border.all(color: accent),
            ),
            alignment: Alignment.center,
            child: complete
                ? const Icon(
                    Icons.check_rounded,
                    color: Color(0xFF3A2B40),
                    size: 18,
                  )
                : Text(
                    '$number',
                    style: TextStyle(
                      color: accent,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  step.subtitle.toUpperCase(),
                  style: TextStyle(
                    color: accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  step.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: SkinFlowColors.primaryText,
                    fontSize: 14,
                    height: 1.25,
                  ),
                ),
                if (step.note != null) ...<Widget>[
                  const SizedBox(height: 2),
                  Text(
                    step.note!,
                    style: const TextStyle(
                      color: SkinFlowColors.secondaryText,
                      fontSize: 12,
                      height: 1.25,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
