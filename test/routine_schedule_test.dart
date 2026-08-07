import 'package:flutter_test/flutter_test.dart';
import 'package:kilife/data/routine_schedule.dart';
import 'package:kilife/models/routine.dart';

void main() {
  test('morning routine always includes SPF', () {
    expect(
      morningRoutine.steps.any((step) => step.title.contains('SPF 60')),
      isTrue,
    );
  });

  test('retinal and exfoliating cleanser are never scheduled together', () {
    for (var weekday = DateTime.monday;
        weekday <= DateTime.sunday;
        weekday++) {
      final routine = eveningRoutineForWeekday(weekday);
      final hasRetinal = routine.steps.any(
        (step) => step.title.contains('Retinal + Niacinamide'),
      );
      final hasExfoliatingCleanser = routine.steps.any(
        (step) => step.title.contains('Superfruit Gentle Exfoliating Cleanser'),
      );
      expect(hasRetinal && hasExfoliatingCleanser, isFalse);
    }
  });

  test('Dream Mask appears only on exfoliation nights', () {
    for (var weekday = DateTime.monday;
        weekday <= DateTime.sunday;
        weekday++) {
      final routine = eveningRoutineForWeekday(weekday);
      final hasDreamMask = routine.steps.any(
        (step) => step.title.contains('Dream Mask'),
      );
      expect(hasDreamMask, routine.kind == RoutineKind.exfoliation);
    }
  });
}
