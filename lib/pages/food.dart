import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../classes/FoodApi.dart';
import '../main.dart';

class Food extends StatefulWidget {
  const Food({super.key});

  @override
  State<Food> createState() => _FoodState();
}

class _FoodState extends State<Food> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/addFood");

                    //SKriv mere her hehheh


                  },
                  child: const Text("Add breakfast")),
            ),
          ],
        ),
      ),
    );
  }
}
