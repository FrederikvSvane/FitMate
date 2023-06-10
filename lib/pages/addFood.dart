
import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/pages/food.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../DB/DBHelper.dart';
import '../classes/FoodApi.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  AddFoodState createState() => AddFoodState();
}

class AddFoodState extends State<AddFood> {
  final barcodeController = TextEditingController();
  final howMuchController = TextEditingController();
  final nameController = TextEditingController();
  final caloriesController = TextEditingController();
  final proteinsController = TextEditingController();
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

  String mealType = '';

  Future<void> addMeal() async {
    // Make a switch statement here to check where the user came from
    // 0 = breakfast, 1 = lunch, 2 = dinner, 3 = snacks
    switch (whereDidIComeFrom) {
      case 0:
        mealType = 'Breakfast';
        break;
      case 1:
        mealType = 'Lunch';
        break;
      case 2:
        mealType = 'Dinner';
        break;
      case 3:
        mealType = 'Snacks';
        break;
      default:
        mealType = 'null';
    }

    try {
      String date = DateTime.now().toString();

      Map<String, dynamic> mealData = {
        'barcode': barcodeController.text,
        'nameComponent': nameController.text ,
        'calories': caloriesController.text,
        'proteins': proteinsController.text,
        'mealType': mealType,
        'date': date,
      };

      await DBHelper.insertMeal(mealData);



      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Meal added successfully'),
          duration: Duration(seconds: 1),
        ),
      );
      Navigator.pop(context, {
        'barcode': int.tryParse(barcodeController.text) ?? 0,
        'nameComponent': nameController.text,
        'calories': double.tryParse(caloriesController.text) ?? 0.0,
        'proteins': double.tryParse(proteinsController.text) ?? 0.0,
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add meal'),
          duration: Duration(seconds: 1),
        ),
      );
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Name:"),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter name',
                      ),
                    ),
                    const Text("Calories:"),
                    TextField(
                      controller: caloriesController,
                      decoration: const InputDecoration(
                        hintText: 'Enter calories',
                      ),
                    ),
                    const Text("Proteins:"),
                    TextField(
                      controller: proteinsController,
                      decoration: const InputDecoration(
                        hintText: 'Enter proteins',
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(40.0)),
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
                        howMuch = howMuchController.text;

                        foodApiFuture!.then((foodApi) async {
                          nameController.text = foodApi.nameComponent;
                          double caloriesPerGram = (await foodApiFuture)?.calories.toDouble() ?? 0.0;
                          double proteinsPerGram = (await foodApiFuture)?.proteins.toDouble() ?? 0.0;
                          double totalCalories = caloriesPerGram * double.parse(howMuch) / 100;
                          double totalProteins = proteinsPerGram * double.parse(howMuch) / 100;
                          caloriesController.text = totalCalories.toStringAsFixed(2);
                          proteinsController.text = totalProteins.toStringAsFixed(2);

                        });
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