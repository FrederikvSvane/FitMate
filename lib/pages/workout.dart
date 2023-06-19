import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/classes/activeWorkoutState.dart';
import 'package:flutter_fitness_app/pages/templateCard.dart';
import 'package:provider/provider.dart';

import '../classes/Exercise.dart';
import '../classes/WorkoutTemplate.dart';
import '../pages/activeWorkout.dart';

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
      workoutTemplates = templates ?? [];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.grey[200],
          body: Column(
            children: [
              Container(
                height: 150,
                color: Colors.red[800],
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: const Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "Workouts",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0,25.0, 0.0, 0.0),
                      child: TextButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                        onPressed: () {
                          var activeWorkoutState = Provider.of<ActiveWorkoutState>(context, listen: false);

                          activeWorkoutState.workoutName = "Active Workout";

                          activeWorkoutState.startWorkout();

                          Navigator.pushNamed(context, "/activeWorkout");
                        },
                        child: Text('Start Emtpy Workout',
                          style: TextStyle(
                            color: Colors.red[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          ),
                      ),
                    ),

            ],
              ),
              Expanded(
                child: listBuilder2()
              )
                ],
          ),
        );
  }
  Widget listBuilder2() {
    return ListView.builder(
      itemCount: workoutTemplates.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            var activeWorkoutState = Provider.of<ActiveWorkoutState>(context, listen: false);

            if(activeWorkoutState.isActive) {
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
            }else {
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
          //title: Text(activeExercises[index].name),
          // add other fields of Exercise class as needed
        );
      },
    );
  }
  Future<Exercise> checkDatabase(Exercise exercise) async{
    List<Exercise> savedExercise = [];
    savedExercise = await fetchExercises();

    for(int i = 0; i < savedExercise.length; i++){
      if(savedExercise[i].name == exercise.name){
        exercise = savedExercise[i];
      }
    }
    return exercise;
  }

}
