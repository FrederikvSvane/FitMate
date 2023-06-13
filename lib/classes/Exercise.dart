import 'dart:ffi';

import 'package:flutter/material.dart';

//This class should create an exercise object, containing the name of the exercise, the number of sets, reps and weight

class Exercise {
  String name;
  List<int>? sets;
  List<num>? reps;
  List<num>? weight;
  List<num>? time;
  List<num>? distance;

  Exercise(
      {required this.name,
      this.sets,
      this.reps,
      this.weight,
      this.time,
      this.distance});
}
