import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/pages/navigation.dart';
import'package:http/http.dart' as http;

import 'classes/FoodApi.dart';

void main() {
  FoodApi foodApi = FoodApi;
  foodApi.fetchFoodApi(5060337502290);
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
      "/": (context) => Navigation(),
    },

  ));
}

