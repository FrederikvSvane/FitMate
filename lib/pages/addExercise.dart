import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/classes/Exercise.dart';
import 'package:flutter_fitness_app/classes/Exercise.dart';
import 'package:flutter_fitness_app/pages/SearchExercises.dart';

class AddExercise extends StatefulWidget {
  const AddExercise({super.key});

  @override
  State<AddExercise> createState() => _AddExerciseState();

}

class _AddExerciseState extends State<AddExercise> {
  //This is very smart ok
  //Vi laver objekter til weight exercise og cardio exercise
  //Og så gemmer vi dem i en liste
  Exercise? selectedExercise;

  List<Exercise> Exercises = [
    Exercise(name: "Squat", sets: [], reps: [], weight: []),
    //Objekterne jeg sætter ind her er bare til at teste med :DD
    Exercise(name: "Bench Press", sets: [], reps: [], weight: []),
    Exercise(name: "Deadlift", sets: [], reps: [], weight: []),
    Exercise(name: "Overhead Press", sets: [], reps: [], weight: []),
    Exercise(name: "Barbell Row", sets: [], reps: [], weight: []),
    Exercise(name: "Pull Ups", sets: [], reps: [], weight: []),
    Exercise(name: "Push Ups", sets: [], reps: [], weight: []),
    Exercise(name: "Dips", sets: [], reps: [], weight: []),
    Exercise(name: "Lateral Raises", sets: [], reps: [], weight: []),
    Exercise(name: "Bicep Curls", sets: [], reps: [], weight: []),
    Exercise(name: "Tricep Extensions", sets: [], reps: [], weight: []),
    Exercise(name: "Leg Press", sets: [], reps: [], weight: []),
    Exercise(name: "Leg Curls", sets: [], reps: [], weight: []),
    Exercise(name: "Leg Extensions", sets: [], reps: [], weight: []),
    Exercise(name: "Calf Raises", sets: [], reps: [], weight: []),
    Exercise(name: "Crunches", sets: [], reps: [], weight: []),
    Exercise(name: "Planks", sets: [], reps: [], weight: []),
    Exercise(name: "Russian Twists", sets: [], reps: [], weight: []),
    Exercise(name: "Leg Raises", sets: [], reps: [], weight: []),
    Exercise(name: "Back Extensions", sets: [], reps: [], weight: []),
    Exercise(name: "Chest Flyes", sets: [], reps: [], weight: []),
    Exercise(name: "Chest Press", sets: [], reps: [], weight: []),
    Exercise(name: "Lat Pulldown", sets: [], reps: [], weight: []),
    Exercise(name: "Seated Row", sets: [], reps: [], weight: []),
    Exercise(name: "Shoulder Press", sets: [], reps: [], weight: []),
    Exercise(name: "Shoulder Flyes", sets: [], reps: [], weight: []),
    Exercise(name: "Running", distance: [], time: []),
    Exercise(name: "Cycling", distance: [], time: []),
    Exercise(name: "Swimming", distance: [], time: []),
    Exercise(name: "Rowing", distance: [], time: []),
    Exercise(name: "Walking", distance: [], time: []),
    Exercise(name: "Stair Climbing", distance: [], time: []),
    Exercise(name: "Elliptical", distance: [], time: []),
    Exercise(name: "Jumping Rope", time: []),
    Exercise(name: "Boxing", time: []),
    Exercise(name: "Hiking", distance: [], time: []),
    Exercise(name: "Skiing", distance: [], time: []),
    Exercise(name: "Skating", distance: [], time: []),
    Exercise(name: "Dancing", time: []),
    Exercise(name: "Basketball", time: []),
    Exercise(name: "Football", time: []),
    Exercise(name: "Tennis", time: []),
    Exercise(name: "Volleyball", time: []),
    Exercise(name: "Soccer", time: []),
    Exercise(name: "Baseball", time: []),
    Exercise(name: "Softball", time: []),
    Exercise(name: "Golf", time: []),
    Exercise(name: "Frisbee", time: []),
    Exercise(name: "Ultimate Frisbee", time: []),
    Exercise(name: "Lacrosse", time: []),
    Exercise(name: "Rugby", time: []),
    Exercise(name: "Hockey", time: []),
    Exercise(name: "MMA", time: []),
    Exercise(name: "Burpees", time: [], reps: []),
    Exercise(name: "Jumping Jacks", time: [], reps: []),
    Exercise(name: "Mountain Climbers", time: [], reps: []),
    Exercise(name: "Squat Jumps", time: [], reps: []),
    Exercise(name: "High Knees", time: [], reps: []),
  ];

  sortExercises() { //Sorterer øvelserne alfabetisk
    for (int i = 0; i < Exercises.length; i++) {
      for (int j = i + 1; j < Exercises.length; j++) {
        if (Exercises[i].name.toLowerCase().compareTo(
            Exercises[j].name.toLowerCase()) > 0) {
          Exercise temp = Exercises[i];
          Exercises[i] = Exercises[j];
          Exercises[j] = temp;
        }
      }
    }
  }

  void _showExerciseSearch(BuildContext context) async {
    final result = await showSearch(
      context: context,
      delegate: SearchExercises(Exercises),
    );

    if (result != null) {
      //Den valgte øvelse bliver returneret tilbage til active workout
      setState(() {
        Navigator.pop(context, result);
      });
    }
    //Så skal vi også have noget total weight lifted, time spent working out, calories burned yada yada yada

    int totalWeightLifted = 0;
    int totalTimeSpent = 0;
    int totalCaloriesBurned = 0;
    int totalDistance = 0;
    int amountOfNewRecords = 0;
  }

    @override
    Widget build(BuildContext context) {
      sortExercises();
      return Scaffold(
        appBar: AppBar(
          title: Text('Active Workout'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () => _showExerciseSearch(context),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: Exercises.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 3.0, horizontal: 4.0),
              child: Card(
                child: ListTile(
                  onTap: () {
                    setState(() {
                      Navigator.pop(context,
                          Exercises[index]);
                    });
                  },
                  title: Text(Exercises[index].name),
                ),
              ),
            );
          },
        ),
      );
    }
  }
