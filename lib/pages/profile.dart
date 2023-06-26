import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/DB/DBHelper.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_switch/sliding_switch.dart';

import '../widgets/profile_listbuilders.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

double weight = 0;

double height = 0;

TextEditingController _textEditingController = TextEditingController();
String textValue = _textEditingController.text;



bool showList1 = true;

String name = ' ';

int age = 0;

num protiensGoal = 0;
num caloriesGoal = 0;

bool gender = false;

class ProfileState extends State<Profile> {
  int? steps;
  static bool requested = false;

  @override
  void initState() {
    super.initState();
    initializeData();
    showList1 = true;
  }

  Future<void> initializeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool introSeen = (prefs.getBool('intro') ?? false);

    if (introSeen) {
      await authorize();
      await fetchStepData();
    }

    fetchData();
    displayMostRecentWeight();
  }

  static final types = [
    HealthDataType.STEPS,
  ];

  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

  final permissions = types.map((e) => HealthDataAccess.READ_WRITE).toList();

  double goalCalories = 0;
  double goalProteins = 0;
  double totalCalories = 0;
  double totalProteins = 0;

  Future authorize() async {
    await Permission.activityRecognition.request();

    bool? hasPermissions = await health.hasPermissions(types, permissions: permissions);

    hasPermissions = false;

    if (!hasPermissions) {
      requested = await health.requestAuthorization([
        HealthDataType.STEPS,
      ]);
      try {
        requested;
      } catch (e) {}
    }
  }

  void displayMostRecentWeight() async {
    Map<String, dynamic> result = await DBHelper.getMostRecentWeight(DateTime.now());

    double weight = result['weight'];

    setState(() {
      _textEditingController.text = weight.toStringAsFixed(2);
    });
  }


  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = (prefs.getString('name') ?? " ");
    age = (prefs.getInt('age') ?? 0);
    weight = (prefs.getDouble('weight') ?? 0);
    height = (prefs.getDouble('height') ?? 0);
    caloriesGoal = (prefs.getDouble('goalCalories') ?? 0);
    protiensGoal = (prefs.getDouble('goalProteins') ?? 0);
    gender = (prefs.getBool("gender"))!;

    DateTime now = DateTime.now();
    DateTime dateOnly = DateTime(now.year, now.month, now.day);

    String formattedDate = DateFormat('yyyy-MM-dd').format(dateOnly);

    DBHelper.insertWeight(weight, formattedDate);

    var dbData = await DBHelper.getProteinsForDateRange(DateTime.now(), dateOnly);
    totalProteins = (dbData[0]['totalProteins']);
    dbData = await DBHelper.getCaloriesForDateRange(DateTime.now(), dateOnly);
    totalCalories = (dbData[0]['totalCalories']);

    setState(() {
      name = name;
      age = age;
      weight = weight;
      height = height;
      caloriesGoal = caloriesGoal;
      protiensGoal = protiensGoal;
    });
  }

  Future fetchStepData() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    if (requested) {
      steps = await health.getTotalStepsInInterval(midnight, now);


      setState(() {
        steps = (steps == null) ? 0 : steps;
      });
    } else {
      return 0;
    }
  }


  void addWeightToDB() {
    String weightText = _textEditingController.text;
    double? weightNumber = double.tryParse(weightText);

    if (weightNumber != null) {
      DateTime now = DateTime.now();
      DateTime dateOnly = DateTime(now.year, now.month, now.day);

      String formattedDate = DateFormat('yyyy-MM-dd').format(dateOnly);

      DBHelper.insertWeight(weightNumber, formattedDate);
      _textEditingController.clear();
    }
  }

  static double basalCalorieBurner() {
    int factor = 0;
    if (gender) {
      factor = 197;
    }
    double dailyCal = (10 * weight + 6.25 * height - 5 * age) + factor;

    return dailyCal;
  }

  static double stepCalorieBurner(int steps) {
    double factor = 0.0000031578947;

    double stepCal = height * weight * factor * steps;

    return stepCal;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter demo',
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Column(
          children: [
            Container(
              height: 200,
              color: Colors.red[800],
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        name,
                        style: const TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[900],
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              alignment: Alignment.center,
                              title: const Text('Update your weight'),
                              content: SizedBox(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  controller: _textEditingController,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter your new weight',
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      var navigator = Navigator.of(context);
                                      addWeightToDB();
                                      Map<String, dynamic> result = await DBHelper.getMostRecentWeight(DateTime.now());
                                      double weightDouble = result['weight'];
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setDouble('weight', weightDouble);

                                      setState(() {
                                        weight = weightDouble;
                                      });

                                      navigator.pop();
                                    },
                                    child: const Text('Update weight')),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('return'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        "Weight: $weight kg",
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Steps today: ${steps ?? 0}",
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SlidingSwitch(
                onDoubleTap: () {},
                onSwipe: () {},
                onTap: () {},
                value: false,
                height: 40,
                textOff: "Workouts",
                textOn: "Daily stats",
                onChanged: (bool value) {
                  setState(() {
                    showList1 = !showList1;
                  });
                },
                colorOn: Colors.red,
                colorOff: Colors.red,
                background: Colors.white,
                buttonColor: Colors.white70,
                inactiveColor: Colors.grey,
                contentSize: 20,
              ),
            ),
            Expanded(
                child: Visibility(
              visible: showList1,
              replacement: const ListBuilder1(),
              child: const ListBuilder2(),
            )),
          ],
        ),
      ),
    );
  }


}

class StepAndCalorieData {
  final int steps;
  final double basalCalories;
  final double stepCalories;
  final double totalCalories;

  StepAndCalorieData({
    required this.steps,
    required this.basalCalories,
    required this.stepCalories,
    required this.totalCalories,
  });
}
