import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/pages/home.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (context) => Home(),
    },

  ));
}

