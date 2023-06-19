import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/pages/activeWorkout.dart';
import 'package:flutter_fitness_app/pages/addExercise.dart';
import 'package:flutter_fitness_app/pages/addFood.dart';
import 'package:flutter_fitness_app/pages/measure.dart';
import 'package:flutter_fitness_app/pages/navigation.dart';
import 'package:flutter_fitness_app/pages/profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("Navigate to Measure page and select date range",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.red[800],
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => const Navigation(),
        "/activeWorkout": (context) => const ActiveWorkout(),
        "/addExercise": (context) => const AddExercise(),
        "/addFood": (context) => const AddFood(),
        "/profile": (context) => const Profile()
      },
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.bar_chart));
    await tester.pumpAndSettle();

    expect(find.byType(Measure), findsOneWidget);

    await tester.tap(find.byIcon(Icons.date_range));
    await tester.pumpAndSettle();

    await tester.tap(find.text('1')); // Start date
    await tester.tap(find.text('7')); // End date
    await tester.tap(find.text('SAVE'));
    await tester.pumpAndSettle();

    expect(find.text('Jun 01, 2023 - Jun 07, 2023'), findsOneWidget);
    expect(find.text('Calories'), findsOneWidget);
    expect(find.text('Proteins'), findsOneWidget);
  });
}
