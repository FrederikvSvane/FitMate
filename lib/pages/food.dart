import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../classes/FoodApi.dart';

class Food extends StatefulWidget {
  const Food({super.key});

  @override
  FoodState createState() => FoodState();
}

class FoodState extends State<Food> {
  final barcodeController = TextEditingController();
  final howMuchController = TextEditingController();
  String howMuch = '';
  Future<FoodApi>? foodApiFuture;



  Future<FoodApi> fetchFood(String barcode) {
    try {
      var barcodeInt = int.parse(barcode);
      return FoodApi.fetchFoodApi(barcodeInt);
    } catch (e) {
      throw ArgumentError('Invalid barcode: $barcode');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: FutureBuilder<FoodApi>(
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
                              Text('Name Component: ${snapshot.data!.nameComponent}'),
                              Text('Calories pr. 100g: ${snapshot.data!.calories}'),
                              Text('Proteins pr. 100g: ${snapshot.data!.proteins}'),
                              Text('You ate this many calories:  ${snapshot.data!.calories * int.parse(howMuch) / 100}'),
                              Text('You ate this much protein:  ${snapshot.data!.proteins * int.parse(howMuch) / 100}')
                            ],
                          ),
                        );
                    } else {
                      return const Text('Enter a barcode and press "Fetch Food"');
                    }
                  }
              ),
            ),
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
            const SizedBox(height: 10.0), // Adding some spacing between text field and button
            ElevatedButton(
              onPressed: () {
                if (barcodeController.text.isNotEmpty) {
                  setState(() {
                    foodApiFuture = fetchFood(barcodeController.text);
                    howMuch = howMuchController.text;
                    barcodeController.clear();
                    howMuchController.clear();

                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a barcode.'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red[800],),
              child: const Text('Fetch Food'),
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
