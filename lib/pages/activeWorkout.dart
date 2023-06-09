import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/classes/weightExercise.dart';
import 'package:flutter_fitness_app/classes/cardioExercise.dart';

class ActiveWorkout extends StatefulWidget {
  const ActiveWorkout({super.key});

  @override
  State<ActiveWorkout> createState() => _ActiveWorkoutState();
}

class _ActiveWorkoutState extends State<ActiveWorkout> {

  //This is very smart ok
  //Vi laver objekter til weight exercise og cardio exercise
  //Og så gemmer vi dem i en liste

  List<WeightExercise> activeWeightExercises = [

  ];

  List<CardioExercise> activeCardioExercises = [

  ];

  //Så skal vi også have noget total weight lifted, time spent working out, calories burned yada yada yada

  // int totalWeightLifted = 0;
  // int totalTimeSpent = 0;
  // int totalCaloriesBurned = 0;
  // int totalDistance = 0;
  // int amountOfNewRecords = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Workout'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children:[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0,1,50,3),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      activeWeightExercises.clear();
                      activeCardioExercises.clear();
                      Navigator.pop(context);
                    });
                  },
                  icon: Icon(Icons.cancel_outlined), label: Text("Cancel Workout"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40,1,10,3),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/addExercise');
                  },
                  icon: Icon(Icons.add), label: Text("Add Exercise"),
                ),


              ),
            ],

          ),
        ],
      ),
    );
  }
}
