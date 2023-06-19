import 'dart:core';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {

  const IntroScreen({Key? key}) : super(key: key);

  @override
  IntroScreenState createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController activityLevelController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  String? activityLevel = "Slight active / not very active";

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
              Column(
                children: [
                  RadioListTile(
                    title: const Text("Slight active / not very active"),
                    value: "Slight active / not very active",
                    groupValue: activityLevel,
                    onChanged: (value) {
                      setState(() {
                        activityLevel = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text("Active / very active"),
                    value: "Active / very active",
                    groupValue: activityLevel,
                    onChanged: (value) {
                      setState(() {
                        activityLevel = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text("very active / hard exercise"),
                    value: "very active / hard exercise",
                    groupValue: activityLevel,
                    onChanged: (value) {
                      setState(() {
                        activityLevel = value.toString();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isEmpty ||
                      ageController.text.isEmpty ||
                      weightController.text.isEmpty ||
                      heightController.text.isEmpty ||
                      activityLevel == null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Error"),
                          content: const Text("Please fill in all fields"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );

                    return;
                  }

                  var nav = Navigator.of(context);
                  String name = nameController.text;
                  int age = int.tryParse(ageController.text) ?? 0;
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('name', name);
                  prefs.setInt('age', age);
                  prefs.setDouble(
                      'weight', double.tryParse(weightController.text) ?? 0);
                  prefs.setDouble(
                      'height', double.tryParse(heightController.text) ?? 0);
                  prefs.setBool('intro', true);
                  if (activityLevel == "Slight active / not very active") {
                    prefs.setInt('activityLevel', 1);
                  } else if (activityLevel == "Active / very active") {
                    prefs.setInt('activityLevel', 2);
                  } else if (activityLevel == "very active / hard exercise") {
                    prefs.setInt('activityLevel', 3);
                  }
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
