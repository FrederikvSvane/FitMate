import 'package:flutter/foundation.dart';
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
  Future<FoodApi>? foodApiFuture;

  void init() {
    super.initState();
    howMuchController.text = '100';
  }

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
    // Check if all fields are filled in and they are numbers
    if (nameController.text.isEmpty ||
        double.tryParse(caloriesController.text) == null ||
        double.tryParse(proteinsController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in the fields with numbers'),
        ),
      );
      return;
    }

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
      DateTime date = selectedDate;

      Map<String, dynamic> mealData = {
        'barcode': barcodeController.text,
        'nameComponent': nameController.text,
        'calories': ((double.tryParse(caloriesController.text) ?? 0.0) *
                num.parse(howMuchController.text) /
                100)
            .toStringAsFixed(2),
        'proteins': ((double.tryParse(proteinsController.text) ?? 0.0) *
                num.parse(howMuchController.text) /
                100)
            .toStringAsFixed(2),
        'mealType': mealType,
        'date': date.toString(),
      };

      DBHelper.insertMeal(mealData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Meal added successfully'),
          duration: Duration(seconds: 1),
        ),
      );

      final localContext = context;
      Navigator.pop(localContext, {
        'nameComponent': nameController.text});
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
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
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Name:"),
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
                          const Text("How much did you eat? (in grams)"),
                          TextField(
                            controller: howMuchController,
                            decoration: const InputDecoration(
                              hintText: 'how many grams',
                            ),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.all(20.0)),
                      TextField(
                        controller: barcodeController,
                        decoration: const InputDecoration(
                          hintText: 'Enter barcode',
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  bool validNumbers = true;
                                  // Check if they both can be parsed to int
                                  try {
                                    int.parse(barcodeController.text);
                                  } catch (e) {
                                    validNumbers = false;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Please enter a valid barcode number'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                  if (validNumbers &&
                                      barcodeController.text.isNotEmpty) {
                                    setState(() {
                                      foodApiFuture =
                                          fetchFood(barcodeController.text);

                                      foodApiFuture!.then((foodApi) async {
                                        double caloriesPerGram =
                                            foodApi.calories.toDouble();
                                        double proteinsPerGram =
                                            foodApi.proteins.toDouble();

                                        if (mounted) {
                                          setState(() {
                                            nameController.text =
                                                foodApi.nameComponent;
                                            caloriesController.text =
                                                caloriesPerGram
                                                    .toStringAsFixed(2);
                                            proteinsController.text =
                                                proteinsPerGram
                                                    .toStringAsFixed(2);
                                          });
                                        }
                                      });
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.red[800],
                                ),
                                icon: const Icon(
                                  Icons.download_sharp,
                                  color: Colors.white,
                                ),
                                label: const Text('Fetch Food'),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: ElevatedButton.icon(
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
                                      if (result != '-1') {
                                        result = res.substring(0, 13);
                                      }
                                    }
                                  });
                                },
                                icon: const Icon(
                                  Icons.qr_code_scanner,
                                  color: Colors.white,
                                ),
                                label: const Text('Open Scanner'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (MediaQuery.of(context).viewInsets.bottom == 0)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FloatingActionButton(
                      heroTag: 'favMealButton',
                      onPressed: () async {
                        var result = await Navigator.pushNamed(
                            context, "/addFavoriteMeal");
                      },
                      backgroundColor: Colors.red[800],
                      tooltip: 'Use favorite meals',
                      child: const Icon(Icons.favorite),
                    ),
                    FloatingActionButton(
                      heroTag: 'AddMealButton',
                      onPressed: () {
                        addMeal();
                      },
                      backgroundColor: Colors.red[800],
                      tooltip: 'Add Meal',
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
          ],
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
