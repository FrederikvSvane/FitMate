import 'package:flutter/material.dart';

class Workout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Page'),
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
                // Button click logic goes here
              },
              child: Text('Start Workout'),
            ),
          ),
        ],
      ),
    );
  }
}
