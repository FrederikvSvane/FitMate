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
    WeightExercise(name: "Squat", sets: [], reps: [], weight: []),
    //Objekterne jeg sætter ind her er bare til at teste med :DD
    WeightExercise(name: "Bench Press", sets: [], reps: [], weight: []),
    WeightExercise(name: "Deadlift", sets: [], reps: [], weight: []),
    WeightExercise(name: "Overhead Press", sets: [], reps: [], weight: []),
    WeightExercise(name: "Barbell Row", sets: [], reps: [], weight: []),
    WeightExercise(name: "Pull Ups", sets: [], reps: [], weight: []),
    WeightExercise(name: "Push Ups", sets: [], reps: [], weight: []),
    WeightExercise(name: "Dips", sets: [], reps: [], weight: []),
    WeightExercise(name: "Lateral Raises", sets: [], reps: [], weight: []),
    WeightExercise(name: "Bicep Curls", sets: [], reps: [], weight: []),
    WeightExercise(name: "Tricep Extensions", sets: [], reps: [], weight: []),
    WeightExercise(name: "Leg Press", sets: [], reps: [], weight: []),
    WeightExercise(name: "Leg Curls", sets: [], reps: [], weight: []),
    WeightExercise(name: "Leg Extensions", sets: [], reps: [], weight: []),
    WeightExercise(name: "Calf Raises", sets: [], reps: [], weight: []),
    WeightExercise(name: "Crunches", sets: [], reps: [], weight: []),
    WeightExercise(name: "Planks", sets: [], reps: [], weight: []),
    WeightExercise(name: "Russian Twists", sets: [], reps: [], weight: []),
    WeightExercise(name: "Leg Raises", sets: [], reps: [], weight: []),
    WeightExercise(name: "Back Extensions", sets: [], reps: [], weight: []),
    WeightExercise(name: "Chest Flyes", sets: [], reps: [], weight: []),
    WeightExercise(name: "Chest Press", sets: [], reps: [], weight: []),
    WeightExercise(name: "Lat Pulldown", sets: [], reps: [], weight: []),
    WeightExercise(name: "Seated Row", sets: [], reps: [], weight: []),
    WeightExercise(name: "Shoulder Press", sets: [], reps: [], weight: []),
    WeightExercise(name: "Shoulder Flyes", sets: [], reps: [], weight: []),
  ];
  List<CardioExercise> cardioExercises = [
    CardioExercise(name: "Running", distance: [], time: []),
    CardioExercise(name: "Cycling", distance: [], time: []),
    CardioExercise(name: "Swimming", distance: [], time: []),
    CardioExercise(name: "Rowing", distance: [], time: []),
    CardioExercise(name: "Walking", distance: [], time: []),
    CardioExercise(name: "Stair Climbing", distance: [], time: []),
    CardioExercise(name: "Elliptical", distance: [], time: []),
    CardioExercise(name: "Jumping Rope", time: []),
    CardioExercise(name: "Boxing", time: []),
    CardioExercise(name: "Hiking", distance: [], time: []),
    CardioExercise(name: "Skiing", distance: [], time: []),
    CardioExercise(name: "Skating", distance: [], time: []),
    CardioExercise(name: "Dancing", time: []),
    CardioExercise(name: "Basketball", time: []),
    CardioExercise(name: "Football", time: []),
    CardioExercise(name: "Tennis", time: []),
    CardioExercise(name: "Volleyball", time: []),
    CardioExercise(name: "Soccer", time: []),
    CardioExercise(name: "Baseball", time: []),
    CardioExercise(name: "Softball", time: []),
    CardioExercise(name: "Golf", time: []),
    CardioExercise(name: "Frisbee", time: []),
    CardioExercise(name: "Ultimate Frisbee", time: []),
    CardioExercise(name: "Lacrosse", time: []),
    CardioExercise(name: "Rugby", time: []),
    CardioExercise(name: "Hockey", time: []),
    CardioExercise(name: "MMA", time: []),
    CardioExercise(name: "Burpees", time: [], reps: []),
    CardioExercise(name: "Jumping Jacks", time: [], reps: []),
    CardioExercise(name: "Mountain Climbers", time: [], reps: []),
    CardioExercise(name: "Squat Jumps", time: [], reps: []),
    CardioExercise(name: "High Knees", time: [], reps: []),
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
              padding:
                  const EdgeInsets.symmetric(vertical: 3.0, horizontal: 4.0),
              child: Card(
                child: ListTile(
                  onTap: () {
                    setState(() {});
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
              padding:
                  const EdgeInsets.symmetric(vertical: 3.0, horizontal: 4.0),
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
