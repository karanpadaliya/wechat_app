import 'package:flutter/material.dart';

class Dialogs {
  // SnackBar
  static void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Progress indicatore
  static void showProgressBar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(color: Colors.blue),
      ),
    );
  }
}
