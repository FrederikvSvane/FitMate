import 'package:flutter/material.dart';

import 'food.dart';

class AddFavoriteMeal extends StatefulWidget {
  const AddFavoriteMeal({Key? key}) : super(key: key);

  @override
  addFavoriteMealState createState() => addFavoriteMealState();
}

class addFavoriteMealState extends State<AddFavoriteMeal> {
  String whichMeal ='';

  @override
  Widget build(BuildContext context) {
    switch (whereDidIComeFrom) {
      case 0:
        whichMeal = 'Breakfast';
        break;
      case 1:
        whichMeal = 'Lunch';
        break;
      case 2:
        whichMeal = 'Dinner';
        break;
      case 3:
        whichMeal = 'Snacks';
        break;
      default:
        whichMeal = 'null';
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
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    whichMeal,
                    style: const TextStyle(
                      fontSize: 20,
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
