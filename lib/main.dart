import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/DB/DBHelper.dart';
import 'package:flutter_fitness_app/pages/activeWorkout.dart';
import 'package:flutter_fitness_app/pages/addExercise.dart';
import 'package:flutter_fitness_app/pages/addFavoriteMeal.dart';
import 'package:flutter_fitness_app/pages/navigation.dart';
import 'package:flutter_fitness_app/pages/addFood.dart';
import 'package:flutter_fitness_app/pages/profile.dart';
import 'package:flutter_fitness_app/pages/profileSettings.dart';
import 'package:sqflite/sqflite.dart';

Database? database;

bool isInDebugMode = false;

Future<void> main() async {
  assert(() {
    // During development, this flag is true
    isInDebugMode = true;
    return true;
  }());

  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  database = await DBHelper.getDatabase();

  // Insert mock data if in debug mode.
  await DBHelper.insertMockData();

  runApp(MaterialApp(
    theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.red[800],
        )),
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
}
