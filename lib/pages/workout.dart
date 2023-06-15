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
    print('${workoutTemplates[0].workoutExercises} hey');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.grey[200],
          body: Column(
            children: [
              Container(
                height: 200,
                color: Colors.red[800],
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
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
                              fontSize: 30,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                          'Avg weekly time: 17 hrs',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Text(
                          'Total time spent: 1000 hrs',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Text(
                          'Total workouts: 73',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Avg weekly workouts: 4',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
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
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                      onPressed: () {
                        var activeWorkoutState = Provider.of<ActiveWorkoutState>(context, listen: false);

                        activeWorkoutState.startWorkout();

                        Navigator.pushNamed(context, "/activeWorkout");
                      },
                      child: Text('Start Emtpy Workout',
                        style: TextStyle(
                          color: Colors.red[800],
                          fontWeight: FontWeight.bold
                        ),
                        ),
                    ),

              ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        ActiveWorkoutState().startWorkout();
                        dynamic result =
                        Navigator.pushNamed(context, "/activeWorkout",
                            arguments: workoutTemplates[0]);
                        setState(() {
                          // Her skal dataen fra den aktive workout videresendes til næste skærm
                          // Men jeg er hverken sikker på om det er den her skærm, der skal bruge dataen,
                          // eller hvad dataen er endnu.
                          // Vi må se hvad der sker når vi kommer så langt :p

                          // Den kommer i hvert fald til at være noget i retning af:
                          // data = {
                          //   "weightExercises": result["weightExercises"],
                          //   "cardioExercises": result["cardioExercises"],
                        });
                      },
                      child: Text('Start existing template',
                      style: TextStyle(
                        color: Colors.red[800],
                        fontWeight: FontWeight.bold
                      ),),
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
        return GestureDetector( //You need to make my child interactive
          onTap: () {
            dynamic result =
            Navigator.pushNamed(context, "/activeWorkout",
                arguments: workoutTemplates[index]);
          },
          child: TemplateCard(template: workoutTemplates[index]),
          //title: Text(activeExercises[index].name),
          // add other fields of Exercise class as needed
        );
      },
    );
  }
}
