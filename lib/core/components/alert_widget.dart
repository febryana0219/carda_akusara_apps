import 'package:flutter/material.dart';

class AlertWidget {
  showAlertSingleButton(BuildContext context, {String? title, String? msg}) {
    Widget noButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        title ?? '',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        msg!,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      actions: [
        noButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
