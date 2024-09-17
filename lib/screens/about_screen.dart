import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

// Widget for displaying a section title
class SectionTitle extends StatelessWidget {
  final String title;
  final double fontSize;

  const SectionTitle({super.key, required this.title, this.fontSize = 24});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.tr(),
      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
    );
  }
}

// Widget for displaying normal section text
class SectionText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;

  const SectionText({
    super.key,
    required this.text,
    this.color = Colors.grey,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text.tr(),
      style: TextStyle(fontSize: fontSize, color: color),
    );
  }
}

// Widget for Version Info section
class VersionInfo extends StatelessWidget {
  const VersionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionTitle(title: 'Version'),
        SizedBox(height: 8),
        SectionText(text: '1.0.0', fontSize: 16),
      ],
    );
  }
}

// Widget for Credits section
class CreditsSection extends StatelessWidget {
  const CreditsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionTitle(title: 'Credits'),
        SizedBox(height: 16),
        SectionText(
          text: 'Developed by Ahmed Tayseer\nUndergraduate Software Developer',
          fontSize: 16,
        ),
      ],
    );
  }
}

// Widget for Contact Us section
class ContactInfo extends StatelessWidget {
  const ContactInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionTitle(title: 'Contact Us'),
        SizedBox(height: 16),
        SectionText(
          text: 'For any questions, feedback, or support, please reach out to us at:\nahmedtayseer424@gmail.com',
          fontSize: 16,
        ),
      ],
    );
  }
}

// The main AboutScreen widget
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SectionTitle(title: 'About This App'),
              SizedBox(height: 16),
              SectionTitle(title: 'Main Goal', fontSize: 16),
              SizedBox(height: 16),
              SectionText(
                text:
                'Welcome to the Quiz App! Our app is designed to help you study effectively by creating and managing flashcards. You can add flashcards with questions and answers, and quiz yourself to reinforce your learning. The app tracks your quiz scores to help you monitor your progress.',
                fontSize: 16,
              ),
              SizedBox(height: 16),
              SectionTitle(title: 'Advanced Features', fontSize: 16),
              SizedBox(height: 8),
              SectionText(
                text:
                'Beyond basic flashcard functionality, the app offers advanced features such as creating quizzes from lists and utilizing APIs for enhanced data management. You can also explore different categories with new questions each time you quiz yourself, ensuring a fresh and engaging study experience.',
                fontSize: 16,
              ),
              SizedBox(height: 8),
              SectionText(
                text:
                'The app also supports language swapping between Arabic and English, as well as a dark and light mode to suit your preferences. The simple and user-friendly interface makes it easy to navigate and customize your study sessions.',
                fontSize: 16,
              ),
              SizedBox(height: 16),
              VersionInfo(),
              SizedBox(height: 16),
              CreditsSection(),
              SizedBox(height: 32),
              ContactInfo(),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
