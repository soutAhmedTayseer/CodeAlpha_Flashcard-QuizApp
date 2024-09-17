import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final Widget child;

  const ResultCard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[800],
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}
