import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/classes/Exercise.dart';
import 'package:flutter_fitness_app/classes/cardioExercise.dart';
import 'package:flutter_fitness_app/classes/timerService.dart';

class ActiveWorkout extends StatefulWidget {
  const ActiveWorkout({Key? key}) : super(key: key);

  @override
  State<ActiveWorkout> createState() => _ActiveWorkoutState();
}
class _ActiveWorkoutState extends State<ActiveWorkout> {
  List<Exercise> activeWeightExercises = [];
  TimerService timerService = TimerService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<int>(
          stream: timerService.timerStream,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            if (snapshot.hasData) {
              return Text('Active Workout: ${snapshot.data} seconds');
            } else {
              return Text('Active Workout');
            }
          },
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.red[800],
      ),
      body: Stack(
        children: [
          // List of exercises
          ListView.builder(
            itemCount: activeWeightExercises.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(activeWeightExercises[index].name),
                // add other fields of Exercise class as needed
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cancel Workout Button
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        activeWeightExercises.clear();
                        Navigator.pop(context);
                      });
                    },
                    icon: Icon(Icons.cancel_outlined),
                    label: Text("Cancel Workout"),
                  ),
                  // Add Exercise Button
                  ElevatedButton.icon(
                    onPressed: () async{
                      dynamic result = await Navigator.pushNamed(context, '/addExercise');
                      if (result != null) {
                        setState(() {
                          activeWeightExercises.add(result);
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

