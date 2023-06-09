import 'package:flutter/material.dart';

class Profile extends StatelessWidget {

  String userName = 'Jesper';

  @override
  Widget build(BuildContext context) {
    return MaterialApp (

    title: 'Flutter demo',
        home: Scaffold(
    body: Column (
    children: [
      Expanded(
        flex: 1,
        child: Container(
          color: Colors.red[800],

        ),
      ),
      Expanded(
        flex: 1,
          child: Container(
      color: Colors.white,
      ),
      ),
      ]
    ),
    )
    );



  }
}
