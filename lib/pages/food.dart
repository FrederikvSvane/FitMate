import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import '../classes/FoodApi.dart';

class Food extends StatefulWidget {
  const Food({super.key});

  @override
  FoodState createState() => FoodState();
}

class FoodState extends State<Food> {
  final barcodeController = TextEditingController();
  final howMuchController = TextEditingController();
  String howMuch = '100';
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
                bool validNumbers = true;
                // Check if they both can be parsed to int
                try {
                  int.parse(barcodeController.text);
                  int.parse(howMuchController.text);
                } catch (e) {
                  validNumbers = false;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid barcode and/or how much you ate'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
                if (validNumbers && barcodeController.text.isNotEmpty && howMuchController.text.isNotEmpty) {
                  setState(() {
                    foodApiFuture = fetchFood(barcodeController.text);
                    if (kDebugMode) {
                      print(howMuchController.text.runtimeType);
                    }
                    howMuch = howMuchController.text;
                    barcodeController.clear();
                    howMuchController.clear();
                  });
                } else if (barcodeController.text.isEmpty || howMuchController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a barcode and/or how much you ate'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red[800],),
              child: const Text('Fetch Food'),
            ),
            ElevatedButton(
              onPressed: () async {
                var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleBarcodeScannerPage(),
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
            )
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
