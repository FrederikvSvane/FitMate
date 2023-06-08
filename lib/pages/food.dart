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
  Future<FoodApi>? foodApiFuture;

  Future<FoodApi> fetchFood(String barcode) {
    if (barcode.isEmpty) {
      throw ArgumentError('Please enter a barcode');
    }

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
                              Text('Calories: ${snapshot.data!.calories}'),
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
            const SizedBox(height: 10.0), // Adding some spacing between text field and button
            ElevatedButton(
              onPressed: () {
                if (barcodeController.text.isNotEmpty) {
                  setState(() {
                    foodApiFuture = fetchFood(barcodeController.text);
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a barcode.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
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
    super.dispose();
  }
}
