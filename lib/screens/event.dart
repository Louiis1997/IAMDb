import 'package:flutter/material.dart';

class Event extends StatelessWidget {
  const Event({Key? key}) : super(key: key);

  static const String routeName = '/event';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
