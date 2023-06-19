import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/DB/DBHelper.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:health/health.dart';

import 'package:permission_handler/permission_handler.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

double weight = 0;

double height = 0;

TextEditingController _textEditingController = TextEditingController();
String textValue = _textEditingController.text;

bool requested = false;

bool showList1 = true;

String name = ' ';

int age = 0;

num protiensGoal = 0;
num caloriesGoal = 0;

class ProfileState extends State<Profile> {
  int? steps;

  @override
  void initState() {
    super.initState();
    initializeData();
    showList1 = true;
  }

  Future<void> initializeData() async {
    //Check if we have completed the intro screen

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool introSeen = (prefs.getBool('intro') ?? false);

    if (introSeen) {
      await authorize();
      await fetchStepData();
    }

    fetchData();
    displayMostRecentWeight();
  }

  void loadGoalCalories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    goalCalories = prefs.getDouble('goalCalories') ?? 0;
  }

  void loadGoalProteins() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    goalProteins = prefs.getDouble('goalProteins') ?? 0;
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
    // If we are trying to read Step Count, Workout, Sleep or other data that requires
    // the ACTIVITY_RECOGNITION permission, we need to request the permission first.
    // This requires a special request authorization call.
    //
    // The location permission is requested for Workouts using the Distance information.
    await Permission.activityRecognition.request();

    // Check if we have permission
    bool? hasPermissions =
        await health.hasPermissions(types, permissions: permissions);

    // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
    // Hence, we have to request with WRITE as well.
    hasPermissions = false;

    if (!hasPermissions) {
      // requesting access to the data types before reading them
      requested = await health.requestAuthorization([
        HealthDataType.STEPS,
      ]);
      try {
        requested;
      } catch (error) {
        print("Exception in authorize: $error");
      }
    }
  }

  void displayMostRecentWeight() async {
    Map<String, dynamic> result =
        await DBHelper.getMostRecentWeight(DateTime.now());

    double weight = result['weight'];
    String date = result['date'];

    print('Most recent weight: $weight on date: $date');
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



    DateTime now = DateTime.now();
    DateTime dateOnly = DateTime(now.year, now.month, now.day);

    // Format dateOnly to a string that only contains the date
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateOnly);

    //Add weight to database
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
      try {
        steps = await health.getTotalStepsInInterval(midnight, now);
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }

      setState(() {
        steps = (steps == null) ? 0 : steps;
      });
    } else {
      return 0;
    }
  }

  Future<StepAndCalorieData> fetchStepDataFromDate(DateTime date) async {
    final midnight = DateTime(date.year, date.month, date.day);

    int? stepsData;

    if (requested) {
      try {
        stepsData = await health.getTotalStepsInInterval(midnight, date);
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }

      int steps = stepsData ?? 0;
      double basalCalories = basalCalorieBurner();
      double stepCalories = stepCalorieBurner(steps);

      return StepAndCalorieData(
          steps: steps,
          basalCalories: basalCalories,
          stepCalories: stepCalories,
          totalCalories: basalCalories + stepCalories);
    }
    else {
      double basalCalories = basalCalorieBurner();
      return StepAndCalorieData(
          steps: 0,
          basalCalories: basalCalories,
          stepCalories: 0,
          totalCalories: basalCalories + 0);
    }
  }



  void addWeightToDB() {
    String weightText = _textEditingController.text;
    double? weightNumber = double.tryParse(weightText);

    if (weightNumber != null) {
      DateTime now = DateTime.now();
      DateTime dateOnly = DateTime(now.year, now.month, now.day);

      // Format dateOnly to a string that only contains the date
      String formattedDate = DateFormat('yyyy-MM-dd').format(dateOnly);

      DBHelper.insertWeight(weightNumber, formattedDate);
      _textEditingController.clear();
      print('gg ez');
    } else {
      print('gg not ez');
    }
  }

  double basalCalorieBurner() {
    double dailyCal = (10 * weight + 6.25 * height - 5 * age);

    return dailyCal;
  }

  double stepCalorieBurner(int steps) {
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
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: GestureDetector(
                        onTap: () async {
                          var result = await Navigator.pushNamed(
                              context, "/profileSettings");

                          if (result != null) {
                            Map<String, dynamic> profileData =
                                result as Map<String, dynamic>;
                            setState(() {
                              //TODO: Update profile data

                              weight = profileData["weight"];
                            });
                          }
                        },
                        child: const Text(
                          'Settings',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                alignment: Alignment.center,
                                title: Text('Update your weight'),
                                content: Column(children: [
                                  TextField(
                                    controller: _textEditingController,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter your new weight',
                                    ),
                                  ),
                                ]),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('close'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
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
                              title: Text('Update your weight'),
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
                                      addWeightToDB();
                                      Map<String, dynamic> result =
                                          await DBHelper.getMostRecentWeight(
                                              DateTime.now());
                                      double weightDouble = result['weight'];
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setDouble('weight', weightDouble);

                                      setState(() {
                                        weight = weightDouble;
                                      });

                                      Navigator.of(context).pop();
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
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Steps today: ${steps ?? 0}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
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
              replacement: listBuilder1(),
              child: listBuilder2(),
            )),
          ],
        ),
      ),
    );
  }

  Widget listBuilder1() {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: 30,
        itemBuilder: (BuildContext context, index) {
          DateTime currentDate = DateTime.now().subtract(Duration(days: index));
          return FutureBuilder<StepAndCalorieData>(
              future: fetchStepDataFromDate(currentDate),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  StepAndCalorieData data = snapshot.data!;
                  int stepsTaken = data.steps;
                  double activeCalories = data.stepCalories;
                  double basalCalories = data.basalCalories;
                  double totalCalories = data.totalCalories;
                  return Container(
                    height: 285,
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            DateFormat('EEEE, MMMM d yyyy').format(currentDate),
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'Steps taken: $stepsTaken',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                height: 150,
                                color: Colors.grey[50],
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Positioned(
                                            top: 10,
                                            child: Text("Calories burned ",
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Colors.grey[600],
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Positioned(
                                            top: 50,
                                            left: 10,
                                            child: Text("Active calories: ",
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Positioned(
                                            top: 80,
                                            left: 10,
                                            child: Text("Basal calories:",
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Positioned(
                                            top: 110,
                                            left: 10,
                                            child: Text("Total calories:",
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Positioned(
                                            top: 50,
                                            left: 140,
                                            child: Text(
                                                activeCalories
                                                    .toStringAsFixed(2),
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Positioned(
                                            top: 80,
                                            left: 140,
                                            child: Text(
                                                basalCalories
                                                    .toStringAsFixed(2),
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Positioned(
                                            top: 110,
                                            left: 140,
                                            child: Text(
                                                totalCalories
                                                    .toStringAsFixed(2),
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: Container(
                                height: 150,
                                color: Colors.grey[50],
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Positioned(
                                            top: 10,
                                            child: Text("Calories consumed ",
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Colors.grey[600],
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Positioned(
                                            top: 50,
                                            left: 10,
                                            child: Text("Protein goal:",
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Positioned(
                                            top: 80,
                                            left: 10,
                                            child: Text("Total Protein:",
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Positioned(
                                            top: 110,
                                            left: 10,
                                            child: Text("Total calories:",
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Positioned(
                                            top: 50,
                                            left: 140,
                                            child: Text(protiensGoal.toString(),
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Positioned(
                                            top: 80,
                                            left: 140,
                                            child: Text("186",
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Positioned(
                                            top: 110,
                                            left: 140,
                                            child: Text("2650",
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Day ended with a protein deficit of 14 grams",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Day ended with a deficit of 150 calories",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                return const CircularProgressIndicator();
              });
        });
  }

  Widget listBuilder2() {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: 30,
        itemBuilder: (BuildContext context, index) {
          DateTime currentDate = DateTime.now().subtract(Duration(days: index));
          return FutureBuilder<StepAndCalorieData>(
              future: fetchStepDataFromDate(currentDate),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    height: 285,
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            'Back desctruction',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            DateFormat('EEEE, MMMM d yyyy ')
                                .format(currentDate),
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('1 h 3 min'),
                            Text('13058 kg'),
                            Text('28 sets'),
                            Text('4 pr\'s')
                          ],
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                return const CircularProgressIndicator();
              });
        });
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
