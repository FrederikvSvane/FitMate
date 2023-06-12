import 'package:flutter/material.dart';

class AddFavoriteMeal extends StatefulWidget {
  const AddFavoriteMeal({Key? key}) : super(key: key);

  @override
  addFavoriteMealState createState() => addFavoriteMealState();
}

class addFavoriteMealState extends State<AddFavoriteMeal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Favorite meal'),
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
