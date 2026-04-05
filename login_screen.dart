
import 'dart:math';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartscribe/auth_wrapper.dart';
import 'signup_screen.dart';
import 'home_page.dart';
import 'forgot_password.dart';
import 'google_auth_service.dart';
import 'auth_wrapper.dart';


final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email'],
);


class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  // --- PALETTE COLORS ---
  final Color colorBgDark = const Color(0xFF1A3263);      // Deep Navy
  final Color colorSecondary = const Color(0xFF547792);  // Steel Blue
  final Color colorAccent = const Color(0xFFFAB95B);     // Gold/Orange
  final Color colorLight = const Color(0xFFE8E2DB);      // Beige/White
  final Color colorWhite = const Color(0xFFFFFFFF);      // Pure White

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }


  // ------------------ Email/Password login ------------------
  void loginUser() async {
    try {
      // 1️⃣ Sign in
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 2️⃣ Get fresh user reference
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // 3️⃣ Force refresh to get latest emailVerified status
      await user.reload();
      user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // 4️⃣ BLOCK unverified users
      if (!user.emailVerified) {
        await FirebaseAuth.instance.signOut();
        await showEmailNotVerifiedDialog(context);
        return;
      }

      // 5️⃣ NAVIGATE IMMEDIATELY
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthWrapper()),
      );


      // 6️⃣ Firestore write (background, non-blocking)
      _createUserDocIfNeeded(user);

    } on FirebaseAuthException catch (e) {
      // ✅ Detailed error messages
      String errorMessage;

      switch (e.code) {
        case 'invalid-email':
          errorMessage = "The email address is not valid!";
          break;
        case 'user-disabled':
          errorMessage = "This user has been disabled!";
          break;
        case 'user-not-found':
          errorMessage = "No account found with this email!";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password!";
          break;
        default:
          errorMessage = "Login failed. Please try again.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: colorBgDark, // Palette Color
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong! $e"),
          backgroundColor: colorBgDark, // Palette Color
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // Firestore write (background, safe)
  Future<void> _createUserDocIfNeeded(User user) async {
    try {
      await user.getIdToken(true); // refresh token
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

      if (!(await userDoc.get()).exists) {
        await userDoc.set({
          'uid': user.uid,
          'email': user.email,
          'createdAt': Timestamp.now(),
        });
      }
    } catch (e) {
      debugPrint("Firestore write failed: $e"); // do not block login
    }
  }










  // ------------------ Google login ------------------
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await _googleSignIn.signOut();

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthWrapper())
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Google Sign-In failed")),
      );
    }
  }



  Future<void> saveGoogleUserToFirestore(User user) async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc('google_users')
        .collection('accounts')
        .doc(user.uid);

    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'uid': user.uid,
        'name': user.displayName,
        'email': user.email,
        'photoUrl': user.photoURL,
        'provider': 'google',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }



  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorBgDark, // Palette: Deep Navy Background
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const FloatingCircles(),
          const ParticleLayer(),
          Center(
            child: SingleChildScrollView(   // ✅ ADD THIS
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(

                  width: size.width > 480 ? 400 : size.width * 0.9,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: colorBgDark.withOpacity(0.2), blurRadius: 40, offset: const Offset(0, 15))],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Welcome Back",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: colorBgDark),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Please login to your account",
                        style: TextStyle(fontSize: 14, color: colorSecondary),
                      ),
                      const SizedBox(height: 30),

                      _floatingInput("Email", emailController, false),
                      const SizedBox(height: 20),
                      _floatingInput("Password", passwordController, true),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ForgotPassword()),
                            );
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(color: colorSecondary, fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Primary Login Button (Gold Accent)
                      Container(
                        width: double.infinity,
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(colors: [colorAccent, colorAccent.withOpacity(0.85)]),
                          boxShadow: [BoxShadow(color: colorAccent.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 5))],
                        ),
                        child: ElevatedButton(
                          onPressed: loginUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text("Login", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: colorBgDark)),
                        ),
                      ),

                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => SignupPage()));
                        },
                        child: Text("Create new account", style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                      ),

                      const SizedBox(height: 15),

                      // Google Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () => signInWithGoogle(context),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                "https://developers.google.com/identity/images/g-logo.png",
                                height: 22,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Continue with Google",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),

                      ),
                    ],
                  ),
                ),
              ),
            ),
          )],
      ),
    );
  }

  Widget _floatingInput(String label, TextEditingController controller, bool obscure) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(color: colorBgDark, fontSize: 16, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: colorSecondary),
        floatingLabelStyle: TextStyle(color: colorBgDark, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: colorLight.withOpacity(0.4), // Subtle Beige background
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorAccent, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
    );
  }
}

// ------------------- Google account not found popup -------------------


void showCreateAccountPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Please create an account to continue",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A3263),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("OK", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// ------------------- Email not verified popup -------------------
Future<void> showEmailNotVerifiedDialog(BuildContext context) async {
  final Color colorAccent = const Color(0xFFFAB95B);
  final Color colorBgDark = const Color(0xFF1A3263);

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Email Not Verified",
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: colorBgDark.withOpacity(0.15), blurRadius: 30, offset: const Offset(0, 10))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.mark_email_unread, color: colorAccent, size: 60),
              const SizedBox(height: 15),
              const Text(
                "Email Not Verified",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A3263)),
              ),
              const SizedBox(height: 10),
              const Text(
                "Please verify your email to access the app.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 25),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text("OK", style: TextStyle(fontSize: 16, color: Color(0xFF1A3263), fontWeight: FontWeight.bold)),
                  )
              )
            ],
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, -0.1), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
        child: ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: FadeTransition(opacity: anim, child: child),
        ),
      );
    },
  );
}

// ------------------- Particle background -------------------
class ParticleLayer extends StatelessWidget {
  const ParticleLayer({super.key});
  @override
  Widget build(BuildContext context) => Stack(children: List.generate(30, (index) => const Particle()));
}

class Particle extends StatefulWidget {
  const Particle({super.key});
  @override
  State<Particle> createState() => _ParticleState();
}

class _ParticleState extends State<Particle> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late double size, left, top;

  @override
  void initState() {
    super.initState();
    final random = Random();
    size = random.nextDouble() * 8 + 4;
    left = random.nextDouble();
    top = random.nextDouble();
    controller = AnimationController(vsync: this, duration: Duration(seconds: random.nextInt(20) + 10))..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) => Positioned(
    left: MediaQuery.of(context).size.width * left,
    top: MediaQuery.of(context).size.height * top,
    child: AnimatedBuilder(
      animation: controller,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, sin(controller.value * 2 * pi) * 20),
        child: Container(width: size, height: size, decoration: BoxDecoration(color: const Color(0xFFFAB95B).withOpacity(0.15), shape: BoxShape.circle)), // Palette Accent (Gold)
      ),
    ),
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class FloatingCircles extends StatelessWidget {
  const FloatingCircles({super.key});

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      _circle(diameter: 300, left: -100, top: -120, color: const Color(0xFF547792).withOpacity(0.15)), // Palette Secondary
      _circle(diameter: 220, right: -80, top: 100, color: const Color(0xFFFAB95B).withOpacity(0.10)), // Palette Accent
      _circle(diameter: 180, left: 40, bottom: -90, color: const Color(0xFF547792).withOpacity(0.08)), // Palette Secondary
    ],
  );

  Widget _circle({double? left, double? right, double? top, double? bottom, required double diameter, required Color color}) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Container(width: diameter, height: diameter, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
    );
  }
}