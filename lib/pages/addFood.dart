import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/pages/food.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../classes/FoodApi.dart';
import '../main.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  AddFoodState createState() => AddFoodState();
}

class AddFoodState extends State<AddFood> {
  final barcodeController = TextEditingController();
  final howMuchController = TextEditingController();
  String howMuch = '100';
  Future<FoodApi>? foodApiFuture;

  Future<FoodApi> fetchFood(String barcode) {
    try {
      var barcodeInt = int.parse(barcode);
      var foodApi = FoodApi.fetchFoodApi(barcodeInt);
      return foodApi;
    } catch (e) {
      throw ArgumentError('Invalid barcode: $barcode');
    }
  }

  Future<void> addMeal() async {
    if (foodApiFuture != null) {
      if (whereDidIComeFrom == 0) {
        try {
          FoodApi result = await foodApiFuture!;
          String mealType = 'Breakfast';
          String date = DateTime.now().toString();
          result.date = date;
          result.mealType = mealType;
          await result.insertMeal(database);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Meal added successfully'),
              duration: Duration(seconds: 1),
            ),
          );
          String barcode = result.getBarcode().toString();
          String nameComponent = result.getNameComponent().toString();
          String calories = result.getCalories().toString();
          String proteins = result.getProteins().toString();

          Navigator.pop(context, {
            'barcode': barcode,
            'nameComponent': nameComponent,
            'calories': calories,
            'proteins': proteins,
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to add meal'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      } else if (whereDidIComeFrom == 1) {
        try {
          FoodApi result = await foodApiFuture!;
          String mealType = 'Lunch';
          String date = DateTime.now().toString();
          result.date = date;
          result.mealType = mealType;
          await result.insertMeal(database);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Meal added successfully'),
              duration: Duration(seconds: 1),
            ),
          );
          String barcode = result.getBarcode().toString();
          String nameComponent = result.getNameComponent().toString();
          String calories = result.getCalories().toString();
          String proteins = result.getProteins().toString();

          print(
              '$barcode, $nameComponent, $calories, $proteins-------------------------------------------');
          Navigator.pop(context, {
            'barcode': barcode,
            'nameComponent': nameComponent,
            'calories': calories,
            'proteins': proteins,
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to add meal'),
              duration: Duration(seconds: 1),
            ),
          );
        }

      } else if (whereDidIComeFrom == 2) {
        try {
          FoodApi result = await foodApiFuture!;
          String mealType = 'Dinner';
          String date = DateTime.now().toString();
          result.date = date;
          result.mealType = mealType;
          await result.insertMeal(database);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Meal added successfully'),
              duration: Duration(seconds: 1),
            ),
          );
          String barcode = result.getBarcode().toString();
          String nameComponent = result.getNameComponent().toString();
          String calories = result.getCalories().toString();
          String proteins = result.getProteins().toString();

          print(
              '$barcode, $nameComponent, $calories, $proteins-------------------------------------------');
          Navigator.pop(context, {
            'barcode': barcode,
            'nameComponent': nameComponent,
            'calories': calories,
            'proteins': proteins,
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to add meal'),
              duration: Duration(seconds: 1),
            ),
          );
        }

      } else if (whereDidIComeFrom == 3) {
        try {
          FoodApi result = await foodApiFuture!;
          String mealType = 'Snacks';
          String date = DateTime.now().toString();
          result.date = date;
          result.mealType = mealType;
          await result.insertMeal(database);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Meal added successfully'),
              duration: Duration(seconds: 1),
            ),
          );
          String barcode = result.getBarcode().toString();
          String nameComponent = result.getNameComponent().toString();
          String calories = result.getCalories().toString();
          String proteins = result.getProteins().toString();

          print(
              '$barcode, $nameComponent, $calories, $proteins-------------------------------------------');
          Navigator.pop(context, {
            'barcode': barcode,
            'nameComponent': nameComponent,
            'calories': calories,
            'proteins': proteins,
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to add meal'),
              duration: Duration(seconds: 1),
            ),
          );
        }

      }
    }
  }

  Future<void> printAllMeals() async {
    List<FoodApi> meals = await FoodApi.getAllMeals(database);
    for (var meal in meals) {
      print('id: ${meal.id}');
      print('Barcode: ${meal.barcode}');
      print('Name Component: ${meal.nameComponent}');
      print('Calories: ${meal.calories}');
      print('Proteins: ${meal.proteins}');
      print('Meal Type: ${meal.mealType}');
      print('Date: ${meal.date}');
      print('---------------------------');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.red[800],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FutureBuilder<FoodApi>(
                    future: foodApiFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        if (kDebugMode) {
                          print('Error: ${snapshot.error}');
                        }
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                  'Name Component: ${snapshot.data!.nameComponent}'),
                              Text(
                                  'Calories pr. 100g: ${(snapshot.data!.calories).toStringAsFixed(2)}'),
                              Text(
                                  'Proteins pr. 100g: ${(snapshot.data!.proteins).toStringAsFixed(2)}'),
                              Text(
                                  'You ate this many calories:  ${(snapshot.data!.calories * int.parse(howMuch) / 100).toStringAsFixed(2)}'),
                              Text(
                                  'You ate this much protein:  ${(snapshot.data!.proteins * int.parse(howMuch) / 100).toStringAsFixed(2)}')
                            ],
                          ),
                        );
                      } else {
                        return const Text(
                            'Enter a barcode and press "Fetch Food"');
                      }
                    }),
                TextField(
                  controller: barcodeController,
                  decoration: const InputDecoration(
                    hintText: 'Enter barcode',
                  ),
                ),
                TextField(
                  controller: howMuchController,
                  decoration: const InputDecoration(
                    hintText: 'how many grams',
                  ),
                ),
                const SizedBox(height: 10.0),
                // Adding some spacing between text field and button
                ElevatedButton(
                  onPressed: () {
                    bool validNumbers = true;
                    // Check if they both can be parsed to int
                    try {
                      int.parse(barcodeController.text);
                      int.parse(howMuchController.text);
                    } catch (e) {
                      validNumbers = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Please enter a valid barcode and/or how much you ate'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                    if (validNumbers &&
                        barcodeController.text.isNotEmpty &&
                        howMuchController.text.isNotEmpty) {
                      setState(() {
                        foodApiFuture = fetchFood(barcodeController.text);
                        if (kDebugMode) {
                          print(howMuchController.text.runtimeType);
                        }
                        howMuch = howMuchController.text;
                        barcodeController.clear();
                        howMuchController.clear();
                      });
                    } else if (barcodeController.text.isEmpty ||
                        howMuchController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Please enter a barcode and/or how much you ate'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red[800],
                  ),
                  child: const Text('Fetch Food'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    var res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SimpleBarcodeScannerPage(),
                        ));
                    setState(() {
                      if (res is String) {
                        var result = res;
                        print(result);
                        barcodeController.text = result;
                      }
                    });
                  },
                  child: const Text('Open Scanner'),
                ),
                ElevatedButton(
                  onPressed: addMeal,
                  child: const Text('Add Meal'),
                ),
                ElevatedButton(
                  onPressed: printAllMeals,
                  child: const Text('Print All Meals'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    barcodeController.dispose();
    howMuchController.dispose();
    super.dispose();
  }
}
