import 'package:flutter/material.dart';

import '../screens/search.dart';
import 'agenda.dart';
import 'feed.dart';
import 'profile.dart';
import 'events/events.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static const String routeName = '/home';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  int _currentScreen = 0;

  final List<Widget> _screens = [
    const Feed(),
    const Agenda(),
    const Events(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/iamdb-logo.png',
          fit: BoxFit.contain,
          height: 64,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Search.navigateTo(context);
            },
          ),
        ],
      ),
      body: _screens[_currentScreen],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _currentScreen,
        onTap: _onTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(_currentScreen == 0 ? Icons.home : Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(_currentScreen == 1
                ? Icons.calendar_month
                : Icons.calendar_today_outlined),
            label: "Agenda",
          ),
          BottomNavigationBarItem(
            icon:
                Icon(_currentScreen == 2 ? Icons.place : Icons.place_outlined),
            label: "Events",
          ),
          BottomNavigationBarItem(
            icon: Icon(_currentScreen == 3
                ? Icons.person_rounded
                : Icons.person_outline_rounded),
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
