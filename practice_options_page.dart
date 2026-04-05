import 'package:flutter/material.dart';
import 'quiz_page.dart';
import 'flash_cards_page.dart';


class PracticeOptionsPage extends StatelessWidget {
  final String summaryText;
  final String summaryId; // ✅ ADD THIS

  const PracticeOptionsPage({
    super.key,
    required this.summaryText,
    required this.summaryId, // ✅ ADD THIS
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Practice"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _practiceCard(
              icon: Icons.quiz,
              title: "Quiz",
              subtitle: "Test your understanding",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizPage(
                      summaryText: summaryText,
                      quizType: "mcq",
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            _practiceCard(
              icon: Icons.style,
              title: "Flash Cards",
              subtitle: "Revise key concepts",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FlashCardsPage(
                      summaryId: summaryId,        // ✅ PASS ID
                      summaryText: summaryText,    // ✅ PASS TEXT
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _practiceCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 36),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
