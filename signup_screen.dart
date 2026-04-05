import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // --- PALETTE COLORS (Unchanged) ---
  final Color colorBgDark = const Color(0xFF1A3263);      // Deep Navy
  final Color colorSecondary = const Color(0xFF547792);  // Steel Blue
  final Color colorAccent = const Color(0xFFFAB95B);     // Gold/Orange
  final Color colorLight = const Color(0xFFE8E2DB);      // Beige/White
  final Color colorWhite = const Color(0xFFFFFFFF);      // Pure White

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool isStrongPassword(String password) {
    final passwordRegex =
    RegExp(r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  void registerUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid email address")),
      );
      return;
    }

    if (!isStrongPassword(password)) {
      await showPasswordRuleDialog();
      return;
    }

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = userCredential.user!;

      // 🔹 Send verification
      await user.sendEmailVerification();

      // 🔹 Immediately sign out
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      await showEmailVerificationPrompt();

    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("This account is already registered. Please log in."),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Signup failed")),
        );
      }
    }
  }


  Future<void> showEmailVerificationPrompt() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: colorWhite,
        title: Row(
          children: [
            Icon(Icons.mark_email_read, color: colorAccent, size: 28),
            const SizedBox(width: 10),
            Text(
              "Verify Your Email",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: colorBgDark,
              ),
            ),
          ],
        ),
        content: Text(
          "Your account has been created successfully!\n\n"
              "Please check your email and click the verification link.\n\n"
              "After verification, you can log in.",
          style: TextStyle(height: 1.5, color: colorSecondary),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginPage()),
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorAccent,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "OK",
              style: TextStyle(color: colorBgDark, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> showPasswordRuleDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: colorWhite,
        title: Column(
          children: [
            Icon(
              Icons.lock_outline,
              size: 44,
              color: colorBgDark,
            ),
            const SizedBox(height: 10),
            Text(
              "Weak Password",
              style: TextStyle(fontWeight: FontWeight.bold, color: colorBgDark),
            ),
          ],
        ),
        content: Text(
          "Your password must contain:\n\n"
              "• At least 8 characters\n"
              "• One uppercase letter\n"
              "• One special character\n\n"
              "Please update your password and try again.",
          textAlign: TextAlign.center,
          style: TextStyle(height: 1.5, color: colorSecondary),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorBgDark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("OK", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBgDark,
      body: Stack(
        children: [
          // --- NEW DECORATIVE BACKGROUND ---
          const _BackgroundCircle(top: -100, left: -100, size: 300, opacity: 0.1),
          const _BackgroundCircle(bottom: -50, right: -50, size: 200, opacity: 0.05),
          const _BackgroundCircle(top: 150, right: -50, size: 100, color: Color(0xFFFAB95B), opacity: 0.15),

          // --- HEADER SECTION (Top of Screen) ---
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.only(top: 60, left: 32, right: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: colorWhite,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Sign up to get started with SmartScribe",
                      style: TextStyle(
                        fontSize: 16,
                        color: colorLight.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- BOTTOM CARD (Form) ---
          Align(
            alignment: Alignment.bottomCenter,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.65,
                width: double.infinity,
                margin: const EdgeInsets.only(top: 180),
                decoration: BoxDecoration(
                  color: colorWhite,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    child: Column(
                      children: [
                        // Name Field
                        TextFormField(
                          controller: nameController,
                          style: TextStyle(
                            color: colorBgDark,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText: "Full Name",
                            prefixIcon: Icon(Icons.person_outline, color: colorSecondary),
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            filled: true,
                            fillColor: colorLight.withOpacity(0.5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: colorAccent, width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Email Field
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            color: colorBgDark,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText: "Email Address",
                            prefixIcon: Icon(Icons.email_outlined, color: colorSecondary),
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            filled: true,
                            fillColor: colorLight.withOpacity(0.5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: colorAccent, width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Password Field
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          style: TextStyle(
                            color: colorBgDark,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: Icon(Icons.lock_outline, color: colorSecondary),
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            filled: true,
                            fillColor: colorLight.withOpacity(0.5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: colorAccent, width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 35),

                        // Sign Up Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: registerUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorAccent,
                              elevation: 4,
                              shadowColor: colorAccent.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorBgDark,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Login Link
                        GestureDetector(
                          onTap: () {
                            // Logic implies navigation, keeping it simple
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(color: colorSecondary, fontSize: 14),
                              children: [
                                TextSpan(
                                  text: "Log In",
                                  style: TextStyle(
                                    color: colorBgDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------------- NEW BACKGROUND WIDGETS ---------------- */

class _BackgroundCircle extends StatelessWidget {
  final double top;
  final double left;
  final double right;
  final double bottom;
  final double size;
  final Color color;
  final double opacity;

  const _BackgroundCircle({
    this.top = double.infinity,
    this.left = double.infinity,
    this.right = double.infinity,
    this.bottom = double.infinity,
    required this.size,
    this.color = Colors.white,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top != double.infinity ? top : null,
      left: left != double.infinity ? left : null,
      right: right != double.infinity ? right : null,
      bottom: bottom != double.infinity ? bottom : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(opacity),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}