import 'dart:math' as math;
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with TickerProviderStateMixin {

  final PageController _pageController = PageController();

  late AnimationController _floatController;
  late AnimationController _shimmerController;
  late AnimationController _bgController;
  late Animation<double> floatingAnimation;
  late Animation<double> shimmerAnimation;

  double currentPage = 0;

  // --- FEATURE LIST WITH PREMIUM UNSPLASH IMAGES ---
  final List<Map<String, dynamic>> features = [
    {
      "image": "https://images.unsplash.com/photo-1478737270239-2f02b77fc618?q=80&w=1400&auto=format&fit=crop",
      "icon": Icons.mic_rounded,
      "title": "Record Audio",
      "desc": "Capture lectures and personal notes with crystal-clear, high-fidelity audio recording.",
      "gradient": [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)],
      "accent": const Color(0xFF00D4FF),
      "tag": "CAPTURE",
    },
    {
      "image": "https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?q=80&w=1400&auto=format&fit=crop",
      "icon": Icons.upload_file_rounded,
      "title": "Upload Audio",
      "desc": "Seamlessly upload existing audio files in any format for instant AI processing.",
      "gradient": [const Color(0xFF1A1A2E), const Color(0xFF16213E), const Color(0xFF0F3460)],
      "accent": const Color(0xFF7B2FFF),
      "tag": "IMPORT",
    },
    {
      "image": "https://images.unsplash.com/photo-1568667256549-094345857637?q=80&w=1400&auto=format&fit=crop",
      "icon": Icons.picture_as_pdf_rounded,
      "title": "PDF Reader",
      "desc": "Upload, annotate, and explore PDF documents with our sleek integrated viewer.",
      "gradient": [const Color(0xFF1F1C2C), const Color(0xFF928DAB)],
      "accent": const Color(0xFFFF6B6B),
      "tag": "READ",
    },
    {
      "image": "https://images.unsplash.com/photo-1677442135703-1787eea5ce01?q=80&w=1400&auto=format&fit=crop",
      "icon": Icons.auto_awesome_rounded,
      "title": "AI Summary",
      "desc": "Transform hours of content into razor-sharp, intelligent summaries in seconds.",
      "gradient": [const Color(0xFF0D0D0D), const Color(0xFF1A1A2E), const Color(0xFF16213E)],
      "accent": const Color(0xFF00FFC6),
      "tag": "AI POWERED",
    },
    {
      "image": "https://images.unsplash.com/photo-1434030216411-0b793f4b4173?q=80&w=1400&auto=format&fit=crop",
      "icon": Icons.edit_note_rounded,
      "title": "Edit Summary",
      "desc": "Refine and personalize AI-generated summaries to perfectly match your style.",
      "gradient": [const Color(0xFF134E5E), const Color(0xFF71B280)],
      "accent": const Color(0xFFF9CA24),
      "tag": "CUSTOMIZE",
    },
    {
      "image": "https://images.unsplash.com/photo-1529156069898-49953e39b3ac?q=80&w=1400&auto=format&fit=crop",
      "icon": Icons.share_rounded,
      "title": "Share Insights",
      "desc": "Instantly export and share your summaries with teammates or study groups.",
      "gradient": [const Color(0xFF1CB5E0), const Color(0xFF000851)],
      "accent": const Color(0xFFFFA500),
      "tag": "COLLABORATE",
    },
    {
      "image": "https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=1400&auto=format&fit=crop",
      "icon": Icons.style_rounded,
      "title": "Flash Cards",
      "desc": "Auto-generate beautiful flashcards from your notes for effortless revision.",
      "gradient": [const Color(0xFF360033), const Color(0xFF0B8793)],
      "accent": const Color(0xFFFF61D2),
      "tag": "MEMORIZE",
    },
    {
      "image": "https://images.unsplash.com/photo-1606326608606-aa0b62935f2b?q=80&w=1400&auto=format&fit=crop",
      "icon": Icons.quiz_rounded,
      "title": "Smart Quiz",
      "desc": "Test and sharpen your knowledge with AI-generated quizzes tailored to your content.",
      "gradient": [const Color(0xFF4A00E0), const Color(0xFF8E2DE2)],
      "accent": const Color(0xFFFFD700),
      "tag": "TEST",
    },
    {
      "image": "https://images.unsplash.com/photo-1542831371-29b0f74f9713?q=80&w=1400&auto=format&fit=crop",
      "icon": Icons.code_rounded,
      "title": "Code Compiler",
      "desc": "Write, run, and debug code in multiple languages directly within the app.",
      "gradient": [const Color(0xFF0A0A0A), const Color(0xFF1A1A2E), const Color(0xFF2D2D2D)],
      "accent": const Color(0xFF39FF14),
      "tag": "BUILD",
    },
    {
      "image": "https://images.unsplash.com/photo-1557804506-669a67965ba0?q=80&w=1400&auto=format&fit=crop",
      "icon": Icons.timer_rounded,
      "title": "Focus Mode",
      "desc": "Enter deep work sessions with Pomodoro timers and ambient focus sounds.",
      "gradient": [const Color(0xFF141E30), const Color(0xFF243B55)],
      "accent": const Color(0xFF00CFFF),
      "tag": "FOCUS",
    },
    {
      "image": "https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?q=80&w=1400&auto=format&fit=crop",
      "icon": Icons.flag_rounded,
      "title": "Set Goals",
      "desc": "Define daily milestones and track your growth with visual progress charts.",
      "gradient": [const Color(0xFF11998E), const Color(0xFF38EF7D)],
      "accent": const Color(0xFFFFFFFF),
      "tag": "ACHIEVE",
    },
    {
      "image": "https://images.unsplash.com/photo-1508739773434-c26b3d09e071?q=80&w=1400&auto=format&fit=crop",
      "icon": Icons.notifications_active_rounded,
      "title": "Daily Reminders",
      "desc": "Smart notifications keep you consistent, motivated, and always on track.",
      "gradient": [const Color(0xFFB24592), const Color(0xFFF15F79)],
      "accent": const Color(0xFFFFE66D),
      "tag": "STAY ON TRACK",
    },
  ];

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page ?? 0;
      });
    });

    // Floating Animation
    _floatController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3))
      ..repeat(reverse: true);

    floatingAnimation = Tween<double>(begin: -12, end: 12).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Shimmer
    _shimmerController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2))
      ..repeat();

    shimmerAnimation = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    // Background
    _bgController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 8))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    _shimmerController.dispose();
    _bgController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int index = currentPage.round().clamp(0, features.length - 1);
    List<Color> gradColors = (features[index]['gradient'] as List<Color>);

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Animated orb background
            _buildBackgroundOrbs(index),

            SafeArea(
              child: Column(
                children: [
                  _buildTopBar(index),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: features.length,
                      itemBuilder: (context, i) => _buildPage(i),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundOrbs(int index) {
    final accent = features[index]['accent'] as Color;
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, _) {
        return Stack(
          children: [
            Positioned(
              top: -80 + (_bgController.value * 40),
              right: -60,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [accent.withOpacity(0.15), Colors.transparent],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 200 + (_bgController.value * 30),
              left: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [accent.withOpacity(0.10), Colors.transparent],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopBar(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 16),
            ),
          ),

          // Step indicator pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              children: List.generate(features.length, (dotIndex) {
                bool isActive = index == dotIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isActive ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isActive
                        ? (features[index]['accent'] as Color)
                        : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),
          ),

          // Step counter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Text(
              "${index + 1}/${features.length}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int i) {
    double pageOffset = currentPage - i;
    double scale = (1 - (pageOffset.abs() * 0.25)).clamp(0.75, 1.0);
    double rotation = pageOffset.clamp(-0.5, 0.5) * 0.08;
    final accent = features[i]['accent'] as Color;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Floating Image Card
        Positioned(
          top: 20,
          child: AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, floatingAnimation.value),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.002)
                    ..rotateY(rotation)
                    ..scale(scale),
                  child: _buildImageCard(i, accent),
                ),
              );
            },
          ),
        ),

        // Bottom Content Card
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: TweenAnimationBuilder<double>(
            key: ValueKey(i),
            tween: Tween(begin: 60.0, end: 0.0),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, value),
                child: Opacity(
                  opacity: (1 - value / 60).clamp(0.0, 1.0),
                  child: _buildBottomCard(i, accent),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageCard(int i, Color accent) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main image with glass frame
        Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(0.35),
                blurRadius: 40,
                spreadRadius: 2,
                offset: const Offset(0, 20),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  features[i]["image"],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.grey[850]!,
                            Colors.grey[800]!,
                          ],
                        ),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: accent,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[900],
                      child: Icon(features[i]['icon'] as IconData,
                          size: 80, color: accent.withOpacity(0.6)),
                    );
                  },
                ),
                // Gradient overlay on image
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
                // Shimmer gloss effect
                AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context, _) {
                    return ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          begin: Alignment(shimmerAnimation.value - 1, -0.5),
                          end: Alignment(shimmerAnimation.value, 0.5),
                          colors: [
                            Colors.transparent,
                            Colors.white.withOpacity(0.08),
                            Colors.transparent,
                          ],
                        ).createShader(bounds);
                      },
                      child: Container(color: Colors.white),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // Tag badge
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: accent.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              features[i]['tag'] as String,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),

        // Icon badge on bottom-right
        Positioned(
          bottom: -16,
          right: 20,
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accent, accent.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: accent.withOpacity(0.5),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              features[i]['icon'] as IconData,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomCard(int i, Color accent) {
    final isLast = i == features.length - 1;

    return Container(
      padding: const EdgeInsets.only(top: 36, left: 28, right: 28, bottom: 36),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FC),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(44),
          topRight: Radius.circular(44),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Accent line
          Container(
            width: 48,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: accent.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),

          // Feature number + title row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${(i + 1).toString().padLeft(2, '0')}",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: accent.withOpacity(0.12),
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  features[i]["title"],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0D1B2A),
                    height: 1.1,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Description
          Text(
            features[i]["desc"],
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF6B7A90),
              height: 1.6,
              letterSpacing: 0.1,
            ),
          ),

          const SizedBox(height: 28),

          // CTA
          if (isLast)
            Container(
              width: double.infinity,
              height: 58,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accent, accent.withOpacity(0.75)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: accent.withOpacity(0.45),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => Navigator.pop(context),
                  child: const Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Get Started",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.rocket_launch_rounded,
                            color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Swipe hint
                Row(
                  children: [
                    Icon(Icons.swipe_left_alt_rounded,
                        size: 18, color: const Color(0xFFB0BEC5)),
                    const SizedBox(width: 8),
                    const Text(
                      "Swipe to explore",
                      style: TextStyle(
                        color: Color(0xFFB0BEC5),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),

                // Quick nav arrow button
                GestureDetector(
                  onTap: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [accent, accent.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_forward_rounded,
                        color: Colors.white, size: 22),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}