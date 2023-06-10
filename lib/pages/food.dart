import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/DB/DBHelper.dart';
import 'package:intl/intl.dart';


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
  double totalCalories = 0;
  double totalProteins = 0;

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
    totalCalories = 0;
    totalProteins = 0;

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
      totalCalories = totalCalories + meal['calories'];
      totalProteins = totalProteins + meal['proteins'];
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
                firstDate: DateTime(2023),
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
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Design for the selected day is made with assistance from chatGPT
            Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.only(bottom: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.blue[50],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    'Chosen Date',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    DateFormat('EEEE, MMMM d, y').format(selectedDate),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  const SizedBox(height: 10),
                  const Text('Today\'s breakfast meals:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Column(
                    children: breakfastMeals.map((meal) {
                      String mealDetails =
                          'Name: ${meal['nameComponent']}, Calories: ${meal['calories']}, proteins: ${meal['proteins']}';
                      int mealId = meal['id'];
                      return Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                        ),
                      );
                    }).toList(),
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      whereDidIComeFrom = 0;
                      var result =
                      await Navigator.pushNamed(context, "/addFood");
                      if (result != null) {
                        Map<String, dynamic> mealData =
                        result as Map<String, dynamic>;
                        if (mealData['id'] != null &&
                            mealData['nameComponent'] != null &&
                            mealData['calories'] != null &&
                            mealData['proteins'] != null &&
                            mealData['mealType'] != null &&
                            mealData['date'] != null) {
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
                        loadMealsFromDatabase();
                      }
                    },
                    child: const Text("Add breakfast"),
                  ),
                ],
              ),
            ),
            Column(
              children: [

                const SizedBox(height: 10),
                const Text('Today\'s lunch meals:',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Column(
                  children: lunchMeals.map((meal) {
                    String mealDetails =
                        'Name: ${meal['nameComponent']}, Calories: ${meal['calories']}, proteins: ${meal['proteins']}';
                    int mealId = meal['id'];
                    return Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                    ));
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () async {
                    whereDidIComeFrom = 1;
                    var result = await Navigator.pushNamed(context, "/addFood");
                    Map<String, dynamic> mealData =
                    result as Map<String, dynamic>;
                    if (mealData['id'] != null &&
                        mealData['nameComponent'] != null &&
                        mealData['calories'] != null &&
                        mealData['proteins'] != null &&
                        mealData['mealType'] != null &&
                        mealData['date'] != null) {
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
                    loadMealsFromDatabase();
                  },
                  child: const Text("Add Lunch"),
                ),
              ],
            ),
            Column(
              children: [

                const SizedBox(height: 10),
                const Text('Today\'s dinner meals:',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Column(
                  children: dinnerMeals.map((meal) {
                    String mealDetails =
                        'Name: ${meal['nameComponent']}, Calories: ${meal['calories']}, proteins: ${meal['proteins']}';
                    int mealId = meal['id'];
                    return Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                    ));
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () async {
                    whereDidIComeFrom = 2;
                    var result = await Navigator.pushNamed(context, "/addFood");
                    Map<String, dynamic> mealData =
                    result as Map<String, dynamic>;
                    if (mealData['id'] != null &&
                        mealData['nameComponent'] != null &&
                        mealData['calories'] != null &&
                        mealData['proteins'] != null &&
                        mealData['mealType'] != null &&
                        mealData['date'] != null) {
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
                    loadMealsFromDatabase();
                  },
                  child: const Text("Add Dinner"),
                ),
              ],
            ),
            Column(
              children: [

                const SizedBox(height: 10),
                const Text('Today\'s snack meals:',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Column(
                  children: snacksMeals.map((meal) {
                    String mealDetails =
                        'Name: ${meal['nameComponent']}, Calories: ${meal['calories']}, proteins: ${meal['proteins']}';
                    int mealId = meal['id'];
                    return Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                    ));
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () async {
                    whereDidIComeFrom = 3;
                    var result = await Navigator.pushNamed(context, "/addFood");
                    Map<String, dynamic> mealData =
                    result as Map<String, dynamic>;
                    if (mealData['id'] != null &&
                        mealData['nameComponent'] != null &&
                        mealData['calories'] != null &&
                        mealData['proteins'] != null &&
                        mealData['mealType'] != null &&
                        mealData['date'] != null) {
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
                    loadMealsFromDatabase();
                  },
                  child: const Text("Add Snacks"),
                ),
              ],
            ),
            const Divider(
              //color: Colors.red[800],
              thickness: 2,
            ),
            const Padding(padding: EdgeInsets.all(10)),
            const Text("Todays total calories:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(
              totalCalories.toString(),
              style: const TextStyle(fontSize: 20),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            const Text("Todays total proteins:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(
              totalProteins.toString(),
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
