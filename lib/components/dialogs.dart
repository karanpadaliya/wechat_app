import 'dart:ui';

import 'package:flutter/material.dart';

class Dialogs {
  Color color = Colors.black;
  // SnackBar
  static void showSnackbar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message),backgroundColor: color,));
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
