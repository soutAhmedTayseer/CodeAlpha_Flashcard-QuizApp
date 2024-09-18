import 'package:flutter/material.dart';

Color getScoreColor(double percentage) {
  if (percentage >= 80) {
    return Colors.green;
  } else if (percentage >= 50) {
    return Colors.orange;
  } else {
    return Colors.red;
  }
}
