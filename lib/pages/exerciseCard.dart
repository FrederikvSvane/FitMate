import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../classes/Exercise.dart';

class ExerciseCard extends StatefulWidget {
  final Function(Exercise) exercise;

  ExerciseCard({required this.exercise});

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  TextEditingController nameController = TextEditingController();
  TextEditingController setsController = TextEditingController();
  TextEditingController repsController = TextEditingController();

  void _submitForm(){
    String name = nameController.text.trim();
    int sets = int.parse(setsController.text.trim());
    int reps = int.parse(repsController.text.trim());

    Exercise newExercise = Exercise(name: name, sets: [sets], reps: [reps]);

    widget.exercise(newExercise);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: "Exercise Name",
          ),
        ),
        TextField(
          controller: setsController,
          decoration: InputDecoration(
            labelText: "Number of Sets",
          ),
        ),
        TextField(
          controller: repsController,
          decoration: InputDecoration(
            labelText: "Number of Reps",
          ),
        ),
      ]
    );
  }
}