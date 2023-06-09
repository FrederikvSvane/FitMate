import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/classes/weightExercise.dart';
import 'package:flutter_fitness_app/classes/cardioExercise.dart';

class AddExercise extends StatefulWidget {
  const AddExercise({super.key});

  @override
  State<AddExercise> createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {

  //This is very smart ok
  //Vi laver objekter til weight exercise og cardio exercise
  //Og så gemmer vi dem i en liste

  List<WeightExercise> weightExercises = [
    WeightExercise(name: "Squat", sets: 3, reps: 10, weight: 60), //Objekterne jeg sætter ind her er bare til at teste med :DD
    WeightExercise(name: "Bench Press", sets: 3, reps: 10, weight: 60),
    WeightExercise(name: "Deadlift", sets: 3, reps: 10, weight: 60),
    WeightExercise(name: "Overhead Press", sets: 3, reps: 10, weight: 60),
    WeightExercise(name: "Barbell Row", sets: 3, reps: 10, weight: 60),
  ];
  List<CardioExercise> cardioExercises = [
    CardioExercise(name: "Running", time: 30, distance: 5, speed: 10),
    CardioExercise(name: "Cycling", time: 30, distance: 5, speed: 10),
    CardioExercise(name: "Rowing", time: 30, distance: 5, speed: 10),
    CardioExercise(name: "Swimming", time: 30, distance: 5, speed: 10),
    CardioExercise(name: "Walking", time: 30, distance: 5, speed: 10),
  ];

  //Så skal vi også have noget total weight lifted, time spent working out, calories burned yada yada yada

  int totalWeightLifted = 0;
  int totalTimeSpent = 0;
  int totalCaloriesBurned = 0;
  int totalDistance = 0;
  int amountOfNewRecords = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Workout'),
      ),
      body: ListView.builder(
        itemCount: weightExercises.length + cardioExercises.length,
        itemBuilder: (context, index) {
          if (index < weightExercises.length) {

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 4.0),
              child: Card(
                child: ListTile(
                  onTap: () {
                    setState(() {

                    });
                  },
                  title: Text(weightExercises[index].name),
                ),
              ),
            );
          } else {

            int cardioIndex = index - weightExercises.length;
            //Det kan godt være at der kommer problemer med det her,
            // når vi skal kunne tilføje øvelser manuelt inde i appen....
            // Vi må se

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 4.0),
              child: Card(
                child: ListTile(
                  onTap: () {
                    // Noget logik for at trykke på cardio øvelse
                  },
                  title: Text(cardioExercises[cardioIndex].name),
                ),
              ),
            );
          }
        },
      ),

    );
  }
}
