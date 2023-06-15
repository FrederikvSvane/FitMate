import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/classes/activeWorkoutState.dart';
import 'package:provider/provider.dart';

class ActiveWorkoutWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final activeWorkoutState = Provider.of<ActiveWorkoutState>(context);
    final timerService = activeWorkoutState.timerService;

    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/activeWorkout");
        },
        child: Container(
          height: 70.0,
          width: MediaQuery.of(context).size.width/1.1, // Full width of the screen
          margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/25,0.0,0.0,70.0), // Adjust this value based on the height of your navigation bar
          color: Colors.red[800],
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Active Workout",
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              StreamBuilder<int>(
                stream: timerService.timerStream,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  final int totalSeconds = (snapshot.data ?? 0);
                  final int hours = totalSeconds ~/ 3600;
                  final int minutes = (totalSeconds % 3600) ~/ 60;
                  final int seconds = totalSeconds % 60;
                  return Center(
                    child: Text(
                      ' ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.0,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

