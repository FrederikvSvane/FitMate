import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/classes/Exercise.dart';
import 'package:flutter_fitness_app/classes/activeWorkoutState.dart';
import 'package:provider/provider.dart';

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;
  final int exerciseIndex;

  ExerciseCard(
      {required this.exercise, required this.exerciseIndex});

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  List<Widget> _setRows = [];

  TextEditingController _buildTextEditingController(List<num> data, int index) {
    TextEditingController controller = TextEditingController();
    if (index < data.length && data[index] != 0) {
      controller.text = data[index].toString();
    }
    return controller;
  }

  void _addSetRow() {
    setState(() {
      int nextSetNumber = widget.exercise.sets!.length + 1;
      widget.exercise.sets!.add(nextSetNumber);

      if (widget.exercise.weight != null) {
        widget.exercise.weight!.add(0);
      }
      if (widget.exercise.reps != null) {
        widget.exercise.reps!.add(0);
      }
      if (widget.exercise.distance != null) {
        widget.exercise.distance!.add(0);
      }
      if (widget.exercise.time != null) {
        widget.exercise.time!.add(0);
      }

      _setRows = _buildExerciseRows(widget.exercise);
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.exercise.sets != null) {
      _setRows = _buildExerciseRows(widget.exercise);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeWorkoutState = Provider.of<ActiveWorkoutState>(context);
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

  List<Widget> _buildExerciseRows(Exercise exercise) {
    List<Widget> rows = [];
    for (int i = 0; i < exercise.sets!.length; i++) {
      List<Widget> columns = [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text("Set ${exercise.sets![i]}:"),
        )
      ];

      if (exercise.reps != null) {
        columns.add(_buildTextField(
            "Reps", i, exercise.reps!, (value) => exercise.reps![i] = value));
      }
      if (exercise.weight != null) {
        columns.add(_buildTextField("Weight (kg)", i, exercise.weight!,
            (value) => exercise.weight![i] = value));
      }
      if (exercise.time != null) {
        columns.add(_buildTextField(
            "Time", i, exercise.time!, (value) => exercise.time![i] = value));
      }
      if (exercise.distance != null) {
        columns.add(_buildTextField("Distance", i, exercise.distance!,
            (value) => exercise.distance![i] = value));
      }

      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: columns,
      ));
    }
    return rows;
  }

  Widget _buildTextField(
      String label, int index, List<num> data, Function(num) updateFunction) {
    TextEditingController controller = _buildTextEditingController(data, index);
    return Container(
      width: 100,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label),
        onChanged: (value) {
          num? newValue = num.tryParse(value);
          if (newValue != null) {
            updateFunction(newValue);
            final activeWorkoutState =
                Provider.of<ActiveWorkoutState>(context, listen: false);
            activeWorkoutState.updateExercise(
                widget.exerciseIndex, widget.exercise);
          }
        },
      ),
    );
  }
}
