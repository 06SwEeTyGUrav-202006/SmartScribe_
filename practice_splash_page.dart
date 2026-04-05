import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smartscribe/quiz_options_page.dart';

class PracticeSplashPage extends StatefulWidget {
  final String summaryText;

  const PracticeSplashPage({super.key, required this.summaryText});

  @override
  State<PracticeSplashPage> createState() => _PracticeSplashPageState();
}

class _PracticeSplashPageState extends State<PracticeSplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizOptionsPage(
            summaryText: widget.summaryText,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.psychology, size: 80, color: Colors.purple),
            SizedBox(height: 20),
            Text(
              "Preparing Practice Questions...",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
