import 'package:flutter/material.dart';
import 'quiz_page.dart';

class QuizSplashPage extends StatelessWidget {
  final String summaryText;

  const QuizSplashPage({super.key, required this.summaryText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.quiz, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              "Practice Quiz",
              style: TextStyle(
                fontSize: 26,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "5 AI-generated questions",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
                padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizPage(
                      summaryText: summaryText,
                      quizType: "mcq", // or "tf" or "short"
                    ),
                  ),
                );
              },
              child: const Text("Generate Quiz"),
            ),
          ],
        ),
      ),
    );
  }
}
