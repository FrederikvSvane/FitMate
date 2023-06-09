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
        flex: 2,
        child: Container(
          color: Colors.red[800],
          padding: EdgeInsets.fromLTRB(20, 70, 20, 20),
          child: const Stack(
            children: [
            Align(
            alignment: Alignment.topLeft,
            child:
              Padding(padding: EdgeInsets.all(16),
            child: Text(
            "settings",
            style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500),
                ),
              ),
            ),

              Align(
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
              Align(
                alignment: Alignment.center,
                child:
                Padding(padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                  child: Text(
                    "Gg ez",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Align(
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
              Align(
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
    flex: 5,
    child: Container(
    color: Colors.white
    ),
    ),
          ],
    ),
    ),
    );


}

}