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
    WorkoutTemplate(
        workoutName: 'test',
        workoutExercises: [
          Exercise(name: "Bench Press", sets: [4], reps: [0,0,0,0], weight: [0,0,0,0]),
          Exercise(name: "Deadlift", sets: [4], reps: [0,0,0,0], weight: [0,0,0,0]),
          Exercise(name: "Overhead Press", sets: [3], reps: [0,0,0], weight: [0,0,0])]
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Page'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.red[800],
      ),
      body: Stack(
        children: [
          // List of exercises
          ListView.builder(
            itemCount: workoutTemplates.length,
            itemBuilder: (context, index) {
              return TemplateCard(template: workoutTemplates[index]);
              //title: Text(activeExercises[index].name),
              // add other fields of Exercise class as needed
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  dynamic result = Navigator.pushNamed(context, "/activeWorkout");
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
                child: Text('Start Emtpy Workout'),
              ),
            )
          ),
        ],
      ),
    );
  }
}

