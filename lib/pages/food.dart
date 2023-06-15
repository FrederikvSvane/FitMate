import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/DB/DBHelper.dart';
import 'package:intl/intl.dart';

class Food extends StatefulWidget {
  const Food({Key? key}) : super(key: key);

  @override
  State<Food> createState() => _FoodState();
}

int whereDidIComeFrom = 0;
DateTime selectedDate = DateTime.now();

class _FoodState extends State<Food> {
  List<Map<String, dynamic>> breakfastMeals = [];
  List<Map<String, dynamic>> lunchMeals = [];
  List<Map<String, dynamic>> dinnerMeals = [];
  List<Map<String, dynamic>> snacksMeals = [];
  double totalCalories = 0;
  double totalProteins = 0;
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    print("initState");
    super.initState();
    loadMealsFromDatabase();
  }

  Future<void> loadMealsFromDatabase() async {
    DateTime now = selectedDate;
    String currentDate = now.toString().substring(0, 10);
    List<Map<String, dynamic>> meals = await DBHelper.getAllMeals();

    breakfastMeals.clear();
    lunchMeals.clear();
    dinnerMeals.clear();
    snacksMeals.clear();
    totalCalories = 0;
    totalProteins = 0;

    for (var meal in meals) {
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
          totalCalories = totalCalories + meal['calories'];
          totalProteins = totalProteins + meal['proteins'];
        }
      }
    }
  }

  Future<void> _showDeleteConfirmationDialog(
      int mealId, String mealType) async {
    List<Map<String, dynamic>> mealData = await DBHelper.getMealById(mealId);

    // This is to prevent the dialog from being shown after the page is disposed
    if (!context.mounted) return;

    String mealName = mealData[0]['nameComponent'];
    double mealCalories = mealData[0]['calories'];
    double mealProteins = mealData[0]['proteins'];

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Meal'),
          content: Text(
              'Are you sure you want to delete this meal:\n\nName: $mealName\nCalories: $mealCalories\nProteins: $mealProteins\n\nThis action cannot be undone!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await DBHelper.removeMeal(mealId);
                setState(() {
                  switch (mealType) {
                    case 'Breakfast':
                      breakfastMeals
                          .removeWhere((meal) => meal['id'] == mealId);
                      break;
                    case 'Lunch':
                      lunchMeals.removeWhere((meal) => meal['id'] == mealId);
                      break;
                    case 'Dinner':
                      dinnerMeals.removeWhere((meal) => meal['id'] == mealId);
                      break;
                    case 'Snacks':
                      snacksMeals.removeWhere((meal) => meal['id'] == mealId);
                      break;
                  }
                  loadMealsFromDatabase();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter demo',
        home: Scaffold(
            body: Column(children: [
              Container(
                height: 200,
                color: Colors.red[800],
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        color: Colors.white,
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
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Nutrition',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            color: Colors.white,
                            icon: const Icon(Icons.arrow_back_ios_new),
                            onPressed: () async {
                              selectedDate = selectedDate.subtract(const Duration(days: 1));
                              setState(() {

                              });
                            },
                          ),
                          Text(
                            DateFormat('EEEE, MMMM d, y').format(selectedDate),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          IconButton(
                            color: Colors.white,
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: () async {
                              selectedDate = selectedDate.add(const Duration(days: 1));
                              setState(() {
                              });
                              },
                          ),
                        ],
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Protein: $totalProteins',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Calories: $totalCalories',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ))
                  ],
                ),
              ),
              SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [breakfastList(), addBreakfast()],
                          ),
                          Column(
                            children: [lunchList(),addLunch()],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [dinnerList(), addDinner()],
                          ),
                          Column(
                            children: [snackList(),addSnack()],
                          ),
                        ],
                      )
                    ],
                  )
              )
            ]
            )
        )
    );
  }

  Widget breakfastList() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const SizedBox(height: 10),
      const Text('Breakfast:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      Column(
        children: breakfastMeals.map((meal) {
          String mealDetails =
              'Name: ${meal['nameComponent']}\nCalories: ${meal['calories']}\nProteins: ${meal['proteins']}';
          int mealId = meal['id'];
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(mealDetails),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _showDeleteConfirmationDialog(mealId, 'Breakfast');
                },
              )
            ],
          );
        }).toList(),
      ),
    ]);
  }

  Widget lunchList() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const SizedBox(height: 10),
      const Text('Lunch:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      Column(
        children: lunchMeals.map((meal) {
          String mealDetails =
              'Name: ${meal['nameComponent']}\nCalories: ${meal['calories']}\nProteins: ${meal['proteins']}';
          int mealId = meal['id'];
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(mealDetails),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _showDeleteConfirmationDialog(mealId, 'Lunch');
                },
              )
            ],
          );
        }).toList(),
      ),
    ]);
  }

  Widget dinnerList() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const SizedBox(height: 10),
      const Text('Dinner:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      Column(
        children: dinnerMeals.map((meal) {
          String mealDetails =
              'Name: ${meal['nameComponent']}\nCalories: ${meal['calories']}\nProteins: ${meal['proteins']}';
          int mealId = meal['id'];
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(mealDetails),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _showDeleteConfirmationDialog(mealId, 'Dinner');
                },
              )
            ],
          );
        }).toList(),
      ),
    ]);
  }

  Widget snackList() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const SizedBox(height: 10),
      const Text('Snack:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      Column(
        children: snacksMeals.map((meal) {
          String mealDetails =
              'Name: ${meal['nameComponent']}\nCalories: ${meal['calories']}\nProteins: ${meal['proteins']}';
          int mealId = meal['id'];
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(mealDetails),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _showDeleteConfirmationDialog(mealId, 'Snack');
                },
              )
            ],
          );
        }).toList(),
      ),
    ]);
  }

  Widget addBreakfast() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[800],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20))
      ),
      onPressed: () async {

        whereDidIComeFrom = 1;
        var result = await Navigator.pushNamed(context, "/addFood");
        Map<String, dynamic> mealData = result as Map<String, dynamic>;
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
      },
      child: const Text("Add breakfast"),
    );
  }

  Widget addLunch() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[800],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20))
      ),
      onPressed: () async {
        whereDidIComeFrom = 1;
        var result = await Navigator.pushNamed(context, "/addFood");
        Map<String, dynamic> mealData = result as Map<String, dynamic>;
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
      child: const Text("Add lunch"),
    );
  }

  Widget addDinner() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[800],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20))
      ),
      onPressed: () async {
        whereDidIComeFrom = 1;
        var result = await Navigator.pushNamed(context, "/addFood");
        Map<String, dynamic> mealData = result as Map<String, dynamic>;
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
      child: const Text("Add dinner"),
    );
  }

  Widget addSnack() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[800],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20))
      ),
      onPressed: () async {
        whereDidIComeFrom = 1;
        var result = await Navigator.pushNamed(context, "/addFood");
        Map<String, dynamic> mealData = result as Map<String, dynamic>;
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
      child: const Text("Add snack"),
    );
  }
}