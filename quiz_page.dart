import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuizPage extends StatefulWidget {
  final String summaryText;
  final String quizType;

  const QuizPage({
    super.key,
    required this.summaryText,
    required this.quizType,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  bool loading = true;
  String username = "Reshma"; // later we’ll make login

  List<dynamic> questions = [];
  int currentIndex = 0;
  int score = 0;
  int? selectedOption;

  @override
  void initState() {
    super.initState();
    fetchQuiz();
  }

  Future<void> fetchQuiz() async {
    try {
      final res = await http.post(
        Uri.parse("http://10.40.9.50:5000/generate-quiz"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"summary": widget.summaryText}),
      );

      final data = jsonDecode(res.body);

      if (data['quiz'] == null || data['quiz'].isEmpty) {
        throw "Quiz not generated";
      }

      setState(() {
        questions = data['quiz'];   // ✅ Structured quiz
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to load quiz: $e")),
      );
    }
  }

  void submitAnswer() {
    final correctAnswer = questions[currentIndex]['answer'];
    final selectedText =
    questions[currentIndex]['options'][selectedOption!];

    if (selectedText == correctAnswer) {
      score++;
    }

    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedOption = null;
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("🎉 Quiz Completed"),
          content: Text("Your Score: $score / ${questions.length}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Quiz")),
        body: const Center(child: Text("❌ No quiz generated")),
      );
    }

    final currentQ = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz (${currentIndex + 1}/${questions.length})"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentQ['question'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            ...List.generate(currentQ['options'].length, (i) {
              return Card(
                child: RadioListTile<int>(
                  value: i,
                  groupValue: selectedOption,
                  title: Text(currentQ['options'][i]),
                  onChanged: (v) {
                    setState(() => selectedOption = v);
                  },
                ),
              );
            }),

            const Spacer(),

            ElevatedButton(
              onPressed: selectedOption == null ? null : submitAnswer,
              child: Text(
                currentIndex == questions.length - 1 ? "Finish" : "Next",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
