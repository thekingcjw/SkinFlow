import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kilife/data/routine_schedule.dart';
import 'package:kilife/theme/skinflow_theme.dart';
import 'package:kilife/widgets/routine_card.dart';

Widget testApp(Widget child) {
  return MaterialApp(
    theme: buildSkinFlowTheme(),
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );
}

void main() {
  testWidgets('retinal card uses the exact routine name', (tester) async {
    await tester.pumpWidget(
      testApp(
        RoutineCard(
          routine: retinalRoutine,
          complete: false,
          onChanged: (_) {},
        ),
      ),
    );

    expect(find.text('RETINAL NIGHT'), findsOneWidget);
    expect(find.text('Retinal Night'), findsOneWidget);
    expect(find.text('Night routine'), findsNothing);
    expect(find.text('3 face steps ready'), findsOneWidget);
    expect(find.text('MARK RETINAL COMPLETE'), findsOneWidget);
  });

  testWidgets('body care is clearly excluded from face progress', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(const RoutineCard(routine: bodyRoutine)));

    expect(find.text('DAILY · NOT COUNTED'), findsOneWidget);
    expect(find.text('Daily Body Care'), findsOneWidget);
    expect(find.text('Daily after shower · Not counted'), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
  });

  testWidgets('completion action sends the next session state', (tester) async {
    bool? nextValue;
    await tester.pumpWidget(
      testApp(
        RoutineCard(
          routine: exfoliationRoutine,
          complete: false,
          onChanged: (value) => nextValue = value,
        ),
      ),
    );

    await tester.tap(find.text('MARK EXFOLIATION COMPLETE'));

    expect(nextValue, isTrue);
  });
}
