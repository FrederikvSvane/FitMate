import 'package:flutter/material.dart';
import 'package:sliding_switch/sliding_switch.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final List<String> workouts =
  [ 'Workout 1',
    'Workout 2',
    'Workout 3',
    'Workout 4',
    'Workout 5',
    'Workout 6',
    'Workout 7',
    'Workout 8',
    'Workout 9',
    'Workout 10',
    'Workout 11',
    'Workout 12',
    'Workout 13',
    'Workout 14',
    'Workout 15',
    'Workout 16',
    'Workout 17',
    'Workout 18',
    'Workout 19',
    'Workout 20'];

  final List<String> meals =
  [ 'Meal 1',
    'Meal 2',
    'Meal 3',
    'Meal 4',
    'Meal 5',
    'Meal 6',
    'Meal 7',
    'Meal 8',
    'Meal 9',
    'Meal 10',
    'Meal 11',
    'Meal 12',
    'Meal 13',
    'Meal 14',
    'Meal 15',
    'Meal 16',
    'Meal 17',
    'Meal 18',
    'Meal 19',
    'Meal 20'];
  List <String> current = [];


  @override
  Widget build(BuildContext context) {
    return MaterialApp (

    title: 'Flutter demo',
        home: Scaffold(
    body: Column (
    children: [
      Expanded(
        flex: 6,
        child: Container(
          color: Colors.red[800],
          padding: EdgeInsets.fromLTRB(20, 70, 20, 20),
          child: Stack(
            children: [
            Align(
            alignment: Alignment.topLeft,
            child:
              Padding(padding: EdgeInsets.all(16),
                child:
                GestureDetector(
                  onTap: () {
                    // Handle the tap event
                    print('Text Pressed2');
                  },
                  child: const Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),

              const Align(
                alignment: Alignment.topCenter,
                child:
                Padding(padding: EdgeInsets.all(16),
                  child: Text(
                    "Profile",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child:
                Padding(padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                  child: Text(
                    "Din mor",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.bottomLeft,
                child:
                Padding(padding: EdgeInsets.all(10),
                  child: Text(
                    "Weight: " "220 kg",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.bottomRight,
                child:
                Padding(padding: EdgeInsets.all(10),
                  child: Text(
                    "Steps today: " "5302",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
    ],
        ),
    )
    ),
     Expanded(
         flex: 2,
         child:
         Padding(padding: EdgeInsets.all(20),
         child:
         SlidingSwitch(

           onDoubleTap: () {},
           onSwipe: () {},
           onTap: (){},
           value: false,
           height: 100,
           width: 350,

           textOff : "Workouts",
           textOn : "Meals",
           onChanged: (bool value) {
             setState(() {
               if (value) {
                 current = meals;
               }
               else {
                 current = workouts;
               }
             });

           },
           colorOn : Colors.red,
           colorOff :   Colors.red,
           background : const Color(0xFFEEEEEE),
           buttonColor : Colors.white70,
           inactiveColor : Colors.grey,
           contentSize: 20,
         ),

     ),
     ),

      Expanded (
        flex: 12,
        child: ListView.builder(
          shrinkWrap: true,
        itemCount: current.length,
          itemBuilder: (context,index) {
          return ListTile (
            title: Text(current[index]),
          );
          }


        ),
        ),
  ],
    ),
    ),
    );



}

}