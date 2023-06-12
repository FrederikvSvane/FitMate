import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/classes/Exercise.dart';

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;

  ExerciseCard({required this.exercise});

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  List<Widget> _setRows = [];

  void _addSetRow() {
    setState(() {
      int nextSetNumber = widget.exercise.sets!.length + 1;
      widget.exercise.sets!.add(nextSetNumber);
      widget.exercise.reps!.add(0); // Example: add default values for the new set
      widget.exercise.weight!.add(0);
      _setRows = _buildStrengthExerciseRows(widget.exercise);
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.exercise.sets != null) {
      _setRows = _buildStrengthExerciseRows(widget.exercise);
    }
  }

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
              widget.exercise.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ..._setRows,
            if (widget.exercise.distance != null && widget.exercise.time != null)
              ..._buildCardioExerciseRows(widget.exercise),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: _addSetRow,
                    icon: Icon(Icons.add),
                    label: Text("Add Set"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStrengthExerciseRows(Exercise exercise) {
    List<Widget> rows = [];
    for (int i = 0; i < exercise.sets!.length; i++) {
      rows.add(
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Set ${exercise.sets![i]}:"),
              Text("reps ${exercise.reps![i]} "),
              Text("${exercise.weight![i]} kg"),
            ],
          ),
        ),
      );
    }
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
