import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/classes/Exercise.dart';
import 'package:flutter_fitness_app/classes/WorkoutTemplate.dart';
import 'package:flutter_fitness_app/classes/timerService.dart';
import 'package:flutter_fitness_app/pages/exerciseCard.dart';
import 'package:flutter_fitness_app/DB/DBHelper.dart';
import 'package:provider/provider.dart';

import '../DB/DBHelper.dart';
import '../classes/activeWorkoutState.dart';

class ActiveWorkout extends StatefulWidget {
  const ActiveWorkout({Key? key}) : super(key: key);

  @override
  State<ActiveWorkout> createState() => _ActiveWorkoutState();
}

class _ActiveWorkoutState extends State<ActiveWorkout> {
  List<Exercise> activeExercises = [];
  WorkoutTemplate template = WorkoutTemplate(workoutName: 'no name', workoutExercises: [], sets: [], date: '');

  TimerService timerService = TimerService();


  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    template = ModalRoute.of(context)!.settings.arguments as WorkoutTemplate? ?? WorkoutTemplate(workoutName: 'No name', workoutExercises: [], sets: [], date: '');
    activeExercises = template.workoutExercises;
  }

  @override
  Widget build(BuildContext context) {
    final activeWorkoutState = Provider.of<ActiveWorkoutState>(context);
    final timerService = activeWorkoutState.timerService;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton( // Add this leading property
            icon: Icon(Icons.arrow_downward, color: Colors.white),
            onPressed: () {
              Navigator.pop(context); // Navigates to the previous page
            },
          ),
          title: StreamBuilder<int>(
            stream: timerService.timerStream,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if (snapshot.hasData) {
                final int totalSeconds = snapshot.data!;
                final int hours = totalSeconds ~/ 3600;
                final int minutes = (totalSeconds % 3600) ~/ 60;
                final int seconds = totalSeconds % 60;
                return Text(
                    '${template.workoutName}: ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}');
              } else {
                return Text('${template.workoutName}');
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
                            Map<String, dynamic> workoutData = {
                              'workoutName': template.workoutName,
                              'exercises': '',
                              'type': '',
                              'sets': '',
                              'date': DateTime.now().toString(),
                            };
                            for(int i = 0; i < activeExercises.length; i++){
                                workoutData['exercises'] += activeExercises[i].name + ',';
                                workoutData['sets'] += '${activeExercises[i].sets!.length},';
                            }
                                await DBHelper.insertWorkout(workoutData);
                            print(workoutData);
                            // Handle option 1
                            Navigator.pop(context);
                            Navigator.pop(context);
                            List<WorkoutTemplate> savedWorkouts = await convertToWorkoutTemplates();
                            print(savedWorkouts);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            color: Colors.red[800],
                            child: const Text('Save Workout as Template', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            // Handle option 1
                            Navigator.pop(context);
                            Navigator.pop(context);
                            print('Option 1 chosen');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            color: Colors.red[800],
                            child: const Text('Finish without saving', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text(
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
              itemCount: activeWorkoutState.activeExercises.length,
              itemBuilder: (context, index) {
                return ExerciseCard(
                  exercise: activeWorkoutState.activeExercises[index],
                  exerciseIndex: index, // Pass the index to ExerciseCard
                );
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
                          var activeWorkoutState = Provider.of<ActiveWorkoutState>(context, listen: false);
                          activeWorkoutState.endWorkout();

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
                              activeWorkoutState.addExercise(result);
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
      ),
    );
  }

  @override
  void dispose() {
    timerService.dispose();
    super.dispose();
  }
}
