import 'package:flutter/material.dart';



class Food extends StatefulWidget {
  const Food({super.key});

  @override
  State<Food> createState() => _FoodState();
}
int? whereDidIComeFrom;

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
                    whereDidIComeFrom = 0;

                  },
                  child: const Text("Add breakfast")),

            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/addFood");
                  whereDidIComeFrom = 1;

                },
                child: const Text("Add Lunch")),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/addFood");
                  whereDidIComeFrom = 2;

                },
                child: const Text("Add Dinner")),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/addFood");
                  whereDidIComeFrom = 3;

                },
                child: const Text("Add Snacks")),
          ],
        ),
      ),
    );
  }
}
