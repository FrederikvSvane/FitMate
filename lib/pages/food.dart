import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/DB/DBHelper.dart';

class Food extends StatefulWidget {
  const Food({Key? key}) : super(key: key);

  @override
  State<Food> createState() => _FoodState();
}

int whereDidIComeFrom = 0;

class _FoodState extends State<Food> {
  List<Map<String, dynamic>> breakfastMeals = [];
  List<Map<String, dynamic>> lunchMeals = [];
  List<Map<String, dynamic>> dinnerMeals = [];
  List<Map<String, dynamic>> snacksMeals = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    print("initState");
    super.initState();
    loadMealsFromDatabase();
  }

  Future<void> loadMealsFromDatabase() async {
    DateTime now = selectedDate;
    print(selectedDate);
    String currentDate = now.toString().substring(0, 10);
    List<Map<String, dynamic>> meals = await DBHelper.getAllMeals();

    breakfastMeals.clear();
    lunchMeals.clear();
    dinnerMeals.clear();
    snacksMeals.clear();

    for (var meal in meals) {
      print(meal);
      if (meal['date'] != null && meal['date'].length >= 10) {
        String mealDate = meal['date'].substring(0, 10);
        if (mealDate == currentDate) {

          Map<String, dynamic> mealDetails = {
            'id': meal['id'],
            'nameComponent': meal['nameComponent'],
            'calories': meal['calories'],
            'proteins': meal['proteins'],
          };
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
        title: const Text('Food Page'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2021),
                lastDate: DateTime.now(),
              );
              if (picked != null && picked != selectedDate) {
                setState(() {
                  selectedDate = picked;
                });
                loadMealsFromDatabase(); // Add this line to reload the meals from the database for the selected date
              }
            },
          )
        ],
        foregroundColor: Colors.white,
        backgroundColor: Colors.red[800],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Chosen date is: ${selectedDate.toString().substring(0, 10)}',
              style: const TextStyle(fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      whereDidIComeFrom = 0;
                      var result = await Navigator.pushNamed(context, "/addFood");
                      if (result != null) {
                        Map<String, dynamic> mealData = result as Map<String, dynamic>;
                        if (mealData['id'] != null &&
                            mealData['nameComponent'] != null &&
                            mealData['calories'] != null &&
                            mealData['proteins'] != null &&
                            mealData['mealType'] != null &&
                            mealData['date'] != null
                        ) {
                          setState(() {
                            breakfastMeals.add({
                              'id': mealData['id'],
                              'nameComponent': mealData['nameComponent'],
                              'calories': mealData['calories'],
                              'proteins': mealData['proteins'],
                              'mealType': mealData['mealType'],
                              'date': mealData['date'],
                            });
                          });
                        }

                      }
                    },
                    child: const Text("Add breakfast"),
                  ),
                  const SizedBox(height: 10),
                  const Text('Today\'s breakfast meals:'),
                  Column(
                    children: breakfastMeals.map((meal) {
                      String mealDetails =
                          'name: ${meal['nameComponent']}, Calories: ${meal['calories']}, proteins: ${meal['proteins']}';
                      int mealId = meal['id'];
                      return Row(
                        children: [
                          Text(mealDetails),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await DBHelper.removeMeal(mealId);
                              setState(() {
                                breakfastMeals.remove(meal);
                              });
                            },
                          )
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    whereDidIComeFrom = 1;
                    var result = await Navigator.pushNamed(context, "/addFood");
                    Map<String, dynamic> mealData = result as Map<String, dynamic>;
                    if (mealData['id'] != null &&
                        mealData['nameComponent'] != null &&
                        mealData['calories'] != null &&
                        mealData['proteins'] != null &&
                        mealData['mealType'] != null &&
                        mealData['date'] != null
                    ) {
                      setState(() {
                        lunchMeals.add({
                          'id': mealData['id'],
                          'nameComponent': mealData['nameComponent'],
                          'calories': mealData['calories'],
                          'proteins': mealData['proteins'],
                          'mealType': mealData['mealType'],
                          'date': mealData['date'],
                        });
                      });
                    }
                  },
                  child: const Text("Add Lunch"),
                ),
                const SizedBox(height: 10),
                const Text('Today\'s lunch meals:'),
                Column(
                  children: lunchMeals.map((meal) {
                    String mealDetails =
                        'name: ${meal['nameComponent']}, Calories: ${meal['calories']}, proteins: ${meal['proteins']}';
                    int mealId = meal['id'];
                    return Row(
                      children: [
                        Text(mealDetails),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await DBHelper.removeMeal(mealId);
                            setState(() {
                              lunchMeals.remove(meal);
                            });
                          },
                        )
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    whereDidIComeFrom = 2;
                    var result = await Navigator.pushNamed(context, "/addFood");
                    Map<String, dynamic> mealData = result as Map<String, dynamic>;
                    if (mealData['id'] != null &&
                        mealData['nameComponent'] != null &&
                        mealData['calories'] != null &&
                        mealData['proteins'] != null &&
                        mealData['mealType'] != null &&
                        mealData['date'] != null
                    ) {
                      setState(() {
                        dinnerMeals.add({
                          'id': mealData['id'],
                          'nameComponent': mealData['nameComponent'],
                          'calories': mealData['calories'],
                          'proteins': mealData['proteins'],
                          'mealType': mealData['mealType'],
                          'date': mealData['date'],
                        });
                      });
                    }
                  },
                  child: const Text("Add Dinner"),
                ),
                const SizedBox(height: 10),
                const Text('Today\'s dinner meals:'),
                Column(
                  children: dinnerMeals.map((meal) {
                    String mealDetails =
                        'name: ${meal['nameComponent']}, Calories: ${meal['calories']}, proteins: ${meal['proteins']}';
                    int mealId = meal['id'];
                    return Row(
                      children: [
                        Text(mealDetails),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await DBHelper.removeMeal(mealId);
                            setState(() {
                              dinnerMeals.remove(meal);
                            });
                          },
                        )
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    whereDidIComeFrom = 3;
                    var result = await Navigator.pushNamed(context, "/addFood");
                    Map<String, dynamic> mealData = result as Map<String, dynamic>;
                    if (mealData['id'] != null &&
                        mealData['nameComponent'] != null &&
                        mealData['calories'] != null &&
                        mealData['proteins'] != null &&
                        mealData['mealType'] != null &&
                        mealData['date'] != null
                    ) {
                      setState(() {
                        snacksMeals.add({
                          'id': mealData['id'],
                          'nameComponent': mealData['nameComponent'],
                          'calories': mealData['calories'],
                          'proteins': mealData['proteins'],
                          'mealType': mealData['mealType'],
                          'date': mealData['date'],
                        });
                      });
                    }
                  },
                  child: const Text("Add Snacks"),
                ),
                const SizedBox(height: 10),
                const Text('Today\'s snack meals:'),
                Column(
                  children: snacksMeals.map((meal) {
                    String mealDetails =
                        'name: ${meal['nameComponent']}, Calories: ${meal['calories']}, proteins: ${meal['proteins']}';
                    int mealId = meal['id'];
                    return Row(
                      children: [
                        Text(mealDetails),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await DBHelper.removeMeal(mealId);
                            setState(() {
                              snacksMeals.remove(meal);
                            });
                          },
                        )
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
