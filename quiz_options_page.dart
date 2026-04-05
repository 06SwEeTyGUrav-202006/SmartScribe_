import 'package:flutter/material.dart';
import 'quiz_page.dart';

class QuizOptionsPage extends StatelessWidget {
  final String summaryText;

  const QuizOptionsPage({super.key, required this.summaryText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Practice Mode")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _quizTile(context, "MCQs", Icons.list, "mcq"),

            const SizedBox(height: 12),

            Card(
              color: Colors.grey.shade900,
              child: const ListTile(
                leading: Icon(Icons.check_circle, color: Colors.grey),
                title: Text("True / False (Coming Soon)",
                    style: TextStyle(color: Colors.grey)),
                trailing: Icon(Icons.lock, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 12),

            Card(
              color: Colors.grey.shade900,
              child: const ListTile(
                leading: Icon(Icons.edit, color: Colors.grey),
                title: Text("Short Questions (Coming Soon)",
                    style: TextStyle(color: Colors.grey)),
                trailing: Icon(Icons.lock, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quizTile(
      BuildContext context, String title, IconData icon, String type) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => QuizPage(
                summaryText: summaryText,
                quizType: type,
              ),
            ),
          );
        },
      ),
    );
  }
}
