import 'package:flutter/material.dart';

import '../classes/FoodApi.dart';
import '../main.dart';


class Food extends StatefulWidget {
  const Food({super.key});

  @override
  State<Food> createState() => _FoodState();
}
int? whereDidIComeFrom;

class _FoodState extends State<Food> {
  TextEditingController breakfastController = TextEditingController();
  TextEditingController lunchController = TextEditingController();
  TextEditingController dinnerController = TextEditingController();
  TextEditingController snacksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      whereDidIComeFrom = 0;
                      dynamic text = await Navigator.pushNamed(context, "/addFood");
                      List<String> list = ['barcode: ${text["barcode"]}, name: ${text["nameComponent"]}, Calories: ${text["calories"]}, proteins: ${text["proteins"]}'];
                      setState(() {
                        breakfastController.text = list.toString();
                      });
                    },
                    child: const Text("Add breakfast"),
                  ),
                  TextField(
                    controller: breakfastController,
                    enabled: false,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    whereDidIComeFrom = 1;
                    dynamic text = await Navigator.pushNamed(context, "/addFood");
                    List<String> list = [text["barcode"], text["nameComponent"], text["calories"], text["proteins"]];
                    setState(() {
                      lunchController.text = list.toString();
                    });
                  },
                  child: const Text("Add Lunch"),
                ),
                TextField(
                  controller: lunchController,
                  enabled: false,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    whereDidIComeFrom = 2;
                    dynamic text = await Navigator.pushNamed(context, "/addFood");
                    List<String> list = [text["barcode"], text["nameComponent"], text["calories"], text["proteins"]];
                    setState(() {
                      dinnerController.text = list.toString();
                    });
                  },
                  child: const Text("Add Dinner"),
                ),
                TextField(
                  controller: dinnerController,
                  enabled: false,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    whereDidIComeFrom = 3;
                    dynamic text = await Navigator.pushNamed(context, "/addFood");
                    List<String> list = [text["barcode"], text["nameComponent"], text["calories"], text["proteins"]];
                    setState(() {
                      snacksController.text = list.toString();
                    });
                  },
                  child: const Text("Add Snacks"),
                ),
                TextField(
                  controller: snacksController,
                  enabled: false,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




