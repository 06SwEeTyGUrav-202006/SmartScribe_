
import 'dart:math';
import 'package:flutter/material.dart';
import 'reminder_settings_page.dart';
import 'services/notification_service.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});

  // --- PALETTE COLORS ---
  final Color colorBgDark = const Color(0xFF1A3263);      // Deep Navy
  final Color colorSecondary = const Color(0xFF547792);  // Steel Blue
  final Color colorAccent = const Color(0xFFFAB95B);     // Gold/Orange
  final Color colorLight = const Color(0xFFE8E2DB);      // Beige/White
  final Color colorWhite = const Color(0xFFFFFFFF);      // Pure White

  // --- QUOTES (Fixed Quotes) ---
  final List<String> quotes = [
    "Small steps every day lead to big results 🚀",
    "Consistency beats motivation 🔥",
    "You're building your future, one revision at a time 📚",
    "Discipline today = Success tomorrow 💪",
    "Focus on progress, not perfection ✨",
  ];

  String randomQuote() {
    return quotes[Random().nextInt(quotes.length)];
  }

  @override
  Widget build(BuildContext context) {
    final quote = randomQuote();

    return Scaffold(
      backgroundColor: colorLight, // Beige Background
      appBar: AppBar(
        backgroundColor: colorBgDark, // Navy Header
        elevation: 0,
        iconTheme: IconThemeData(color: colorLight),
        title:  Text(
          "🔔 SmartScribe Reminders",
          style: TextStyle(
            color: colorWhite,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- QUOTE CARD (Themed Gradient) ---
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorBgDark, colorSecondary], // Navy to Steel Blue
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: colorBgDark.withOpacity(0.15),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Text(
                quote,
                style:  TextStyle(
                  color: colorWhite,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 50),

            // --- ACTION BUTTON (Gold Theme) ---
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReminderSettingsPage()),
                  );
                },
                icon:  Icon(Icons.alarm, color: colorBgDark),
                label: const Text("Set Daily Reminders"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorAccent, // Gold Button
                  foregroundColor: colorBgDark, // Navy Text
                  elevation: 2,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}