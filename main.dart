import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartscribe/home_page.dart';
import 'services/notification_service.dart';
import 'theme/settings_provider.dart';
import 'theme/app_theme.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';
import 'code_runner_page.dart';
import 'code_history_page.dart';
import 'splash_screen.dart';
import 'edit_summary_page..dart';
import 'feedback_page.dart';
import 'flash_cards_page.dart';
import 'edit_summary_page..dart';
import 'reminder_settings_page.dart';
import 'dashboard_screen.dart';
import 'focus_time_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const SmartScribeApp(),
    ),
  );
}

class SmartScribeApp extends StatelessWidget {
  const SmartScribeApp({super.key});

  @override
  Widget build(BuildContext context) {

    // ✅ ADD THIS HERE
    final settings = context.watch<SettingsProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartScribe',

      // ✅ GLOBAL THEME CONTROL
      themeMode: settings.themeMode,
      theme: AppTheme.lightTheme(settings.fontSize),
      darkTheme: AppTheme.darkTheme(settings.fontSize),

      routes: {
        "/auth": (context) => const AuthGate(),
        "/dashboard": (context) => const HomePage(),
        "/code": (context) => const CodeRunnerPage(),
        "/history": (context) => const CodeHistoryPage(),
        "a":(context)=> EchoAIApp(),
        "c":(context)=> FeedbackPage(),
        "d":(context)=> ReminderSettingsPage(),
        "e":(context)=> HomePage(),
        "f":(context)=> SplashScreen(),
        "h":(context)=> FocusPage(),
      },

      home: const SplashScreen(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomePage();
        }

        return const EchoAIHomePage();
      },
    );
  }
}
