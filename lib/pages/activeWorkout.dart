import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/classes/Exercise.dart';
import 'package:flutter_fitness_app/classes/timerService.dart';
import 'package:flutter_fitness_app/pages/exerciseCard.dart';

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
    print('$activeExercises');
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
              return Text('Active Workout: ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}');
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
                      onPressed: () async{
                        dynamic result = await Navigator.pushNamed(context, '/addExercise');
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

