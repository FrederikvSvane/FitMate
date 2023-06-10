import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/DB/DBHelper.dart';


class Food extends StatefulWidget {
  const Food({Key? key}) : super(key: key);

  @override
  State<Food> createState() => _FoodState();
}

int whereDidIComeFrom = 0;

class _FoodState extends State<Food> {
  List<String> breakfastMeals = [];
  List<String> lunchMeals = [];
  List<String> dinnerMeals = [];
  List<String> snacksMeals = [];

  @override
  void initState() {
    print("initState");
    super.initState();
    loadMealsFromDatabase();
  }

  Future<void> loadMealsFromDatabase() async {
    DateTime now = DateTime.now();
    String currentDate = now.toString().substring(0, 10);
    List<Map<String, dynamic>> meals = await DBHelper.getAllMeals();

    breakfastMeals.clear();
    lunchMeals.clear();
    dinnerMeals.clear();
    snacksMeals.clear();

    for (var meal in meals) {
      if (meal['date'] != null && meal['date'].length >= 10) {
        String mealdate = meal['date'].substring(0, 10);
        print(mealdate);
        print(currentDate);
        if (mealdate == currentDate) {
          String mealDetails =
              'name: ${meal['nameComponent']}, Calories: ${meal['calories']}, proteins: ${meal['proteins']}';
          if (meal['mealType'] == 'Breakfast') {
            setState(() {
              breakfastMeals.add(mealDetails);
            });
          } else if (meal['mealType'] == 'Lunch') {
            setState(() {
              lunchMeals.add(mealDetails);
            });
          } else if (meal['mealType'] == 'Dinner') {
            setState(() {
              dinnerMeals.add(mealDetails);
            });
          } else if (meal['mealType'] == 'Snacks') {
            setState(() {
              snacksMeals.add(mealDetails);
            });
          }
        }
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Page'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.red[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      whereDidIComeFrom = 0;
                      dynamic text =
                      await Navigator.pushNamed(context, "/addFood");
                      List<String> list = [
                        'name: ${text["nameComponent"]}, Calories: ${text["calories"]}, proteins: ${text["proteins"]}'
                      ];
                      setState(() {
                        breakfastMeals.add(list[0]);
                      });
                    },
                    child: const Text("Add breakfast"),
                  ),
                  const SizedBox(height: 10),
                  Text('Today\'s breakfast meals:'),
                  Column(
                    children: breakfastMeals
                        .map((meal) => Text(meal))
                        .toList(),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    whereDidIComeFrom = 1;
                    dynamic text =
                    await Navigator.pushNamed(context, "/addFood");
                    List<String> list = [
                      'name: ${text["nameComponent"]}, Calories: ${text["calories"]}, proteins: ${text["proteins"]}'
                    ];
                    setState(() {
                      lunchMeals.add(list[0]);
                    });
                  },
                  child: const Text("Add Lunch"),
                ),
                const SizedBox(height: 10),
                Text('Today\'s lunch meals:'),
                Column(
                  children: lunchMeals.map((meal) => Text(meal)).toList(),
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    whereDidIComeFrom = 2;
                    dynamic text =
                    await Navigator.pushNamed(context, "/addFood");
                    List<String> list = [
                      'name: ${text["nameComponent"]}, Calories: ${text["calories"]}, proteins: ${text["proteins"]}'
                    ];
                    setState(() {
                      dinnerMeals.add(list[0]);
                    });
                  },
                  child: const Text("Add Dinner"),
                ),
                const SizedBox(height: 10),
                Text('Today\'s dinner meals:'),
                Column(
                  children: dinnerMeals.map((meal) => Text(meal)).toList(),
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    whereDidIComeFrom = 3;
                    dynamic text =
                    await Navigator.pushNamed(context, "/addFood");
                    List<String> list = [
                      'name: ${text["nameComponent"]}, Calories: ${text["calories"]}, proteins: ${text["proteins"]}'
                    ];
                    setState(() {
                      snacksMeals.add(list[0]);
                    });
                  },
                  child: const Text("Add Snacks"),
                ),
                const SizedBox(height: 10),
                const Text('Today\'s snacks m'
                    'eals:'),
                Column(
                  children: snacksMeals.map((meal) => Text(meal)).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
