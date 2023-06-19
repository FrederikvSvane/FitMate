import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/DB/DBHelper.dart';
import 'package:flutter_fitness_app/pages/activeWorkout.dart';
import 'package:flutter_fitness_app/pages/activeWorkoutWindow.dart';
import 'package:flutter_fitness_app/pages/addExercise.dart';
import 'package:flutter_fitness_app/pages/addFavoriteMeal.dart';
import 'package:flutter_fitness_app/pages/addFood.dart';
import 'package:flutter_fitness_app/pages/introScene.dart';
import 'package:flutter_fitness_app/pages/navigation.dart';
import 'package:flutter_fitness_app/pages/profile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_fitness_app/classes/activeWorkoutState.dart';

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

  runApp(ChangeNotifierProvider(
    create: (context) => ActiveWorkoutState(),
    child: MaterialApp(
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
      )),

      debugShowCheckedModeBanner: false,

      initialRoute: "/",
      routes: {
        "/": (context) => const MainScaffold(),
        "/introScreen": (context) => IntroScreen(), // Add this line
        "/activeWorkout": (context) => const ActiveWorkout(),
        "/addExercise": (context) => const AddExercise(),
        "/addFavoriteMeal": (context) => const AddFavoriteMeal(),
        "/addFood": (context) => const AddFood(),
        "/profile": (context) => const Profile()
      },
    ),
  ));
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  @override
  void initState() {
    super.initState();
    checkFirstSeen();
  }

  Future checkFirstSeen() async {
    var nav = Navigator.of(context);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool introSeen = (prefs.getBool('intro_seen') ?? false);

    if (!introSeen) {
      await prefs.setBool('intro_seen', true);
      nav.pushReplacementNamed("/introScreen");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Navigation(),
        Positioned(
          bottom: 0,
          child: Consumer<ActiveWorkoutState>(
            builder: (context, activeWorkoutState, child) {
              if (activeWorkoutState.isActive) {
                return ActiveWorkoutWindow();
              } else {
                return Container();
              }
            },
          ),
        ),
      ],
    );
  }
}
