import 'package:flutter/material.dart';

import '../main.dart';
import '../pages/activeWorkout.dart';
import '../pages/addExercise.dart';
import '../pages/addFood.dart';
import '../pages/introscene.dart';
import '../pages/profile.dart';
import '../pages/workout.dart';

class MyApp extends StatelessWidget {
  final bool isDarkMode;
  final String color;

  const MyApp({required this.isDarkMode, required this.color});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = isDarkMode ? darkTheme : lightTheme;
    theme = theme.copyWith(colorScheme: getColorScheme(color));

    return MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => const MainScaffold(),
        "/introScreen": (context) => const IntroScreen(),
        "/activeWorkout": (context) => const ActiveWorkout(),
        "/addExercise": (context) => const AddExercise(),
        "/addFood": (context) => const AddFood(),
        "/profile": (context) => const Profile(),
        "/workout": (context) => Workout(),
      },
    );
  }
}
