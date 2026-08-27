import 'package:flutter/material.dart';

enum RoutineKind { morning, retinal, exfoliation, recovery, body }

class RoutineStep {
  const RoutineStep({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.note,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String? note;
}

class RoutinePlan {
  const RoutinePlan({
    required this.kind,
    required this.title,
    required this.description,
    required this.steps,
    this.typeLabel,
  });

  final RoutineKind kind;
  final String title;
  final String? typeLabel;
  final String description;
  final List<RoutineStep> steps;

  /// The canonical, user-facing routine name used outside the full card.
  ///
  /// Keeping this tied to [title] prevents compact surfaces such as the
  /// weekly schedule and notifications from falling back to a generic
  /// "Night routine" label.
  String get displayLabel => title;

  /// Body care is useful routine context, but it is deliberately excluded
  /// from the weekly face-routine denominator (7 mornings + 7 evenings).
  bool get countsTowardFaceProgress => kind != RoutineKind.body;
}
