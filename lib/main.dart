import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/pages/addExercise.dart';
import 'package:flutter_fitness_app/pages/navigation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_fitness_app/pages/addFood.dart';

var database;

Future<void> main() async {
// Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();

  // Open the database and store the reference.
  database = await openDatabase(
    join(await getDatabasesPath(), 'meal_database.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE meals(barcode INTEGER PRIMARY KEY, nameComponent TEXT, calories REAL, proteins REAL)',
      );
    },
    version: 1,
  );

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

    debugShowCheckedModeBanner: false,

    initialRoute: "/",
    routes: {
      "/": (context) => const Navigation(),
      "/activeWorkout": (context) => const ActiveWorkout(),
      "/addExercise": (context) => const AddExercise(),

      "/addFood": (context) => const AddFood(),
    },
  ));
}

