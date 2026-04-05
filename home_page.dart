import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// NOTE: Ensure these files exist in your project
import 'login_screen.dart';
import 'signup_screen.dart';

void main() {
  runApp(const EchoAIApp());
}

class EchoAIApp extends StatelessWidget {
  const EchoAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartScribe',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFE8E2DB),
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A3263),
          primary: const Color(0xFF1A3263),
          secondary: const Color(0xFFFAB95B),
        ),
      ),
      home: const EchoAIHomePage(),
    );
  }
}

class EchoAIHomePage extends StatefulWidget {
  const EchoAIHomePage({super.key});

  @override
  State<EchoAIHomePage> createState() => _SplashLandingPageState();
}

class _SplashLandingPageState extends State<EchoAIHomePage>
    with TickerProviderStateMixin {
  // ================= COLOR PALETTE =================
  static const Color kDarkBlue = Color(0xFF1A3263);
  static const Color kMutedBlue = Color(0xFF547792);
  static const Color kGold = Color(0xFFFAB95B);
  static const Color kCream = Color(0xFFE8E2DB);

  // ================= ANIMATION STATE =================
  late AnimationController _splashController;
  late Animation<double> _paintAnim;
  late Animation<double> _logoScaleAnim;
  late Animation<double> _textOpacityAnim;

  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _setupSplashAnimation();
  }

  void _setupSplashAnimation() {
    _splashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    // 1. Painting the circle (0.0 to 0.6)
    _paintAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _splashController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    // 2. Scaling the logo inside (0.5 to 0.8)
    _logoScaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _splashController,
        curve: const Interval(0.5, 0.8, curve: Curves.elasticOut),
      ),
    );

    // 3. Fading in the text (0.7 to 1.0)
    _textOpacityAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _splashController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );

    // Start animation
    _splashController.forward().then((_) {
      // Wait a moment then switch to landing page
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _showSplash = false;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _splashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return _buildSplashScreen();
    } else {
      return _buildNewLandingPage();
    }
  }

  // ================= SPLASH SCREEN UI (UNCHANGED) =================
  Widget _buildSplashScreen() {
    return Scaffold(
      backgroundColor: kCream,
      body: Center(
        child: AnimatedBuilder(
          animation: _splashController,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drawing Area
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 1. The Painted Circle
                      CustomPaint(
                        size: const Size(200, 200),
                        painter: _CirclePainter(
                          progress: _paintAnim.value,
                          color: kDarkBlue,
                        ),
                      ),

                      // 2. The "Brush" Icon following the path
                      if (_paintAnim.value < 1.0)
                        Transform.translate(
                          offset: _getOffsetOnCircle(_paintAnim.value, 100),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: kGold,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.brush, size: 20, color: kDarkBlue),
                          ),
                        ),

                      // 3. The Logo popping in
                      ScaleTransition(
                        scale: _logoScaleAnim,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: kDarkBlue.withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Text Fade In
                Opacity(
                  opacity: _textOpacityAnim.value,
                  child: Column(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [kDarkBlue, kMutedBlue],
                        ).createShader(bounds),
                        child: const Text(
                          "SmartScribe",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Intelligent Learning Companion",
                        style: TextStyle(
                          fontSize: 16,
                          color: kMutedBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Helper to calculate brush position on circle perimeter
  Offset _getOffsetOnCircle(double progress, double size) {
    final center = Offset(size / 2, size / 2);
    final radius = size / 2;
    // Start from top (-pi/2) and go clockwise
    final angle = 2 * pi * progress - (pi / 2);
    final x = center.dx + radius * cos(angle);
    final y = center.dy + radius * sin(angle);
    return Offset(x, y);
  }

  // ============================================================
  // NEW REDESIGNED LANDING PAGE (With Top Left Logo)
  // ============================================================
  Widget _buildNewLandingPage() {
    return Scaffold(
      backgroundColor: kCream,
      body: Stack(
        children: [
          // 1. Decorative Background Elements
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: kGold.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: kDarkBlue.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // --- NEW: TOP LEFT LOGO HEADER ---
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: kDarkBlue.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "SmartScribe",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: kDarkBlue,
                          ),
                        )
                      ],
                    ),
                  ),

                  const Spacer(flex: 1),

                  // --- Center Visual (Abstract UI Card) ---
                  _buildAbstractVisual(),

                  const Spacer(flex: 2),

                  // --- Text Content ---
                  Text(
                    "Smart Learning\nStarts Here",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: kDarkBlue,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Compile code, summarize lectures, and organize your studies with the power of AI.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: kMutedBlue,
                      height: 1.5,
                    ),
                  ),

                  const Spacer(flex: 2),

                  // --- Buttons ---
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                          context, MaterialPageRoute(builder: (_) => SignupPage())),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kDarkBlue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Create Account",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () => Navigator.push(
                          context, MaterialPageRoute(builder: (_) => LoginPage())),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: kDarkBlue,
                        side: BorderSide(color: kMutedBlue.withOpacity(0.5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// A stylized card representing the app's function without listing features
  Widget _buildAbstractVisual() {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: kDarkBlue.withOpacity(0.1),
            blurRadius: 50,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: kDarkBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.description_outlined, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "My Notes",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: kDarkBlue,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kGold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.auto_awesome, color: kDarkBlue, size: 18),
              )
            ],
          ),
          const SizedBox(height: 24),
          // Simulated Text Lines
          Align(
            alignment: Alignment.centerLeft,
            child: Container(height: 10, width: double.infinity, color: kCream),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(height: 10, width: 150, color: kCream),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(height: 10, width: 200, color: kCream),
          ),
          const SizedBox(height: 24),
          // Highlight Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kDarkBlue.withOpacity(0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kMutedBlue.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, color: kGold, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "AI Summary generated successfully",
                    style: TextStyle(
                      color: kMutedBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ================= CUSTOM PAINTER FOR CIRCLE =================
class _CirclePainter extends CustomPainter {
  final double progress;
  final Color color;

  _CirclePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background faint circle
    final bgPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress circle (Drawn arc)
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;

    final sweepAngle = 2 * pi * progress;
    // Start from top
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}