import 'package:flutter/material.dart';

import 'food.dart';

class AddFavoriteMeal extends StatefulWidget {
  const AddFavoriteMeal({Key? key}) : super(key: key);

  @override
  addFavoriteMealState createState() => addFavoriteMealState();
}

class addFavoriteMealState extends State<AddFavoriteMeal> {
  String whichMeal ='';
  String whichPick = '';

  @override
  Widget build(BuildContext context) {
    switch (whereDidIComeFrom) {
      case 0:
        whichMeal = 'Breakfast';
        whichPick = "assets/image/Breakfast.png";
        break;
      case 1:
        whichMeal = 'Lunch';
        whichPick = "assets/image/Lunch.png";
        break;
      case 2:
        whichMeal = 'Dinner';
        whichPick = "assets/image/Dinner.png";
        break;
      case 3:
        whichMeal = 'Snacks';
        whichPick = "assets/image/Snacks.png";
        break;
      default:
        whichMeal = 'null';
        whichPick = "null";
    }

    // Get the arguments passed to this route.
    final List<Map<String, dynamic>> meals = ModalRoute.of(context)!.settings.arguments as List<Map<String, dynamic>>;
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
             Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset("assets/image/Breakfast.png", width: 50, height: 50),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    whichMeal,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: meals.map((meal) {
                return ListTile(
                  title: Text(meal['nameComponent']),
                  subtitle: Text('Calories: ${meal['calories']}, Proteins: ${meal['proteins']}'),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
