import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/classes/Exercise.dart';
import 'package:flutter_fitness_app/classes/WorkoutTemplate.dart';

class TemplateCard extends StatefulWidget {
  WorkoutTemplate template;

  TemplateCard({required this.template});

  @override
  _TemplateCardState createState() => _TemplateCardState();
}

class _TemplateCardState extends State<TemplateCard>{
  List<Widget> _setRows = [];

  void _addExerciseRow() {
    setState(() {

      _setRows = _buildWorkoutRows(widget.template);
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.template.workoutExercises != null) {
      _setRows = _buildWorkoutRows(widget.template);
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
              widget.template.workoutName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ..._setRows,
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: _addExerciseRow,
                    icon: Icon(Icons.add),
                    label: Text("Add Exercise"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildWorkoutRows(WorkoutTemplate workout) {
    List<Widget> rows = [];
    for (int i = 0; i < workout.workoutExercises!.length; i++) {
      Exercise exercise = workout.workoutExercises![i];
      rows.add(
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${exercise.sets![i]} X sets:"),
              Text("${exercise.name![i]} "),
            ],
          ),
        ),
      );
    }
    return rows;
  }
}