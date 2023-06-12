import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/DB/DBHelper.dart';
import 'package:flutter_fitness_app/pages/activeWorkout.dart';
import 'package:flutter_fitness_app/pages/addExercise.dart';
import 'package:flutter_fitness_app/pages/navigation.dart';
import 'package:flutter_fitness_app/pages/addFood.dart';
import 'package:flutter_fitness_app/pages/profileSettings.dart';

var database;

bool isInDebugMode = false;

Future<void> main() async {
  assert(() {
    // During development, this flag is true
    isInDebugMode = true;
    return true;
  }());
// Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();

  // Open the database and store the reference.
  database = await DBHelper().getDB();

  runApp(MaterialApp(
    // theme: ThemeData(
    //   brightness: Brightness.light,
    //   /* light theme settings */
    // ),
    // darkTheme: ThemeData(
    //   brightness: Brightness.dark,
    //   /* dark theme settings */
    // ),
    // themeMode: ThemeMode.dark,
    // /* ThemeMode.system to follow system theme,
    //      ThemeMode.light for light theme,
    //      ThemeMode.dark for dark theme
    //   */

    theme: ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(

        primary: Colors.red[800],
      )
    ),

    debugShowCheckedModeBanner: false,

    initialRoute: "/",
    routes: {
      "/": (context) => const Navigation(),
      "/activeWorkout": (context) => const ActiveWorkout(),
      "/addExercise": (context) => const AddExercise(),

      "/addFood": (context) => const AddFood(),

      "/profileSettings": (context) => const ProfileSettings(),
    },
  ));
}

