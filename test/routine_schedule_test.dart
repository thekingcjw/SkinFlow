import 'package:flutter_test/flutter_test.dart';
import 'package:kilife/data/routine_schedule.dart';
import 'package:kilife/models/routine.dart';

void main() {
  test('morning routine matches the authoritative four-step order', () {
    expect(morningRoutine.title, 'Morning Routine');
    expect(morningRoutine.typeLabel, 'Morning Routine');
    expect(morningRoutine.displayLabel, 'Morning Routine');
    expect(morningRoutine.countsTowardFaceProgress, isTrue);
    expect(morningRoutine.steps.map((step) => step.title).toList(), <String>[
      'Superfood Antioxidant Cleanser',
      'Superfood Skin Drip Smooth + Glow Serum',
      'Air-Whip Moisture Cream',
      'Youthscreen SPF 60',
    ]);
  });

  test('evening plans use exact routine-state labels', () {
    expect(retinalRoutine.title, 'Retinal Night');
    expect(retinalRoutine.typeLabel, 'Retinal Night');
    expect(retinalRoutine.displayLabel, 'Retinal Night');
    expect(exfoliationRoutine.title, 'Exfoliation Night');
    expect(exfoliationRoutine.typeLabel, 'Exfoliation Night');
    expect(exfoliationRoutine.displayLabel, 'Exfoliation Night');
    expect(recoveryRoutine.title, 'Recovery Night');
    expect(recoveryRoutine.typeLabel, 'Recovery Night');
    expect(recoveryRoutine.displayLabel, 'Recovery Night');
    expect(retinalRoutine.countsTowardFaceProgress, isTrue);
    expect(exfoliationRoutine.countsTowardFaceProgress, isTrue);
    expect(recoveryRoutine.countsTowardFaceProgress, isTrue);
  });

  test('evening notification titles identify the scheduled routine', () {
    expect(eveningNotificationTitle(DateTime.monday), 'Monday — Retinal Night');
    expect(
      eveningNotificationTitle(DateTime.tuesday),
      'Tuesday — Retinal Night',
    );
    expect(
      eveningNotificationTitle(DateTime.wednesday),
      'Wednesday — Exfoliation Night',
    );
    expect(
      eveningNotificationTitle(DateTime.thursday),
      'Thursday — Retinal Night',
    );
    expect(eveningNotificationTitle(DateTime.friday), 'Friday — Retinal Night');
    expect(
      eveningNotificationTitle(DateTime.saturday),
      'Saturday — Exfoliation Night',
    );
    expect(eveningNotificationTitle(DateTime.sunday), 'Sunday — Retinal Night');
  });

  test(
    'recovery fallback includes Skin Drip between cleanser and moisturizer',
    () {
      expect(recoveryRoutine.steps.map((step) => step.title).toList(), <String>[
        'Superfood Antioxidant Cleanser',
        'Superfood Skin Drip Smooth + Glow Serum',
        'Air-Whip Moisture Cream',
      ]);
    },
  );

  test(
    'exfoliation routine uses Skin Drip and Dream Mask without Air-Whip',
    () {
      expect(
        exfoliationRoutine.steps.map((step) => step.title).toList(),
        <String>[
          'Superfruit Gentle Exfoliating Cleanser',
          'Superfood Skin Drip Smooth + Glow Serum',
          'Superberry Hydrate + Glow Dream Mask',
        ],
      );
    },
  );

  test('Skin Drip is not scheduled on retinal nights', () {
    expect(
      retinalRoutine.steps.any((step) => step.title.contains('Skin Drip')),
      isFalse,
    );
  });

  test(
    'weekday schedule is five retinal nights and two exfoliation nights',
    () {
      expect(
        eveningRoutineForWeekday(DateTime.monday).kind,
        RoutineKind.retinal,
      );
      expect(
        eveningRoutineForWeekday(DateTime.tuesday).kind,
        RoutineKind.retinal,
      );
      expect(
        eveningRoutineForWeekday(DateTime.wednesday).kind,
        RoutineKind.exfoliation,
      );
      expect(
        eveningRoutineForWeekday(DateTime.thursday).kind,
        RoutineKind.retinal,
      );
      expect(
        eveningRoutineForWeekday(DateTime.friday).kind,
        RoutineKind.retinal,
      );
      expect(
        eveningRoutineForWeekday(DateTime.saturday).kind,
        RoutineKind.exfoliation,
      );
      expect(
        eveningRoutineForWeekday(DateTime.sunday).kind,
        RoutineKind.retinal,
      );
    },
  );

  test(
    'recovery remains a fallback and is not part of the weekly schedule',
    () {
      for (
        var weekday = DateTime.monday;
        weekday <= DateTime.sunday;
        weekday++
      ) {
        expect(
          eveningRoutineForWeekday(weekday).kind,
          isNot(RoutineKind.recovery),
        );
      }
    },
  );

  test('retinal and exfoliating cleanser are never scheduled together', () {
    for (var weekday = DateTime.monday; weekday <= DateTime.sunday; weekday++) {
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
    for (var weekday = DateTime.monday; weekday <= DateTime.sunday; weekday++) {
      final routine = eveningRoutineForWeekday(weekday);
      final hasDreamMask = routine.steps.any(
        (step) => step.title.contains('Dream Mask'),
      );
      expect(hasDreamMask, routine.kind == RoutineKind.exfoliation);
    }
  });

  test('body care is a daily informational routine with Body Butter', () {
    expect(bodyRoutine.kind, RoutineKind.body);
    expect(bodyRoutine.title, 'Daily Body Care');
    expect(bodyRoutine.typeLabel, 'Daily · Not counted');
    expect(bodyRoutine.displayLabel, 'Daily Body Care');
    expect(bodyRoutine.countsTowardFaceProgress, isFalse);
    expect(bodyRoutine.steps.length, 1);
    expect(
      bodyRoutine.steps.single.title,
      'Superberry Hydrate + Glow Dream Body Butter',
    );
  });

  test('routine step notes preserve the recommended starting amounts', () {
    expect(morningRoutine.steps[0].note, '1–2 pumps');
    expect(
      morningRoutine.steps[1].note,
      '1 pump to start; increase to 2 only if desired and well tolerated',
    );
    expect(morningRoutine.steps[2].note, 'Dime-size amount');
    expect(
      morningRoutine.steps[3].note,
      'About 2 finger-lengths for face + neck',
    );
    expect(
      retinalRoutine.steps[1].note,
      'Pea-size for the whole face; apply as a thin film',
    );
    expect(exfoliationRoutine.steps[0].note, 'Dime-size amount');
    expect(
      exfoliationRoutine.steps[1].note,
      '1 pump to start; increase to 2 only if desired and well tolerated',
    );
    expect(
      exfoliationRoutine.steps[2].note,
      'Nickel-size amount / thin even layer',
    );
  });
}
