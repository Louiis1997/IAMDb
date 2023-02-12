import 'package:flutter/material.dart';

enum MessageType { error, success, warning, info }

const getColorFromMessageType = {
  MessageType.info: Color.fromRGBO(0, 0, 0, 0.5),
  MessageType.error: Colors.red,
  MessageType.success: Colors.green,
  MessageType.warning: Colors.orange,
};

class Utils {
  static void displaySnackBar({
    required BuildContext context,
    required String message,
    MessageType messageType = MessageType.info,
  }) {
    // Add prefix icon
    final icon = Icon(
      messageType == MessageType.error
          ? Icons.error
          : messageType == MessageType.success
              ? Icons.check
              : messageType == MessageType.warning
                  ? Icons.warning
                  : Icons.info,
      color: Colors.white,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            icon,
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: getColorFromMessageType[messageType],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        closeIconColor: Colors.white,
        showCloseIcon: true,
        duration: Duration(seconds: message.length ~/ 10),
        elevation: 10,
      ),
    );
  }

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
