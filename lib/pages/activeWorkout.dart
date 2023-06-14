import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/classes/Exercise.dart';
import 'package:flutter_fitness_app/classes/WorkoutTemplate.dart';
import 'package:flutter_fitness_app/classes/timerService.dart';
import 'package:flutter_fitness_app/pages/exerciseCard.dart';

import '../DB/DBHelper.dart';

class ActiveWorkout extends StatefulWidget {
  const ActiveWorkout({Key? key}) : super(key: key);

  @override
  State<ActiveWorkout> createState() => _ActiveWorkoutState();
}

class _ActiveWorkoutState extends State<ActiveWorkout> {
  List<Exercise> activeExercises = [];

  TimerService timerService = TimerService();

  @override
  Widget build(BuildContext context) {
    activeExercises = ModalRoute.of(context)!.settings.arguments as List<Exercise>? ?? [];
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<int>(
          stream: timerService.timerStream,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            if (snapshot.hasData) {
              final int totalSeconds = snapshot.data!;
              final int hours = totalSeconds ~/ 3600;
              final int minutes = (totalSeconds % 3600) ~/ 60;
              final int seconds = totalSeconds % 60;
              return Text(
                  'Active Workout: ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}');
            } else {
              return Text('Active Workout');
            }
          },
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.red[800],
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text('Choose an option'),
                    children: <Widget>[
                      SimpleDialogOption(
                        onPressed: () async {
                          for(int i = 0; i < activeExercises.length; i++){
                            for(int j = 0; j < activeExercises[i].sets!.length; j++){
                              Map<String, dynamic> exerciseData = {
                                'name': activeExercises[i].name,
                                'sets': activeExercises[i].sets?[j],
                                'reps': activeExercises[i].reps?[j],
                                'weight': activeExercises[i].weight?[j],
                                'date': DateTime.now().toString(),
                              };
                              await DBHelper.insertExercise(exerciseData);
                            }
                          }


                          Navigator.pop(context);
                          List<Exercise> savedExercises = await fetchExercises();
                          print(savedExercises);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          color: Colors.red[800],
                          child: Text('Save Workout Data', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () async {
                          for(int i = 0; i < activeExercises.length; i++){
                            for(int j = 0; j < activeExercises[i].sets!.length; j++){
                              Map<String, dynamic> workoutData = {
                                'workoutName': 'Template Workout',
                                'name': activeExercises[i].name,
                                'sets': activeExercises[i].sets?[j],
                                'date': DateTime.now().toString(),
                              };
                              await DBHelper.insertWorkout(workoutData);
                            }
                          }

                          // Handle option 1
                          Navigator.pop(context);
                          List<WorkoutTemplate> savedWorkouts = await fetchWorkouts();
                          print(savedWorkouts);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          color: Colors.red[800],
                          child: Text('Save Workout as Template', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          // Handle option 1
                          Navigator.pop(context);
                          print('Option 1 chosen');
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          color: Colors.red[800],
                          child: Text('Finish without saving', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              "Finish Workout",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // List of exercises
          ListView.builder(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 100.0),
            itemCount: activeExercises.length,
            itemBuilder: (context, index) {
              return ExerciseCard(exercise: activeExercises[index]);
              //title: Text(activeExercises[index].name),
              // add other fields of Exercise class as needed
            },
          ),
          // Buttons to cancel workout and add exercise
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cancel Workout Button
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          activeExercises.clear();
                          Navigator.pop(context);
                        });
                      },
                      icon: Icon(Icons.cancel_outlined),
                      label: Text("Cancel Workout"),
                    ),
                    // Add Exercise Button
                    ElevatedButton.icon(
                      onPressed: () async {
                        dynamic result =
                            await Navigator.pushNamed(context, '/addExercise');
                        if (result != null) {
                          setState(() {
                            activeExercises.add(result);
                          });
                        }
                      },
                      icon: Icon(Icons.add),
                      label: Text("Add Exercise"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timerService.dispose();
    super.dispose();
  }
}
