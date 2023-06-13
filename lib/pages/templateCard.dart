import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/classes/WorkoutTemplate.dart';

class TemplateCard extends StatefulWidget {
  final WorkoutTemplate template;

  TemplateCard({required this.template});

  @override
  _TemplateCardState createState() => _TemplateCardState();
}

class _TemplateCardState extends State<TemplateCard> {
  List<Widget> _setRows = [];

  void _addExerciseRow() {
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.template.workoutExercises != null) {
      _setRows = _buildExerciseRows(widget.template);
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
            /*Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: _addExerciseRow,
                    icon: Icon(Icons.add),
                    label: Text("Add Set"),
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  List<Widget> _buildExerciseRows(WorkoutTemplate template) {
    List<Widget> rows = [];
    for (int i = 0; i < template.workoutExercises.length; i++) {
      rows.add(
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${template.workoutExercises[i].sets![0]}X ${template.workoutExercises[i].name}"),
            ],
          ),
        ),
      );
    }
    return rows;
  }
}
