import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'food.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter demo',
      home: Scaffold(
          body: Column(children: [
            Container(
              height: 200,
              color: Colors.red[800],
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      color: Colors.white,
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
                          setState(() {});
                        }
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Nutrition',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.arrow_back_ios_new),
                          onPressed: () async {},
                        ),
                        Text(
                          DateFormat('EEEE, MMMM d, y').format(selectedDate),
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.arrow_forward_ios),
                          onPressed: () async {},
                        ),
                      ],
                    ),
                  ),
                  const Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Protein: 140 grams',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,

                            ),),
                          Text('Calories: 2340',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)
                          ),
                        ],
                      ))
                ],
              ),
            ),
            const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('123'),
                        Text('123')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('123'),
                        Text('123')
                      ],
                    ),

                  ],
                )
            ),
          ],
          )
      ),
    );
  }
  Widget addFood(String meal) {
    return ElevatedButton(
      onPressed: () async {
        whereDidIComeFrom = 1;
        var result =
        await Navigator.pushNamed(context, "/addFood");
        Map<String, dynamic> mealData =
        result as Map<String, dynamic>;
        if (mealData['id'] != null &&
            mealData['nameComponent'] != null &&
            mealData['calories'] != null &&
            mealData['proteins'] != null &&
            mealData['mealType'] != null &&
            mealData['date'] != null) {
          setState(() {
            if (meal == 'breakfast') {
              breakfastMeals.add({
                'id': mealData['id'],
                'nameComponent': mealData['nameComponent'],
                'calories': mealData['calories'],
                'proteins': mealData['proteins'],
                'mealType': mealData['mealType'],
                'date': mealData['date'],
              });
            }
          });
        }

        loadMealsFromDatabase();
      },
      child: const Text("Add breakfast"),
    );
  }

  Widget foodList(String meal) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          const Text('Breakfast:',
              style:
              TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Column(
            children: breakfastMeals.map((meal) {
              String mealDetails =
                  'Name: ${meal['nameComponent']}\nCalories: ${meal['calories']}\nProteins: ${meal['proteins']}';
              int mealId = meal['id'];
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(mealDetails),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _showDeleteConfirmationDialog(
                          mealId, 'Breakfast');
                    },
                  )
                ],
              );
            }
            ).toList(),

          ),
          const SizedBox(

            width: 120.0,

          )
        ]
    );
  }
}
