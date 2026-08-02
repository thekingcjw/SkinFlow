import 'package:flutter/material.dart';

import '../models/routine.dart';

const RoutinePlan morningRoutine = RoutinePlan(
  kind: RoutineKind.morning,
  title: 'Morning routine',
  description: 'Cleanse, moisturize, and protect.',
  steps: <RoutineStep>[
    RoutineStep(
      title: 'Superfood Antioxidant Cleanser',
      subtitle: 'Cleanse',
      icon: Icons.water_drop_outlined,
    ),
    RoutineStep(
      title: 'Air-Whip Moisture Cream',
      subtitle: 'Moisturize',
      icon: Icons.spa_outlined,
    ),
    RoutineStep(
      title: 'Youthscreen SPF 60',
      subtitle: 'Protect',
      icon: Icons.wb_sunny_outlined,
    ),
  ],
);

const RoutinePlan retinalRoutine = RoutinePlan(
  kind: RoutineKind.retinal,
  title: 'Retinal night',
  description: 'Skin-renewal night. Keep the routine simple.',
  steps: <RoutineStep>[
    RoutineStep(
      title: 'Superfood Antioxidant Cleanser',
      subtitle: 'Cleanse',
      icon: Icons.water_drop_outlined,
    ),
    RoutineStep(
      title: 'Retinal + Niacinamide Youth Serum',
      subtitle: 'Treat',
      icon: Icons.science_outlined,
    ),
    RoutineStep(
      title: 'Air-Whip Moisture Cream',
      subtitle: 'Moisturize',
      icon: Icons.spa_outlined,
    ),
  ],
);

const RoutinePlan exfoliationRoutine = RoutinePlan(
  kind: RoutineKind.exfoliation,
  title: 'Exfoliation + Dream Mask',
  description: 'Exfoliate gently, then finish with extra hydration.',
  steps: <RoutineStep>[
    RoutineStep(
      title: 'Superfruit Gentle Exfoliating Cleanser',
      subtitle: 'Exfoliate',
      icon: Icons.auto_awesome_outlined,
    ),
    RoutineStep(
      title: 'Air-Whip Moisture Cream',
      subtitle: 'Moisturize',
      icon: Icons.spa_outlined,
    ),
    RoutineStep(
      title: 'Superberry Hydrate + Glow Dream Mask',
      subtitle: 'Overnight mask',
      icon: Icons.bedtime_outlined,
    ),
  ],
);

const RoutinePlan recoveryRoutine = RoutinePlan(
  kind: RoutineKind.recovery,
  title: 'Recovery night',
  description: 'No actives. Give your skin barrier a quiet night.',
  steps: <RoutineStep>[
    RoutineStep(
      title: 'Superfood Antioxidant Cleanser',
      subtitle: 'Cleanse',
      icon: Icons.water_drop_outlined,
    ),
    RoutineStep(
      title: 'Air-Whip Moisture Cream',
      subtitle: 'Moisturize',
      icon: Icons.spa_outlined,
    ),
  ],
);

RoutinePlan eveningRoutineForWeekday(int weekday) {
  switch (weekday) {
    case DateTime.monday:
    case DateTime.wednesday:
    case DateTime.friday:
      return retinalRoutine;
    case DateTime.tuesday:
    case DateTime.saturday:
      return exfoliationRoutine;
    case DateTime.thursday:
    case DateTime.sunday:
      return recoveryRoutine;
    default:
      throw ArgumentError.value(weekday, 'weekday', 'Must be 1 through 7.');
  }
}

String weekdayName(int weekday) {
  const names = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  return names[weekday - 1];
}

String compactNotificationBody(RoutinePlan routine) {
  return routine.steps.map((step) => step.subtitle).join(' → ');
}
