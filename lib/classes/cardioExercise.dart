import 'package:flutter/material.dart';

class CardioExercise {
  String name;
  List<num> time;
  List<num>? distance;
  List<num>? reps;

  CardioExercise(
      {required this.name, required this.time, this.distance, this.reps});
}
