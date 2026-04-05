import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'theme/settings_provider.dart'; // ✅ Correct import
import 'auth_wrapper.dart';
import 'user_details.dart';
import 'theme/app_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String selectedTheme = "System";
  double fontSize = 16;
  String selectedLanguage = "English";

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    if (user == null) return;

    final doc = await firestore.collection("users").doc(user!.uid).get();

    if (doc.exists) {
      final data = doc.data();

      selectedTheme = data?["theme"] ?? "System";
      fontSize = (data?["fontSize"] ?? 16).toDouble();
      selectedLanguage = data?["language"] ?? "English";

      final settingsProvider =
      Provider.of<SettingsProvider>(context, listen: false);

      settingsProvider.setTheme(selectedTheme);
      settingsProvider.setFontSize(fontSize);
      settingsProvider.setLanguage(selectedLanguage);

      setState(() {});
    }
  }

  Future<void> saveSettings() async {
    if (user == null) return;

    await firestore.collection("users").doc(user!.uid).set({
      "theme": selectedTheme,
      "fontSize": fontSize,
      "language": selectedLanguage,
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          const SizedBox(height: 10),

          // --- Profile Section ---
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(user?.displayName ?? "Profile"),
            subtitle: Text(user?.email ?? ""),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => UserDetailsPage()),
              );
            },
          ),

          // --- Logout ---
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const AuthWrapper()),
                    (_) => false,
              );
            },
          ),

          const Divider(),

          // --- Theme Selector ---
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text("Theme"),
            trailing: DropdownButton<String>(
              value: selectedTheme,
              items: const [
                DropdownMenuItem(value: "Light", child: Text("Light")),
                DropdownMenuItem(value: "Dark", child: Text("Dark")),
                DropdownMenuItem(value: "System", child: Text("System")),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => selectedTheme = value);
                settingsProvider.setTheme(value);
                saveSettings();
              },
            ),
          ),

          // --- Font Size ---
          ListTile(
            leading: const Icon(Icons.format_size),
            title: const Text("Font Size"),
            subtitle: Slider(
              value: fontSize,
              min: 14,
              max: 22,
              divisions: 4,
              label: fontSize.round().toString(),
              onChanged: (value) {
                setState(() => fontSize = value);
                settingsProvider.setFontSize(value);
                saveSettings();
              },
            ),
          ),
        ],
      ),
    );
  }
}
