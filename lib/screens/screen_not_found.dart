import 'package:flutter/material.dart';

class ScreenNotFound extends StatefulWidget {
  const ScreenNotFound({Key? key}) : super(key: key);

  @override
  State<ScreenNotFound> createState() => _ScreenNotFoundState();
}

class _ScreenNotFoundState extends State<ScreenNotFound> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'not found',
        ),
      ),
    );
  }
}
