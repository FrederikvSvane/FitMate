import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_switch/sliding_switch.dart';

import '../DB/DBHelper.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  HistoryState createState() => HistoryState();
}

class HistoryState extends State<History> {
  @override
  initState() {
    super.initState();
    getPrefs();
  }

  bool darkMode = false;

  bool gender = false;

  late SharedPreferences prefs;

  void getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      gender = prefs.getBool('gender') ?? false;
    });
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController activityLevelController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Column(children: [
          Container(
              height: 120,
              color: Colors.red[800],
              child: const Stack(children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Settings",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ])),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Personal information',
                style: TextStyle(
                    color: Color.fromARGB(255, 150, 0, 0),
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      alignment: Alignment.center,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      title: const Text('Update your name'),
                      content: SizedBox(
                        child: TextField(
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: 'Enter your new name',
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              prefs.setString("name", nameController.text);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Update name')),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('return'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                width: double.infinity,
                height: 50,
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Edit your name",
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              )),
          GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      alignment: Alignment.center,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      title: const Text('Update your age'),
                      content: SizedBox(
                        child: TextField(
                          controller: ageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Enter your new age',
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              prefs.setInt(
                                  "age", int.tryParse(ageController.text)!);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Update age')),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('return'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                width: double.infinity,
                height: 50,
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Edit your age",
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              )),
          GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      alignment: Alignment.center,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      title: const Text('Update your height'),
                      content: const SizedBox(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter your new height',
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              prefs.setString("height", heightController.text);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Update height')),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('return'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                width: double.infinity,
                height: 50,
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Edit your height",
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              )),
          GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      alignment: Alignment.center,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      title:
                          const Text('Update weight measurement on the date'),
                      content: SizedBox(
                        child: TextField(
                          controller: weightController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Enter your new weight',
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              DateTime now = DateTime.now();
                              DateTime dateOnly =
                                  DateTime(now.year, now.month, now.day);

                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(dateOnly);

                              DBHelper.insertWeight(
                                  double.tryParse(weightController.text)!,
                                  formattedDate);
                              prefs.setDouble("weight",
                                  double.tryParse(weightController.text)!);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Update weight')),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('return'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                width: double.infinity,
                height: 50,
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Edit your weight data",
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              )),
          GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      alignment: Alignment.center,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      title: const Text('Choose current activity level'),
                      content: SizedBox(
                        child: TextField(
                          controller: activityLevelController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Choose one of three levels',
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              int text =
                                  int.tryParse(activityLevelController.text)!;
                              if (text == 1 && text == 2 && text == 3) {
                                prefs.setInt(
                                    "activityLevel",
                                    int.tryParse(
                                        activityLevelController.text)!);
                              }
                              Navigator.of(context).pop();
                            },
                            child: const Text('Update activity level')),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('return'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                width: double.infinity,
                height: 50,
                color: Colors.grey[100],
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Change your activity level",
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      const Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              )),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    alignment: Alignment.center,
                    title: const Text('Update your gender'),
                    content: SizedBox(
                      child: SlidingSwitch(
                        value: gender,
                        onChanged: (bool value) {
                          gender = value;
                        },
                        onTap: () {},
                        onDoubleTap: () {},
                        onSwipe: () {},
                        textOff: 'Male',
                        textOn: 'Female',
                        colorOn: const Color(0xFFC62828),
                        colorOff: const Color(0xFFC62828),
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            prefs.setBool('gender', gender);
                            Navigator.of(context).pop();
                          },
                          child: const Text('Update gender')),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('return'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              width: double.infinity,
              height: 50,
              color: Colors.grey[100],
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Change your gender",
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      const Icon(Icons.arrow_forward_ios),
                    ],
                  )),
            ),
          ),
          // const Align(
          //   alignment: Alignment.centerLeft,
          //   child: Padding(
          //     padding: EdgeInsets.all(10),
          //     child: Text(
          //       'Appearance',
          //       style: TextStyle(
          //           color: Color.fromARGB(255, 150, 0, 0),
          //           fontSize: 20,
          //           fontWeight: FontWeight.w400),
          //     ),
          //   ),
          // ),
          // Container(
          //   width: double.infinity,
          //   height: 50,
          //   color: Colors.grey[100],
          //   child: Padding(
          //     padding: EdgeInsets.all(10),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text(
          //           "Enable dark mode",
          //           style: TextStyle(
          //               color: Colors.grey[800],
          //               fontSize: 18,
          //               fontWeight: FontWeight.w400),
          //         ),
          //         FlutterSwitch(
          //           activeColor: const Color(0xFFC62828),
          //           inactiveColor: const Color(0xFFD6D6D6),
          //           height: 40,
          //           width: 60,
          //           value: darkMode,
          //           showOnOff: false,
          //           onToggle: (val) {
          //             setState(() {
          //               darkMode = val;
          //             });
          //           },
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // GestureDetector(
          //     onTap: () {
          //       showDialog(
          //         context: context,
          //         builder: (BuildContext context) {
          //           return AlertDialog(
          //             alignment: Alignment.center,
          //             shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(15)),
          //             title: const Text('You cannot'),
          //             content: const SizedBox(
          //                 child: Icon(
          //               Icons.do_disturb,
          //               size: 100,
          //               color: Colors.red,
          //             )),
          //             actions: [
          //               TextButton(
          //                   onPressed: () {
          //                     Navigator.of(context).pop();
          //                   },
          //                   child: const Text('Choose a colorscheme')),
          //               TextButton(
          //                 onPressed: () {
          //                   Navigator.of(context).pop();
          //                 },
          //                 child: const Text('return'),
          //               ),
          //             ],
          //           );
          //         },
          //       );
          //     },
          //     child: Container(
          //       width: double.infinity,
          //       height: 50,
          //       color: Colors.grey[100],
          //       child: Padding(
          //         padding: const EdgeInsets.all(10),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Text(
          //               "Choose colour-scheme",
          //               style: TextStyle(
          //                   color: Colors.grey[800],
          //                   fontSize: 18,
          //                   fontWeight: FontWeight.w400),
          //             ),
          //             const Icon(Icons.arrow_forward_ios)
          //           ],
          //         ),
          //       ),
          //     )),
        ]));
  }
}
