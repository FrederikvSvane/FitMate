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
  final exerciseMaps = await DBHelper.getExercises();

  Map<String, List<Map<String, dynamic>>> groupedExercises = {};

  for (var map in exerciseMaps) {
    String key = "${map['name']}_${map['date']}";
    if (!groupedExercises.containsKey(key)) {
      groupedExercises[key] = [map];
    } else {
      groupedExercises[key]?.add(map);
    }
  }

  List<Exercise> exercises = [];

  for (var key in groupedExercises.keys) {
    List<int> sets = [];
    List<int> reps = [];
    List<double> weight = [];
    String name = '';
    String date = '';

    for (var map in groupedExercises[key]!) {
      name = map['name'];
      date = map['date'];
      sets.add(map['sets']);
      reps.add(map['reps']);
      weight.add(map['weight']);
    }

    exercises.add(Exercise(
      name: name,
      sets: sets,
      reps: reps,
      weight: weight,
      date: date,
    ));
  }

  return exercises;
}

