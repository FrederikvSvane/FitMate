import 'package:flutter/material.dart';
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
    Exercise(name: "Running", sets: [], distance: [], time: []),
    Exercise(name: "Cycling", sets: [], distance: [], time: []),
    Exercise(name: "Swimming", sets: [], distance: [], time: []),
    Exercise(name: "Rowing", sets: [], distance: [], time: []),
    Exercise(name: "Walking", sets: [], distance: [], time: []),
    Exercise(name: "Stair Climbing", sets: [], distance: [], time: []),
    Exercise(name: "Elliptical", sets: [], distance: [], time: []),
    Exercise(name: "Jumping Rope", sets: [], time: []),
    Exercise(name: "Boxing", sets: [], time: []),
    Exercise(name: "Hiking", sets: [], distance: [], time: []),
    Exercise(name: "Skiing", sets: [], distance: [], time: []),
    Exercise(name: "Skating", sets: [], distance: [], time: []),
    Exercise(name: "Dancing", sets: [], time: []),
    Exercise(name: "Basketball", sets: [], time: []),
    Exercise(name: "Football", sets: [], time: []),
    Exercise(name: "Tennis", sets: [], time: []),
    Exercise(name: "Volleyball", sets: [], time: []),
    Exercise(name: "Soccer", sets: [], time: []),
    Exercise(name: "Baseball", sets: [], time: []),
    Exercise(name: "Softball", sets: [], time: []),
    Exercise(name: "Golf", sets: [], time: []),
    Exercise(name: "Frisbee", sets: [], time: []),
    Exercise(name: "Ultimate Frisbee", sets: [], time: []),
    Exercise(name: "Lacrosse", sets: [], time: []),
    Exercise(name: "Rugby", sets: [], time: []),
    Exercise(name: "Hockey", sets: [], time: []),
    Exercise(name: "MMA", sets: [], time: []),
    Exercise(name: "Burpees", sets: [], reps: []),
    Exercise(name: "Jumping Jacks", sets: [], reps: []),
    Exercise(name: "Mountain Climbers", sets: [], reps: []),
    Exercise(name: "Squat Jumps", sets: [], reps: []),
    Exercise(name: "High Knees", sets: [], reps: []),
  ];

  sortExercises() {
    //Sorterer øvelserne alfabetisk
    for (int i = 0; i < Exercises.length; i++) {
      for (int j = i + 1; j < Exercises.length; j++) {
        if (Exercises[i]
                .name
                .toLowerCase()
                .compareTo(Exercises[j].name.toLowerCase()) >
            0) {
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
      Exercise newExercise = await checkDatabase( result);
      //Den valgte øvelse bliver returneret tilbage til active workout
      setState((){
        Navigator.pop(context, newExercise);
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
            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 4.0),
            child: Card(
              child: ListTile(
                onTap: () async {
                  Exercise newExercise = await checkDatabase(Exercises[index]);
                  setState(() {
                    Navigator.pop(context, newExercise);
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
  Future<Exercise> checkDatabase(Exercise exercise) async{
    List<Exercise> savedExercise = [];
    savedExercise = await fetchExercises();
    print("hey you sister!!!!!!!!!!!!!!!!!!!!ASD $exercise");

    for(int i = 0; i < savedExercise.length; i++){
      if(savedExercise[i].name == exercise.name){
        print('${savedExercise[0].sets}');
        exercise = savedExercise[i];
      }
    }
    return exercise;
  }
}
