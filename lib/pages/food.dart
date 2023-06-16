import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/DB/DBHelper.dart';
import 'package:intl/intl.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

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
    loadGoalCalories();
  }

  void loadGoalCalories() async {
    if (goalCalories == 0) {
      List<Map<String, dynamic>>? goal = await DBHelper.getLatestGoal();
      if (goal!.isNotEmpty && goal[0]['caloricGoal'] != 0) {
        setState(() {
          goalCalories = goal[0]['caloricGoal'].toDouble();
        });
      }
    }
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

  double goalCalories = 0;
  double goalProteins = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
                await loadMealsFromDatabase();
                setState(() {});
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
              height: MediaQuery.of(context).size.height / 16,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.red[800],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () async {
                          setState(() {
                            selectedDate =
                                selectedDate.subtract(const Duration(days: 1));
                          });
                          await loadMealsFromDatabase();
                          setState(() {});
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
                        icon: const Icon(Icons.arrow_forward,
                            color: Colors.white),
                        onPressed: selectedDate.isBefore(DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day))
                            ? () async {
                                setState(() {
                                  selectedDate =
                                      selectedDate.add(const Duration(days: 1));
                                });
                                await loadMealsFromDatabase();
                                setState(() {});
                              }
                            : null, // Disable the button if the selected date is today or in the future
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'KCAL eaten:\n ${(totalCalories).toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                GestureDetector(
                  onTap: () async {
                    final String? goal = await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Enter Goal Calories'),
                          content: TextField(
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            onSubmitted: (value) {
                              Navigator.of(context).pop(value);
                            },
                          ),
                        );
                      },
                    );

                    if (goal != null) {
                      setState(() {
                        goalCalories = double.parse(goal);
                      });
                      DBHelper.insertGoal({'caloricGoal': goalCalories});
                    }
                    loadGoalCalories();
                  },
                  child: goalCalories == 0
                      ? const Text(
                          "Please set a calorie goal.",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : SleekCircularSlider(
                          appearance: CircularSliderAppearance(
                            startAngle: 270,
                            angleRange: 360,
                            size: 150,
                            // Size of the circular slider
                            customWidths: CustomSliderWidths(
                              progressBarWidth: 8,
                              // Set the width of the progress bar here.
                              trackWidth: 10,
                            ),
                            // Size of the circular slider
                            customColors: CustomSliderColors(
                              trackColor: Colors.grey.withOpacity(0.3),
                              // Less opaque track
                              progressBarColors: [
                                Colors.red,
                                Colors.orange,
                                Colors.yellow
                              ],
                              // Beautiful gradient for progress bar
                              gradientStartAngle: 0,
                              gradientEndAngle: 180,
                              shadowColor: Colors.transparent,
                              dotColor: Colors.transparent,
                            ),
                            infoProperties: InfoProperties(
                              bottomLabelStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                              modifier: (double value) {
                                if (totalCalories <= goalCalories) {
                                  final kcalLeft =
                                      max(0, goalCalories - totalCalories);
                                  return "$kcalLeft"; // Display the remaining calories
                                } else {
                                  final kcalOver = totalCalories - goalCalories;
                                  return "$kcalOver"; // Display the exceeded calories
                                }
                              },
                              bottomLabelText: totalCalories <= goalCalories
                                  ? 'KCAL Left'
                                  : 'KCAL Over',
                            ),
                          ),
                          min: 0,
                          max: goalCalories,
                          initialValue: min(totalCalories,
                              goalCalories), // The initial value is the minimum between totalCalories and goalCalories
                        ),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'Protein',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(
                  width: 120,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      sliderTheme: Theme.of(context).sliderTheme.copyWith(
                            disabledActiveTrackColor: Colors.orange,
                            disabledInactiveTrackColor:
                                Colors.orange.withOpacity(0.3),
                            //remove the thumb from the slider
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 0.0),
                          ),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        final String? proteinGoal = await showDialog<String>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Enter Goal Proteins'),
                              content: TextField(
                                autofocus: true,
                                keyboardType: TextInputType.number,
                                onSubmitted: (value) {
                                  Navigator.of(context).pop(value);
                                },
                              ),
                            );
                          },
                        );
                        if (proteinGoal != null) {
                          setState(() {
                            goalProteins = double.parse(proteinGoal);
                          });
                        }
                      },
                      child: Slider(
                        value: min(totalProteins,
                            goalProteins != 0 ? goalProteins : 1),
                        min: 0,
                        max: goalProteins != 0 ? goalProteins : 1,
                        // to avoid division by zero, the default maximum is 1
                        onChanged: null,
                        // Disables the ability for this to be changed by user interaction
                        label: "${totalProteins.round()}",
                        divisions: 10,
                      ),
                    ),
                  ),
                ),
                Text(
                  '${(totalProteins).round()} / ${goalProteins.round()}',
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  // Add padding at the bottom
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Padding(
                            // Add padding to the left
                            padding: EdgeInsets.only(left: 9.0, right: 5.0),
                            child: Icon(Icons
                                .restaurant), // Some icon that could represent a meal
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/addFavoriteMeal',
                                  arguments: breakfastMeals);
                              whereDidIComeFrom = 0;
                            },
                            child: const Text(
                              'Breakfast',
                              style: TextStyle(
                                  fontSize: 24, // Increased text size
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              whereDidIComeFrom = 0;
                              var result = await Navigator.pushNamed(
                                  context, "/addFood");
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
                                      'nameComponent':
                                          mealData['nameComponent'],
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
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      Column(
                        children: breakfastMeals.map((meal) {
                          String mealDetails = '${meal['nameComponent']}';
                          int mealId = meal['id'];
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, bottom: 0.0),
                            // Added padding to the left and bottom
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  mealDetails,
                                  style: const TextStyle(
                                      fontSize: 18), // Increased text size
                                ),
                                IconButton(
                                  //make the icon an x
                                  icon: const Icon(Icons.delete_forever),
                                  iconSize: 15,
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(
                                        mealId, 'Breakfast');
                                  },
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: SizedBox(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  // Add padding at the bottom
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Padding(
                            // Add padding to the left
                            padding: EdgeInsets.only(left: 9.0, right: 5.0),
                            child: Icon(Icons
                                .restaurant), // Some icon that could represent a meal
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/addFavoriteMeal',
                                  arguments: lunchMeals);
                              whereDidIComeFrom = 1;
                            },
                            child: const Text(
                              'Lunch',
                              style: TextStyle(
                                  fontSize: 24, // Increased text size
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              whereDidIComeFrom = 1;
                              var result = await Navigator.pushNamed(
                                  context, "/addFood");
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
                                    lunchMeals.add({
                                      'id': mealData['id'],
                                      'nameComponent':
                                          mealData['nameComponent'],
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
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      Column(
                        children: lunchMeals.map((meal) {
                          String mealDetails = '${meal['nameComponent']}';
                          int mealId = meal['id'];
                          return Padding(
                            padding: EdgeInsets.only(left: 10.0, bottom: 0.0),
                            // Added padding to the left and bottom
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  mealDetails,
                                  style: TextStyle(
                                      fontSize: 18), // Increased text size
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(
                                        mealId, 'Lunch');
                                  },
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: SizedBox(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  // Add padding at the bottom
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Padding(
                            // Add padding to the left
                            padding: EdgeInsets.only(left: 9.0, right: 5.0),
                            child: Icon(Icons
                                .restaurant), // Some icon that could represent a meal
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/addFavoriteMeal',
                                  arguments: dinnerMeals);
                              whereDidIComeFrom = 2;
                            },
                            child: const Text(
                              'Dinner',
                              style: TextStyle(
                                  fontSize: 24, // Increased text size
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              whereDidIComeFrom = 2;
                              var result = await Navigator.pushNamed(
                                  context, "/addFood");
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
                                    dinnerMeals.add({
                                      'id': mealData['id'],
                                      'nameComponent':
                                          mealData['nameComponent'],
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
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      Column(
                        children: dinnerMeals.map((meal) {
                          String mealDetails = '${meal['nameComponent']}';
                          int mealId = meal['id'];
                          return Padding(
                            padding: EdgeInsets.only(left: 10.0, bottom: 0.0),
                            // Added padding to the left and bottom
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  mealDetails,
                                  style: TextStyle(
                                      fontSize: 18), // Increased text size
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(
                                        mealId, 'Dinner');
                                  },
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: SizedBox(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  // Add padding at the bottom
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Padding(
                            // Add padding to the left
                            padding: EdgeInsets.only(left: 9.0, right: 5.0),
                            child: Icon(Icons
                                .restaurant), // Some icon that could represent a meal
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/addFavoriteMeal',
                                  arguments: snacksMeals);
                              whereDidIComeFrom = 3;
                            },
                            child: const Text(
                              'Snacks',
                              style: TextStyle(
                                  fontSize: 24, // Increased text size
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              whereDidIComeFrom = 3;
                              var result = await Navigator.pushNamed(
                                  context, "/addFood");
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
                                    snacksMeals.add({
                                      'id': mealData['id'],
                                      'nameComponent':
                                          mealData['nameComponent'],
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
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      Column(
                        children: snacksMeals.map((meal) {
                          String mealDetails = '${meal['nameComponent']}';
                          int mealId = meal['id'];
                          return Padding(
                            padding: EdgeInsets.only(left: 10.0, bottom: 0.0),
                            // Added padding to the left and bottom
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  mealDetails,
                                  style: TextStyle(
                                      fontSize: 18), // Increased text size
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(
                                        mealId, 'Snacks');
                                  },
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
