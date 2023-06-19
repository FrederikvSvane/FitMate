import 'dart:core';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController activityLevelController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Enter your name',
                ),
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(
                  labelText: 'Enter your age',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: weightController,
                decoration: const InputDecoration(
                  labelText: 'Enter your weight in Kg',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: heightController,
                decoration: const InputDecoration(
                  labelText: 'Enter your height in cm',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  var nav = Navigator.of(context);
                  String name = nameController.text;
                  int age = int.tryParse(ageController.text) ?? 0;
                  print("Name: $name, Age: $age");
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('name', name);
                  prefs.setInt('age', age);
                  prefs.setDouble('weight', double.tryParse(weightController.text) ?? 0);
                  prefs.setDouble('height', double.tryParse(heightController.text) ?? 0);
                  prefs.setBool('intro', true);


                  nav.pushReplacementNamed("/");
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}