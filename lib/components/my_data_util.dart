import 'package:flutter/material.dart';

class MyDateUtil {
  // For formatted date
  static String getFormattedTime({
    required BuildContext context,
    required String? time,
  }) {
    try {
      if (time == null || time.isEmpty) {
        return "Invalid time"; // Handle null or empty time string
      }

      final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
      return TimeOfDay.fromDateTime(date).format(context);
    } catch (e) {
      // Handle any error that occurs during parsing
      return "Invalid time";
    }
  }
}
