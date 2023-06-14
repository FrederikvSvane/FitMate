import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'food.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History>{
  @override
  initState() {
    super.initState();
  }

  
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter demo',
        home: Scaffold(
          body: Column(
            children:  [
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
                padding: EdgeInsets.only(top:15),
                  child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Nutrition',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                ),
                ),

                Align(
                  alignment: Alignment.center,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                     "123",
                     style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),

                      Text(
                      DateFormat('EEEE, MMMM d, y').format(selectedDate),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                  ),

              const Text(
                "123",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              ],
            ),
                ),
          ],
            )
              ),
            ]
    )
        )
    );
  }

}
