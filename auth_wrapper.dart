
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart'; // your record/upload/summary screen

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  // --- PALETTE COLORS ---
  static const Color colorBgDark = Color(0xFF1A3263);      // Deep Navy
  static const Color colorSecondary = Color(0xFF547792);  // Steel Blue
  static const Color colorAccent = Color(0xFFFAB95B);     // Gold/Orange
  static const Color colorLight = Color(0xFFE8E2DB);      // Beige/White
  static const Color colorWhite = Color(0xFFFFFFFF);      // Pure White

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        // 1️⃣ IF USER IS ALREADY LOGGED IN -> GO DIRECTLY TO HOME
        // This fixes the "flash" for returning users
        if (snapshot.hasData && snapshot.data != null) {
          return const HomePage();
        }

        // 2️⃣ IF AUTH SYSTEM IS CHECKING (LOADING STATE)
        // Show Designed Loading Screen
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen(context);
        }

        // 3️⃣ IF NO USER FOUND
        // Go to Login Page
        return  SmartScribeApp();
      },
    );
  }

  // --- CUSTOM DESIGNED LOADING SCREEN (Matches EchoAI Theme) ---
  Widget _buildLoadingScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: colorLight, // Beige Background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo / Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorWhite,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorAccent.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.auto_stories,
                size: 40,
                color: colorBgDark,
              ),
            ),
            const SizedBox(height: 30),

            // Title
            const Text(
              "SmartScribe",
              style: TextStyle(
                color: colorBgDark,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 60),

            // Loading Spinner (Gold)
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(colorAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}