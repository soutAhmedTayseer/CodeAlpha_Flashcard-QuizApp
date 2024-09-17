import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class NavigationButtons extends StatelessWidget {
  final int currentQuestionIndex;
  final int totalQuestions;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  const NavigationButtons({
    required this.currentQuestionIndex,
    required this.totalQuestions,
    required this.onPrevious,
    required this.onNext,
    required this.onSubmit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentQuestionIndex > 0)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onPrevious,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.grey[800],
                      ),
                      child: const Text('Previous').tr(),
                    ),
                  ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: currentQuestionIndex < totalQuestions - 1 ? onNext : onSubmit,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: currentQuestionIndex < totalQuestions - 1
                          ? Colors.grey[800]
                          : Colors.green,
                    ),
                    child: Text(
                      currentQuestionIndex < totalQuestions - 1 ? 'Next' : 'Submit',
                    ).tr(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
