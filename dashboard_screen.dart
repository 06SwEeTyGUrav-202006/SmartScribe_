import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'about_page.dart';
import 'theme/settings_provider.dart';
import 'code_runner_page.dart';
import 'records_page.dart';
import 'upload_page.dart';
import 'summary_page.dart';
import 'settings_page.dart';
import 'login_screen.dart';
import 'focus_time_page.dart';
import 'goals_page.dart';
import 'notification_page.dart';
import 'feedback_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --- Color Palette (Preserved) ---
  static const Color colorBgDark = Color(0xFF1A3263);
  static const Color colorSecondary = Color(0xFF547792);
  static const Color colorAccent = Color(0xFFFAB95B);
  static const Color colorLight = Color(0xFFE8E2DB);
  static const Color colorWhite = Color(0xFFFFFFFF);

  int gradientIndex = 0;
  late Timer _timer;

  int streakCount = 3; // replace with Firebase later

  final List<List<Color>> gradients = [
    [const Color(0xFF89F7FE), const Color(0xFF66A6FF)],
    [const Color(0xFFFBC2EB), const Color(0xFFA6C1EE)],
    [const Color(0xFF84FAB0), const Color(0xFF8FD3F4)],
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      setState(() {
        gradientIndex = (gradientIndex + 1) % gradients.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) =>  LoginPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<SettingsProvider>();
    final user = FirebaseAuth.instance.currentUser;
    final username = user?.displayName ?? user?.email?.split('@')[0] ?? "User";
    final email = user?.email ?? "";

    return Scaffold(
      // Using the Beige tone as canvas for a softer professional look
      backgroundColor: colorLight,
      drawer: _buildDrawer(username, email, themeProvider),
      body: SafeArea(
        child: Column(
          children: [
            // --- Refined Header ---
            _buildModernHeader(username, themeProvider.themeMode == ThemeMode.dark),

            // --- Main Content ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Section: Quick Actions
                    _buildSectionTitle("Quick Actions"),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCompactCard(
                            icon: Icons.mic_rounded,
                            title: "Record",
                            color: colorBgDark,
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (_) => const RecordModule())),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildCompactCard(
                            icon: Icons.cloud_upload_rounded,
                            title: "Upload",
                            color: colorSecondary,
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (_) => const UploadPage())),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Centerpiece: Productivity Zone
                    _buildProductivityZone(),

                    const SizedBox(height: 28),

                    // AI Section
                    _buildSectionTitle("AI Tools"),
                    const SizedBox(height: 12),
                    _proCard(
                      icon: Icons.auto_awesome,
                      title: "AI Summary",
                      desc: "Generate insights from your notes",
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const SummaryPage())),
                    ),

                    const SizedBox(height: 16),

                    // Dev Section
                    _proCard(
                      icon: Icons.terminal_rounded,
                      title: "Code Compiler",
                      desc: "Run code snippets on the go",
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const CodeRunnerPage())),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colorSecondary,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildModernHeader(String username, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
      decoration: const BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Avatar
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: colorBgDark,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(Icons.person_outline, color: colorWhite, size: 28),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome back,",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorBgDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Menu Button
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.menu, color: colorBgDark, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Compact Card for Row Layout
  Widget _buildCompactCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colorBgDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Standard Pro Card
  Widget _proCard({
    required IconData icon,
    required String title,
    required String desc,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: colorBgDark.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Icon(icon, color: colorBgDark, size: 24),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorBgDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: colorBgDark,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Productivity Zone (Hero Section)
  Widget _buildProductivityZone() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorBgDark, const Color(0xFF0F1C38)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorBgDark.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.flash_on_rounded, color: colorBgDark, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Productivity Zone",
                    style: TextStyle(
                        color: colorWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              // Streak indicator (using existing variable)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                
              )
            ],
          ),
          const SizedBox(height: 20),
          _productivityTile(Icons.timer_rounded, "Focus Time",
              "Pomodoro & deep work sessions", () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const FocusPage()));
              }),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: Colors.white.withOpacity(0.1), height: 1),
          ),
          _productivityTile(Icons.flag_rounded, "Set Goals",
              "Daily & weekly targets", () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) =>  GoalsScreen()));
              }),
        ],
      ),
    );
  }

  Widget _productivityTile(
      IconData icon, String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.white10,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: colorAccent, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: colorWhite, fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(color: colorLight.withOpacity(0.7), fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: colorLight, size: 18),
          ],
        ),
      ),
    );
  }

  // --- DRAWER ---
  Drawer _buildDrawer(String username, String email, SettingsProvider themeProvider) {
    return Drawer(
      backgroundColor: colorWhite,
      child: Column(
        children: [
          // Modern Drawer Header
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 24, left: 24, right: 20),
            decoration: const BoxDecoration(
              color: colorBgDark,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colorAccent, width: 2),
                  ),
                  child: const CircleAvatar(
                    radius: 28,
                    backgroundColor: colorLight,
                    child: Icon(Icons.person, color: colorBgDark, size: 32),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(username, style: const TextStyle(color: colorWhite, fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 4),
                      Text(email, style: const TextStyle(color: colorLight, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Menu Items
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _drawerItem(Icons.mic_none, "Record", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const RecordModule()));
                  }),
                  _drawerItem(Icons.upload_file, "Upload", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const UploadPage()));
                  }),
                  _drawerItem(Icons.summarize_outlined, "Summary", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SummaryPage()));
                  }),
                  const Divider(indent: 20, endIndent: 20, thickness: 1),
                  _drawerItem(Icons.flag_outlined, "Goals", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) =>  GoalsScreen()));
                  }),
                  _drawerItem(Icons.timer_outlined, "Focus Time", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const FocusPage()));
                  }),
                  _drawerItem(Icons.notifications_active_outlined, "Daily Reminder", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) =>  NotificationPage()));
                  }),
                  const Divider(indent: 20, endIndent: 20, thickness: 1),
                  _drawerItem(Icons.settings_outlined, "Settings", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
                  }),
                  _drawerItem(Icons.feedback_outlined, "Feedback", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedbackPage()));
                  }),
                  _drawerItem(Icons.info_outline, "About", () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutPage()));
                  }),
                ],
              ),
            ),
          ),

          // Bottom Controls
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: colorLight.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SwitchListTile(
                    title: const Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.w500)),
                    secondary: const Icon(Icons.dark_mode_outlined, color: colorSecondary),
                    value: themeProvider.themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      themeProvider.setTheme(value ? "Dark" : "Light");
                    },
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: logout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: colorSecondary),
      title: Text(title, style: const TextStyle(color: colorBgDark, fontWeight: FontWeight.w500, fontSize: 15)),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      horizontalTitleGap: 0,
    );
  }
}