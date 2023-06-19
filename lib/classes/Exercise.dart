import 'dart:ffi';

import 'package:flutter/material.dart';

import '../DB/DBHelper.dart';

//This class should create an exercise object, containing the name of the exercise, the number of sets, reps and weight

class Exercise {
  String name;
  List<int>? sets;
  List<num>? reps;
  List<num>? weight;
  List<num>? time;
  List<num>? distance;
  String? date;

  Exercise(
      {required this.name,
      this.sets,
      this.reps,
      this.weight,
      this.time,
      this.distance,
      this.date});

  @override
  String toString() {
    return 'Exercise{name: $name, sets: $sets, reps: $reps, weight: $weight, date: $date}';
  }
}



Future<List<Exercise>> fetchExercises() async {
  List<Map<String, dynamic>> exerciseMaps = await DBHelper.getExercises();
  List<Exercise> exercises = [];
  for (var exerciseMap in exerciseMaps) {
    String exerciseName = exerciseMap['name'];
    String repsString = exerciseMap['reps'];
    String weightString = exerciseMap['weight'];
    String setsString = exerciseMap['sets'];
    String timeString = exerciseMap['time'];
    String distanceString = exerciseMap['distance'];


    List<int> sets = setsString.split(',').where((s) => s.isNotEmpty).map(int.parse).toList();
    List<int> reps = repsString.split(',').where((s) => s.isNotEmpty).map(int.parse).toList();
    List<int> weights = weightString.split(',').where((s) => s.isNotEmpty).map(int.parse).toList();
    List<int> timeList = timeString.split(',').where((s) => s.isNotEmpty).map(int.parse).toList();
    List<int> distanceList = distanceString.split(',').where((s) => s.isNotEmpty).map(int.parse).toList();

    Exercise exercise = Exercise(
      name: '',
    );

    if ( weights.isNotEmpty){
      exercise = Exercise(
        name: exerciseName,
        sets: sets,
        reps: reps,
        weight: weights,
      );
    } else if (distanceList.isNotEmpty){
      exercise = Exercise(
        name: exerciseName,
        sets: sets,
        time: timeList,
        distance: distanceList,
      );
    } else if (timeList.isNotEmpty){
      exercise = Exercise(
        name: exerciseName,
        sets: sets,
        time: timeList,
      );
    } else {
      exercise = Exercise(
        name: exerciseName,
        sets: sets,
        reps: reps,
      );
    }




    exercises.add(exercise);
  }
  return exercises;
}




