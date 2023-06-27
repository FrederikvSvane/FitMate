import 'package:flutter/material.dart';
import 'package:flutter_fitness_app/pages/food.dart';
import 'package:flutter_fitness_app/pages/measure.dart';
import 'package:flutter_fitness_app/pages/profile.dart';
import 'package:flutter_fitness_app/pages/settings.dart';
import 'package:flutter_fitness_app/pages/workout.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int selectedIndex = 2;
  static final List<Widget> _widgetOptions = <Widget>[
    const History(),
    Workout(),
    const Profile(),
    const Food(),
    const Measure(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Food',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Measure',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.primary,
        selectedIconTheme: IconThemeData(color: theme.colorScheme.primary),
        unselectedIconTheme: IconThemeData(color: theme.colorScheme.primary),
        onTap: _onItemTapped,
      ),
    );
  }
}

