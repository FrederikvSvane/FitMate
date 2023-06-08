import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/pages/navigation.dart';


Future<void> main()  async {


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
    },
  ));
}

