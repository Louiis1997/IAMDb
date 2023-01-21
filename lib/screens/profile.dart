import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final String userId;
  const Profile({Key? key, required this.userId}) : super(key: key);

  static const String routeName = '/profile';

  static void navigateTo(BuildContext context, String id) {
    Navigator.of(context).pushNamed(routeName, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
