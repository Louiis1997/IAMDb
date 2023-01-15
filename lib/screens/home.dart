import 'package:flutter/material.dart';

import 'agenda.dart';
import 'feed.dart';
import 'profile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  int _currentScreen = 0;

  final List<Widget> _screens = [
    const Feed(),
    const Agenda(userId: ""),
    const Profile(userId: ""),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentScreen],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentScreen,
        onTap: _onTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(_currentScreen == 0 ? Icons.home : Icons.home_outlined),
            label: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.all_inbox_rounded),
            label: "Agenda",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_pin_outlined),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  void _onTap(int newIndex) {
    setState(() {
      _currentScreen = newIndex;
    });
  }
}
