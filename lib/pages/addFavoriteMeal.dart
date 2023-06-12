import 'package:flutter/material.dart';

class addFavoriteMeal extends StatefulWidget {
  const addFavoriteMeal({Key? key}) : super(key: key);

  @override
  State<addFavoriteMeal> createState() => addFavoriteMealState();
}

class addFavoriteMealState extends State<addFavoriteMeal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.red[800],

      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),

        ),
      ),


    );
  }
}
