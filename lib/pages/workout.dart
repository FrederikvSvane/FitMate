import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/classes/activeWorkoutState.dart';
import 'package:flutter_fitness_app/pages/templateCard.dart';
import 'package:provider/provider.dart';

import '../classes/Exercise.dart';
import '../classes/WorkoutTemplate.dart';


class Workout extends StatefulWidget {
  @override
  _WorkoutState createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  Map<String, dynamic> data = {};
  List<WorkoutTemplate> workoutTemplates = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchWorkoutTemplates();
  }

  void fetchWorkoutTemplates() async {
    var templates = await convertToWorkoutTemplates();
    setState(() {
      workoutTemplates = templates;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Builder(builder: (BuildContext scaffoldContext) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Workouts",
          ),
          backgroundColor: themeData.primaryColor,
          foregroundColor: themeData.appBarTheme.foregroundColor,
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
                  child: TextButton(
                    style: ElevatedButton.styleFrom(),
                    onPressed: () {
                      var activeWorkoutState = Provider.of<ActiveWorkoutState>(scaffoldContext, listen: false);
                      if (activeWorkoutState.isActive) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Alert'),
                              content: const Text('Workout already active'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        activeWorkoutState.workoutName = "Active Workout";
                        activeWorkoutState.startWorkout();
                        Navigator.pushNamed(context, "/activeWorkout");
                      }
                    },
                    child: Text(
                      'Start Empty Workout',
                      style: TextStyle(
                        color: themeData.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(child: listBuilder2())
          ],
        ),
      );
    });
  }

  Widget listBuilder2() {
    return ListView.builder(
      itemCount: workoutTemplates.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            var activeWorkoutState = Provider.of<ActiveWorkoutState>(context, listen: false);

            if (activeWorkoutState.isActive) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Alert'),
                    content: Text('Workout already active'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            } else {
              for (Exercise exercise in workoutTemplates[index].workoutExercises) {
                exercise = await checkDatabase(exercise);
                activeWorkoutState.addExercise(exercise);
              }
              activeWorkoutState.workoutName = workoutTemplates[index].workoutName;
              activeWorkoutState.startWorkout();
              Navigator.pushNamed(context, "/activeWorkout", arguments: workoutTemplates[index].workoutName);
            }
          },
          child: TemplateCard(template: workoutTemplates[index]),
        );
      },
    );
  }

  Future<Exercise> checkDatabase(Exercise exercise) async {
    List<Exercise> savedExercise = [];
    savedExercise = await fetchExercises();

    for (int i = 0; i < savedExercise.length; i++) {
      if (savedExercise[i].name == exercise.name) {
        exercise = savedExercise[i];
      }
    }
    return exercise;
  }
}
