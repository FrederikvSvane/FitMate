import 'dart:core';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  IntroScreenState createState() => IntroScreenState();
}

List<String> list = <String>['Male', 'Female'];

class IntroScreenState extends State<IntroScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController activityLevelController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  String? activityLevel = "Slight active / not very active";

  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Align(
          alignment: Alignment.center,
          child: Text('Welcome',
              style: TextStyle(
                  color: Colors.red[800],
                  fontSize: 30,
                  fontWeight: FontWeight.w500))),
      const SizedBox(
        height: 10,
      ),
      Align(
          alignment: Alignment.center,
          child: Text('Thank you for downloading FitMate',
              style: TextStyle(
                  color: Colors.red[800],
                  fontSize: 20,
                  fontWeight: FontWeight.w400))),
      const SizedBox(
        height: 10,
      ),
      const Align(
          alignment: Alignment.center,
          child: Text('Please start by filling out this personal information',
              style: TextStyle(
                fontSize: 15,
              ))),
      Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
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
            ],
          )),
      DropdownButton<String>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String? value) {
          setState(() {
            dropdownValue = value!;
          });
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
      Column(
        children: [
          Align(
              alignment: Alignment.center,
              child: Text('Please choose your current activity level below',
                  style: TextStyle(
                      color: Colors.red[800],
                      fontSize: 15,
                      fontWeight: FontWeight.w400))),
          RadioListTile(
            title: const Text("Inactive / rarely exercise"),
            value: "Inactive / rarely exercise",
            groupValue: activityLevel,
            onChanged: (value) {
              setState(() {
                activityLevel = value.toString();
              });
            },
          ),
          RadioListTile(
            title: const Text("Active / regularly exercise"),
            value: "Active / regularly exercise",
            groupValue: activityLevel,
            onChanged: (value) {
              setState(() {
                activityLevel = value.toString();
              });
            },
          ),
          RadioListTile(
            title: const Text("Very active / frequently exercise"),
            value: "Very active / frequently exercise",
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
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('name', name);
            prefs.setInt('age', age);
            prefs.setDouble(
                'weight', double.tryParse(weightController.text) ?? 0);
            prefs.setDouble(
                'height', double.tryParse(heightController.text) ?? 0);
            prefs.setBool('intro', true);
            if (activityLevel == "Inactive / rarely exercise") {
              prefs.setInt('activityLevel', 1);
            } else if (activityLevel == "Active / regularly exercise") {
              prefs.setInt('activityLevel', 2);
            } else if (activityLevel == "Very active / frequently exercise") {
              prefs.setInt('activityLevel', 3);
            }
            if(dropdownValue == 1){
              prefs.setBool("gender", true);
            }else{
              prefs.setBool("gender", false);
            }

            nav.pushReplacementNamed("/");
          },
          child: const Text('Confirm'))
    ])));
  }
}
