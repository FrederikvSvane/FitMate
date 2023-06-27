import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/DB/DBHelper.dart';
import 'package:flutter_fitness_app/classes/activeWorkoutState.dart';
import 'package:flutter_fitness_app/pages/activeWorkoutWindow.dart';
import 'package:flutter_fitness_app/pages/navigation.dart';
import 'package:flutter_fitness_app/widgets/my_app.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

Database? database;

bool isInDebugMode = false;

final ThemeData lightTheme = ThemeData.light();
final ThemeData darkTheme = ThemeData.dark();

final Map<String, ColorScheme> colorSchemes = {
  'blue': const ColorScheme.light(primary: Colors.blue),
  'red': const ColorScheme.light(primary: Colors.red),
  'yellow': const ColorScheme.light(primary: Colors.yellow),
  'green': const ColorScheme.light(primary: Colors.green),
  'purple': const ColorScheme.light(primary: Colors.purple),
  'orange': const ColorScheme.light(primary: Colors.orange),
  'pink': const ColorScheme.light(primary: Colors.pink),
  'white': const ColorScheme.light(primary: Colors.white),
};

ColorScheme getColorScheme(String color) {
  return colorSchemes[color] ?? const ColorScheme.light();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure initialized

  assert(() {
    isInDebugMode = true;
    return true;
  }());

  database = await DBHelper.getDatabase();

  await DBHelper.insertMockData();

  SharedPreferences prefs = await SharedPreferences.getInstance(); // Now this should be fine.
  bool isDarkMode = prefs.getBool('dark_mode') ?? false;
  String color = prefs.getString('color_scheme') ?? 'blue';
  if (isDarkMode) {
    color = 'white';
  }

  runApp(ChangeNotifierProvider(
    create: (context) => ActiveWorkoutState(),
    child: MyApp(isDarkMode: isDarkMode, color: color),
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
