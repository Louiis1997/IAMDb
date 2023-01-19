import 'package:flutter/material.dart';

class Agenda extends StatefulWidget {
  final String userId;
  const Agenda({Key? key, required this.userId}) : super(key: key);

  static const String routeName = '/agenda';

  static void navigateTo(BuildContext context, String id) {
    Navigator.of(context).pushNamed(routeName, arguments: id);
  }

  @override
  State<Agenda> createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
