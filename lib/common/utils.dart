import 'package:flutter/material.dart';

class Utils {
  static void displayAlertDialog(
      BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void displayAlertDialogWithPopUp(
      BuildContext contextParent, String title, String content) {
    showDialog(
      context: contextParent,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(contextParent).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void displayAlertDialogChoices({
    required BuildContext context,
    required String title,
    required String question,
    required Widget cancelBtn,
    required Widget confirmBtn,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(question),
          actions: [
            cancelBtn,
            confirmBtn,
          ],
        );
      },
    );
  }
}
