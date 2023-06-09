import 'dart:ffi';

import 'package:flutter/material.dart';

//This class should create an exercise object, containing the name of the exercise, the number of sets, reps and weight

class WeightExercise {
  String name;
  List <int> sets;
  List <num> reps;
  List<num> weight;

  WeightExercise({required this.name, required this.sets, required this.reps, required this.weight});
}