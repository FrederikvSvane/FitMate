import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container (
        color: Colors.red[800],
        child: Stack(
          children: [
            Positioned.fill(
        child: Opacity (
          opacity: 0.2,
                child: Image.asset('assets/image/Front page 2.png',
                fit: BoxFit.cover)
        )
            )
          ],
        )
      )
    );
  }
}
