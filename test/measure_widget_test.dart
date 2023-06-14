  import 'package:flutter/material.dart';
  import 'package:flutter_fitness_app/pages/activeWorkout.dart';
  import 'package:flutter_fitness_app/pages/addExercise.dart';
  import 'package:flutter_fitness_app/pages/addFavoriteMeal.dart';
  import 'package:flutter_fitness_app/pages/addFood.dart';
  import 'package:flutter_fitness_app/pages/navigation.dart';
  import 'package:flutter_fitness_app/pages/profile.dart';
  import 'package:flutter_fitness_app/pages/profileSettings.dart';
  import 'package:flutter_test/flutter_test.dart';
  import 'package:flutter_fitness_app/pages/measure.dart';

  void main() {
    testWidgets("Navigate to Measure page and select date range",
            (WidgetTester tester) async {
          // Start the app
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
              "/addFavoriteMeal": (context) => const AddFavoriteMeal(),
              "/addFood": (context) => const AddFood(),
              "/profileSettings": (context) => const ProfileSettings(),
              "/profile": (context) => const Profile()
            },
          ));
          await tester.pumpAndSettle();

          // Find the 'Measure' icon and tap on it
          await tester.tap(find.byIcon(Icons.bar_chart));
          await tester.pumpAndSettle();

          // Verify Measure page is displayed
          expect(find.byType(Measure), findsOneWidget);

          // Tap on the date range icon to open the date picker
          await tester.tap(find.byIcon(Icons.date_range));
          await tester.pumpAndSettle();

          // Select a start and end date from the picker
          // Note: These steps are just examples and may need to be adjusted to fit your date picker's structure and usage.
          await tester.tap(find.text('1')); // Start date
          await tester.tap(find.text('7')); // End date
          await tester.tap(find.text('SAVE')); // Confirm date range
          await tester.pumpAndSettle();

          // Verify that the selected date range is displayed in the AppBar
          expect(find.text('Jun 01, 2023 - Jun 07, 2023'), findsOneWidget);
        });
  }
