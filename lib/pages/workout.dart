import 'package:flutter/material.dart';

class Workout extends StatefulWidget {
  @override
  _WorkoutState createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  Map<String, dynamic> data = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Page'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.red[800],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text("Workout Page"),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                dynamic result = Navigator.pushNamed(context, "/activeWorkout");
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
              child: Text('Start Emtpy Workout'),
            ),
          ),
        ],
      ),
    );
  }
}
