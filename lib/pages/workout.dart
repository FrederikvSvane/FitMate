import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/pages/templateCard.dart';

import '../classes/Exercise.dart';
import '../classes/WorkoutTemplate.dart';

class Workout extends StatefulWidget {
  @override
  _WorkoutState createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  Map<String, dynamic> data = {};
  List<WorkoutTemplate> workoutTemplates = [
    WorkoutTemplate(workoutName: 'test', workoutExercises: [
      Exercise(
          name: "Bench Press",
          sets: [4],
          reps: [0, 0, 0, 0],
          weight: [0, 0, 0, 0]),
      Exercise(
          name: "Deadlift",
          sets: [4],
          reps: [0, 0, 0, 0],
          weight: [0, 0, 0, 0]),
      Exercise(
          name: "Overhead Press", sets: [3], reps: [0, 0, 0], weight: [0, 0, 0])
    ])
  ];

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
                child: const Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "Workouts",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                          'Avg weekly time: 17 hrs',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Text(
                          'Total time spent: 1000 hrs',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Text(
                          'Total workouts: 73',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Avg weekly workouts: 4',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                    ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
              Align(
                alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))
                        ),
                      onPressed: () {

                        dynamic result =
                            Navigator.pushNamed(context, "/activeWorkout");
                        setState(() {
                          // Her skal dataen fra den aktive workout videresendes til næste skærm
                          // Men jeg er hverken sikker på om det er den her skærm, der skal bruge dataen,
                          // eller hvad dataen er endnu.
                          // Vi må se hvad der sker når vi kommer så langt :p

                          // Den kommer i hvert fald til at være noget i retning af:
                          // data = {
                          //   "weightExercises": result["weightExercises"],
                          //   "cardioExercises": result["cardioExercises"],
                        });
                      },
                      child: Text('Start Emtpy Workout',
                        style: TextStyle(
                          color: Colors.red[800],
                          fontWeight: FontWeight.bold
                        ),
                        ),
                    ),
                  )
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))

                      ),
                      onPressed: () {
                        dynamic result =
                        Navigator.pushNamed(context, "/activeWorkout");
                        setState(() {
                          // Her skal dataen fra den aktive workout videresendes til næste skærm
                          // Men jeg er hverken sikker på om det er den her skærm, der skal bruge dataen,
                          // eller hvad dataen er endnu.
                          // Vi må se hvad der sker når vi kommer så langt :p

                          // Den kommer i hvert fald til at være noget i retning af:
                          // data = {
                          //   "weightExercises": result["weightExercises"],
                          //   "cardioExercises": result["cardioExercises"],
                        });
                      },
                      child: Text('Start existing template',
                      style: TextStyle(
                        color: Colors.red[800],
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                  )),
            ],
              ),
              Expanded(
                child: listBuilder2()
              )
                ],
          ),
        ));
  }
  Widget listBuilder2() {
    return ListView.builder(
        itemCount: 30,
        itemBuilder: (BuildContext context, index) {
          DateTime.now().subtract(Duration(days: index));
                  return Container(
                    height: 285,
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
        });
  }
}
