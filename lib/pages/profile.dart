import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:health/health.dart';

import 'package:permission_handler/permission_handler.dart';


class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

String weight = '0';

bool requested = false;

bool showList1 = true;

class _ProfileState extends State<Profile> {
  int? steps;

  final List<String> workouts = [
    'Workout 1',
    'Workout 2',
    'Workout 3',
    'Workout 4',
    'Workout 5',
    'Workout 6',
    'Workout 7',
    'Workout 8',
    'Workout 9',
    'Workout 10',
    'Workout 11',
    'Workout 12',
    'Workout 13',
    'Workout 14',
    'Workout 15',
    'Workout 16',
    'Workout 17',
    'Workout 18',
    'Workout 19',
    'Workout 20'
  ];


  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    //Check if we are running in debug mode
    await authorize();
    await fetchStepData();
  }

  static final types = [
    HealthDataType.WEIGHT,
    HealthDataType.STEPS,
    HealthDataType.HEIGHT,
    HealthDataType.BLOOD_GLUCOSE,
    HealthDataType.WORKOUT,
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,

  ];

  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

  final permissions = types.map((e) => HealthDataAccess.READ_WRITE).toList();

  Future authorize() async {
    // If we are trying to read Step Count, Workout, Sleep or other data that requires
    // the ACTIVITY_RECOGNITION permission, we need to request the permission first.
    // This requires a special request authorization call.
    //
    // The location permission is requested for Workouts using the Distance information.
    await Permission.activityRecognition.request();
    await Permission.location.request();

    // Check if we have permission
    bool? hasPermissions =
    await health.hasPermissions(types, permissions: permissions);

    // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
    // Hence, we have to request with WRITE as well.
    hasPermissions = false;

    if (!hasPermissions) {
      // requesting access to the data types before reading them
      requested = await health.requestAuthorization([HealthDataType.WEIGHT,
        HealthDataType.STEPS,
        HealthDataType.HEIGHT,
        HealthDataType.BLOOD_GLUCOSE,
        HealthDataType.WORKOUT,
        HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
        HealthDataType.BLOOD_PRESSURE_SYSTOLIC,]);
      try {requested;} catch (error) {
        print("Exception in authorize: $error");
      }
    }
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

  Future<int> fetchStepDataFromDate(DateTime date) async {
    final midnight = DateTime(date.year, date.month, date.day);

    int? steps;

    if (requested) {
      try {
        steps = await health.getTotalStepsInInterval(midnight, date);
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }
      return steps ?? 0;
    } else {
      return 0;
    }
  }

  Future<void> fetchHealthData() async {
    List<HealthDataPoint> dataPoints = await health.getHealthDataFromTypes(
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
        DateTime.now(),
        types
    );

    int totalCalories = calculateTotalCalories(dataPoints);
    print('Total Calories per Day: $totalCalories');
  }

  int calculateTotalCalories(List<HealthDataPoint> healthDataList) {
    int totalCalories = 0;

    for (var healthData in healthDataList) {
      if (healthData.type == HealthDataType.WORKOUT) {
        WorkoutHealthValue? workoutValue = healthData.value as WorkoutHealthValue?;
        int calories = workoutValue?.totalEnergyBurned?.toInt() ?? 0;

        totalCalories += calories;
      }
    }

    return totalCalories;
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



                  const Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Profile",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Litty master',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
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
                                content: const TextField (
                                  decoration: InputDecoration(
                                    hintText: 'Enter your new weight',
                                  ),
                                ),
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

                        child:
                        Text("Weight: $weight kg",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,),

                        ),

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
                    print(showList1);
                    fetchHealthData();
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
                )
            ),
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
          DateTime currentDate =
          DateTime.now().subtract(Duration(days: index));
          return FutureBuilder<int>(
              future: fetchStepDataFromDate(currentDate),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  int stepsTaken = snapshot.data!;
                  return Container(
                    height: 285,
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            DateFormat('EEEE, MMMM d yyyy').format(
                                currentDate),
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
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
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
                                            child: Text(
                                                "Calories burned",
                                                style: TextStyle(
                                                    decoration:
                                                    TextDecoration
                                                        .underline,
                                                    color: Colors
                                                        .grey[600],
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold)),
                                          ),
                                          Positioned(
                                            top: 50,
                                            left: 10,
                                            child: Text(
                                                "Active calories:",
                                                style: TextStyle(
                                                    color: Colors
                                                        .grey[500],
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold)),
                                          ),
                                          Positioned(
                                            top: 80,
                                            left: 10,
                                            child: Text(
                                                "Basal calories:",
                                                style: TextStyle(
                                                    color: Colors
                                                        .grey[500],
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold)),
                                          ),
                                          Positioned(
                                            top: 110,
                                            left: 10,
                                            child: Text(
                                                "Total calories:",
                                                style: TextStyle(
                                                    color: Colors
                                                        .grey[500],
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold)),
                                          ),
                                          Positioned(
                                            top: 50,
                                            left: 140,
                                            child: Text("496",
                                                style: TextStyle(
                                                    color: Colors
                                                        .grey[500],
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold)),
                                          ),
                                          Positioned(
                                            top: 80,
                                            left: 140,
                                            child: Text("2395",
                                                style: TextStyle(
                                                    color: Colors
                                                        .grey[500],
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold)),
                                          ),
                                          Positioned(
                                            top: 110,
                                            left: 140,
                                            child: Text("2800",
                                                style: TextStyle(
                                                    color: Colors
                                                        .grey[500],
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold)),
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
                                            child: Text(
                                                "Calories consumed ",
                                                style: TextStyle(
                                                    decoration:
                                                    TextDecoration
                                                        .underline,
                                                    color: Colors
                                                        .grey[600],
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold)),
                                          ),
                                          Positioned(
                                            top: 50,
                                            left: 10,
                                            child: Text(
                                                "Protein goal:",
                                                style: TextStyle(
                                                    color: Colors
                                                        .grey[500],
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold)),
                                          ),
                                          Positioned(
                                            top: 80,
                                            left: 10,
                                            child: Text(
                                                "Total Protein:",
                                                style: TextStyle(
                                                    color: Colors
                                                        .grey[500],
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold)),
                                          ),
                                          Positioned(
                                            top: 110,
                                            left: 10,
                                            child: Text(
                                                "Total calories:",
                                                style: TextStyle(
                                                    color: Colors
                                                        .grey[500],
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold)),
                                          ),
                                          Positioned(
                                            top: 50,
                                            left: 140,
                                            child: Text("200",
                                                style: TextStyle(
                                                    color: Colors
                                                        .grey[500],
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold)),
                                          ),
                                          Positioned(
                                            top: 80,
                                            left: 140,
                                            child: Text("186",
                                                style: TextStyle(
                                                    color: Colors
                                                        .grey[500],
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold)),
                                          ),
                                          Positioned(
                                            top: 110,
                                            left: 140,
                                            child: Text("2650",
                                                style: TextStyle(
                                                    color: Colors
                                                        .grey[500],
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold)),
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
                                  fontWeight: FontWeight.bold
                              ),
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
                                  fontWeight: FontWeight.bold
                              ),
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
          DateTime currentDate =
          DateTime.now().subtract(Duration(days: index));
          return FutureBuilder<int>(
              future: fetchStepDataFromDate(currentDate),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    height: 285,
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(8),
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
                            DateFormat('EEEE, MMMM d yyyy ').format(
                                currentDate),
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