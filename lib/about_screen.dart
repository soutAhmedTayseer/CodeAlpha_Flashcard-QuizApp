import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // Method to launch a URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align text to the start
            children: <Widget>[
              Text(
                'About This App'.tr(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Main Goal:'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome to the Quiz App! Our app is designed to help you study effectively by creating and managing flashcards. You can add flashcards with questions and answers, and quiz yourself to reinforce your learning. The app tracks your quiz scores to help you monitor your progress.'
                    .tr(),
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(
                'Advanced Features:'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Beyond basic flashcard functionality, the app offers advanced features such as creating quizzes from lists and utilizing APIs for enhanced data management. You can also explore different categories with new questions each time you quiz yourself, ensuring a fresh and engaging study experience.'
                    .tr(),
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                'The app also supports language swapping between Arabic and English, as well as a dark and light mode to suit your preferences. The simple and user-friendly interface makes it easy to navigate and customize your study sessions.'
                    .tr(),
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(
                'Version'.tr(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '1.0.0'.tr(),
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(
                'Credits'.tr(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Developed by Ahmed Tayseer\nUndergraduate Software Developer'
                    .tr(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Text(
                'Contact Us'.tr(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'For any questions, feedback, or support, please reach out to us at:\nahmedtayseer424@gmail.com'
                    .tr(),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
