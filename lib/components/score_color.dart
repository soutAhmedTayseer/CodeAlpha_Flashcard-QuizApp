import 'package:flutter/material.dart';

// Helper function to get score color based on percentage
Color getScoreColor(double percentage) {
  if (percentage >= 80) {
    return Colors.green;
  } else if (percentage >= 50) {
    return Colors.orange;
  } else {
    return Colors.red;
  }
}
