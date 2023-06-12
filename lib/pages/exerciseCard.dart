import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/classes/Exercise.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;

  ExerciseCard({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (exercise.sets != null && exercise.reps != null && exercise.weight != null)
              ..._buildStrengthExerciseRows(exercise),
            if (exercise.distance != null && exercise.time != null)
              ..._buildCardioExerciseRows(exercise),
            // Add more cases if there are more types of exercises
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStrengthExerciseRows(Exercise exercise) {
    List<Widget> setRow = [];
    List<Widget> addRow = [];
    List<Widget> allRow = [];

    for (int i = 0; i < exercise.sets!.length; i++) {
      setRow.add(
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Set ${exercise.sets![i]}:"),
              Text("reps + ${exercise.reps![i]} "),
              Text("${exercise.weight![i]} kg"),
            ],
          ),
        ),
      );
    }
    addRow.add(
      TextButton.icon(onPressed: (){

      }, icon: Icons.add, label: Text("ja")),
    );

    return rows;
  }

  List<Widget> _buildCardioExerciseRows(Exercise exercise) {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Distance: ${exercise.distance!} km"),
            Text("Time: ${exercise.time!} min"),
          ],
        ),
      ),
    ];
  }
}
