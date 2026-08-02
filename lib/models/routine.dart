import 'package:flutter/material.dart';

enum RoutineKind { morning, retinal, exfoliation, recovery }

class RoutineStep {
  const RoutineStep({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}

class RoutinePlan {
  const RoutinePlan({
    required this.kind,
    required this.title,
    required this.description,
    required this.steps,
  });

  final RoutineKind kind;
  final String title;
  final String description;
  final List<RoutineStep> steps;
}
