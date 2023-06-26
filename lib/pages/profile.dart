import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/DB/DBHelper.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_switch/sliding_switch.dart';

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

bool gender = false;

class ProfileState extends State<Profile> {
  int? steps;

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

  String getTheDaysProtiensStats(String totalProtein) {
    if (double.tryParse(totalProtein)! > goalCalories) {
      return 'Day ended with a surplus of ${(double.tryParse(totalProtein)! - protiensGoal).abs()} grams';
    } else {
      return 'Day ended with a protein deficit of ${(protiensGoal - double.tryParse(totalProtein)!).abs()} grams';
    }
  }

  String getTheDaysCaloriesStats(String totalCalories) {
    if (double.tryParse(totalCalories)! > goalCalories) {
      return 'Day ended with a surplus of ${(double.tryParse(totalCalories)! - goalCalories).abs()} calories';
    } else {
      return 'Day ended with a calorie deficit of ${(goalCalories - double.tryParse(totalCalories)!).abs()} calories';
    }
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
      try {
        steps = await health.getTotalStepsInInterval(midnight, now);
      } catch (error) {}

      setState(() {
        steps = (steps == null) ? 0 : steps;
      });
    } else {
      return 0;
    }
  }

  Future<StepAndCalorieData> fetchStepDataFromDate(DateTime date) async {
    DateTime before = DateTime(date.year, date.month, date.day, 0, 0, 0);
    DateTime after = DateTime(date.year, date.month, date.day, 23, 59, 59);

    int? stepsData;

    if (requested) {
      try {
        stepsData = await health.getTotalStepsInInterval(before, after);
      } catch (error) {}

      int steps = stepsData ?? 0;
      double basalCalories = basalCalorieBurner();
      double stepCalories = stepCalorieBurner(steps);

      return StepAndCalorieData(
          steps: steps,
          basalCalories: basalCalories,
          stepCalories: stepCalories,
          totalCalories: basalCalories + stepCalories);
    } else {
      double basalCalories = basalCalorieBurner();
      return StepAndCalorieData(
          steps: 0, basalCalories: basalCalories, stepCalories: 0, totalCalories: basalCalories + 0);
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

  double basalCalorieBurner() {
    int factor = 0;
    if (gender) {
      factor = 197;
    }
    double dailyCal = (10 * weight + 6.25 * height - 5 * age) + factor;

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
                                      addWeightToDB();
                                      Map<String, dynamic> result = await DBHelper.getMostRecentWeight(DateTime.now());
                                      double weightDouble = result['weight'];
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
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
          DateTime before = DateTime(currentDate.year, currentDate.month, currentDate.day, 0, 0, 0);
          DateTime after = DateTime(currentDate.year, currentDate.month, currentDate.day, 23, 59, 59);
          Future<List<Map<String, dynamic>>> dbData = DBHelper.getProteinsForDateRange(before, after);
          Future<List<Map<String, dynamic>>> dbData2 = DBHelper.getCaloriesForDateRange(before, after);
          Future<StepAndCalorieData> stepAndCalorieData = fetchStepDataFromDate(currentDate);

          return FutureBuilder<List<dynamic>>(
            future: Future.wait([dbData, dbData2, stepAndCalorieData]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Map<String, dynamic>> proteinData = snapshot.data?[0];
                List<Map<String, dynamic>> calorieData = snapshot.data?[1];
                StepAndCalorieData data = snapshot.data?[2];

                String totalProtein = proteinData[0]['totalProteins'].toString();
                String totalCalories = calorieData[0]['totalCalories'].toString();

                int stepsTaken = data.steps;
                double activeCalories = data.stepCalories;
                double basalCalories = data.basalCalories;
                double totalCaloriesUsed = data.totalCalories;

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
                                                  decoration: TextDecoration.underline,
                                                  color: Colors.grey[600],
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 50,
                                          left: 10,
                                          child: Text("Active calories: ",
                                              style: TextStyle(
                                                  color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 80,
                                          left: 10,
                                          child: Text("Basal calories:",
                                              style: TextStyle(
                                                  color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 110,
                                          left: 10,
                                          child: Text("Total calories:",
                                              style: TextStyle(
                                                  color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 50,
                                          left: 140,
                                          child: Text(activeCalories.toStringAsFixed(2),
                                              style: TextStyle(
                                                  color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 80,
                                          left: 140,
                                          child: Text(basalCalories.toStringAsFixed(2),
                                              style: TextStyle(
                                                  color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 110,
                                          left: 140,
                                          child: Text(totalCaloriesUsed.toStringAsFixed(2),
                                              style: TextStyle(
                                                  color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
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
                                                  decoration: TextDecoration.underline,
                                                  color: Colors.grey[600],
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 50,
                                          left: 10,
                                          child: Text("Protein goal:",
                                              style: TextStyle(
                                                  color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 80,
                                          left: 10,
                                          child: Text("Total Protein:",
                                              style: TextStyle(
                                                  color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 110,
                                          left: 10,
                                          child: Text("Total calories:",
                                              style: TextStyle(
                                                  color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 50,
                                          left: 140,
                                          child: Text(protiensGoal.toString(),
                                              style: TextStyle(
                                                  color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 80,
                                          left: 140,
                                          child: Text(totalProtein,
                                              style: TextStyle(
                                                  color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
                                        ),
                                        Positioned(
                                          top: 110,
                                          left: 140,
                                          child: Text(totalCalories,
                                              style: TextStyle(
                                                  color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.bold)),
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
                            getTheDaysProtiensStats(totalProtein),
                            style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            getTheDaysCaloriesStats(totalCalories),
                            style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        });
  }

  Widget listBuilder2() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 30,
      itemBuilder: (BuildContext context, index) {
        DateTime currentDate = DateTime.now().subtract(Duration(days: index));

        return FutureBuilder<List<Map<String, dynamic>>>(
          future: DBHelper.getExercisesForDate(currentDate),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final exercises = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: exercises.length,
                itemBuilder: (context, exerciseIndex) {
                  final exercise = exercises[exerciseIndex];
                  return Card(
                    margin: EdgeInsets.all(8),
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(DateFormat('EEEE, MMMM d, yyyy').format(currentDate),
                              style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                          SizedBox(height: 10),
                          Text('${exercise['name']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          SizedBox(height: 10),
                          if (exercise['sets'] != '') ...[
                            Text('Sets: ${exercise['sets']}', style: TextStyle(fontSize: 16)),
                            SizedBox(height: 10),
                          ],
                          if (exercise['reps'] != '') ...[
                            Text('Reps: ${exercise['reps']}', style: TextStyle(fontSize: 16)),
                            SizedBox(height: 10),
                          ],
                          if (exercise['weight'] != '') ...[
                            Text('Weight: ${exercise['weight']}', style: TextStyle(fontSize: 16)),
                            SizedBox(height: 10),
                          ],
                          if (exercise['time'] != '') ...[
                            Text('Time: ${exercise['time']}', style: TextStyle(fontSize: 16)),
                            SizedBox(height: 10),
                          ],
                          if (exercise['distance'] != '') ...[
                            Text('Distance: ${exercise['distance']}', style: TextStyle(fontSize: 16)),
                            SizedBox(height: 10),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
        );
      },
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
