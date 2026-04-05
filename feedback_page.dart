import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  // Color Palette
  static const Color colorBgDark = Color(0xFF1A3263);      // Deep Navy
  static const Color colorSecondary = Color(0xFF547792);  // Steel Blue
  static const Color colorAccent = Color(0xFFFAB95B);     // Gold/Orange
  static const Color colorLight = Color(0xFFE8E2DB);      // Beige/White
  static const Color colorWhite = Color(0xFFFFFFFF);      // Pure White

  int _rating = 0;
  bool _isSubmitting = false;

  List<String> selectedFeatures = [];
  String performance = "";
  String easeOfUse = "";
  String recommend = "";

  final TextEditingController likeController = TextEditingController();
  final TextEditingController problemController = TextEditingController();
  final TextEditingController suggestionController = TextEditingController();
  final TextEditingController otherFeatureController = TextEditingController();

  final List<String> features = [
    "Upload Audio",
    "Record Audio",
    "Summary (Quiz,Flash Card)",
    "Python Compiler",
    "Focus Timer or Set Goals ",
  ];

  Widget buildStar(int index) {
    return IconButton(
      icon: Icon(
        index <= _rating ? Icons.star : Icons.star_border,
        color: colorAccent,
        size: 36, // Slightly larger for better touch target
      ),
      onPressed: () {
        setState(() {
          _rating = index;
        });
      },
    );
  }

  // Reusable Section Container Style
  Widget _buildSection({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // Reusable Text Field Style
  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: colorBgDark),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: colorSecondary),
        filled: true,
        fillColor: colorWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: colorBgDark, width: 2),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
  // Helper method for consistent, professional SnackBars
  void _showCustomSnackBar(String message, {bool isError = false}) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle,
            color: isError ? Colors.white : colorAccent, // Gold icon for success
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: isError
          ? Colors.red.shade900  // Dark Red for errors
          : colorBgDark,         // Navy for success
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Matches your container style
      ),
      margin: const EdgeInsets.all(16), // Margin from screen edges
      duration: const Duration(seconds: 3),
      elevation: 6,
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> submitFeedback() async {
    if (_rating == 0) {
      _showCustomSnackBar("Please select a rating.", isError: true);
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showCustomSnackBar("User not logged in.", isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await FirebaseFirestore.instance.collection("feedbacks").add({
        "rating": _rating,
        "featuresUsed": [
          ...selectedFeatures,
          if (otherFeatureController.text.isNotEmpty)
            otherFeatureController.text.trim()
        ],
        "performance": performance,
        "easeOfUse": easeOfUse,
        "likedMost": likeController.text.trim(),
        "problems": problemController.text.trim(),
        "suggestions": suggestionController.text.trim(),
        "recommend": recommend,
        "userId": user.uid,
        "createdAt": FieldValue.serverTimestamp(),
      });

      // Professional Success Message
      _showCustomSnackBar("Thank you for your feedback!");

    } catch (e) {
      print("Firestore Error: $e");

      // Professional Error Message
      _showCustomSnackBar("Submission failed. Try again.", isError: true);
    }

    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: colorBgDark,
        title: const Text("We Value Your Feedback", style: TextStyle(color: colorWhite)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: colorWhite),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Rating Section
            _buildSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Overall Rating",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorBgDark
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(5, (index) => buildStar(index + 1)),
                  ),
                ],
              ),
            ),

            // Features Section
            _buildSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Which features did you use?",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorBgDark
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...features.map((feature) {
                    return CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(feature, style: const TextStyle(color: colorBgDark)),
                      activeColor: colorBgDark,
                      value: selectedFeatures.contains(feature),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            selectedFeatures.add(feature);
                          } else {
                            selectedFeatures.remove(feature);
                          }
                        });
                      },
                    );
                  }),
                  const SizedBox(height: 10),
                  _buildTextField(otherFeatureController, "Other (please specify)"),
                ],
              ),
            ),

            // Performance & Ease of Use (Combined for better flow or separate) - Kept separate here
            _buildSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "App Performance",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorBgDark
                    ),
                  ),
                  ...["Very Fast", "Good", "Average", "Slow", "Crashes Often"]
                      .map((option) => RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(option, style: const TextStyle(color: colorBgDark)),
                    activeColor: colorSecondary,
                    value: option,
                    groupValue: performance,
                    onChanged: (value) {
                      setState(() {
                        performance = value!;
                      });
                    },
                  )),
                ],
              ),
            ),

            _buildSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ease of Use",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorBgDark
                    ),
                  ),
                  ...["Very Easy", "Easy", "Neutral", "Confusing", "Very Difficult"]
                      .map((option) => RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(option, style: const TextStyle(color: colorBgDark)),
                    activeColor: colorSecondary,
                    value: option,
                    groupValue: easeOfUse,
                    onChanged: (value) {
                      setState(() {
                        easeOfUse = value!;
                      });
                    },
                  )),
                ],
              ),
            ),

            // Open Ended Questions
            _buildSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "What did you like most?",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorBgDark
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(likeController, "Your thoughts...", maxLines: 3),
                ],
              ),
            ),

            _buildSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "What problems did you face?",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorBgDark
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(problemController, "Describe the issue...", maxLines: 3),
                ],
              ),
            ),

            _buildSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "What features should we add?",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorBgDark
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(suggestionController, "Your suggestions...", maxLines: 3),
                ],
              ),
            ),

            // Recommendation Section
            _buildSection(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Would you recommend this app?",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorBgDark
                    ),
                  ),
                  ...["Yes", "Maybe", "No"]
                      .map((option) => RadioListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(option, style: const TextStyle(color: colorBgDark)),
                    activeColor: colorBgDark,
                    value: option,
                    groupValue: recommend,
                    onChanged: (value) {
                      setState(() {
                        recommend = value!;
                      });
                    },
                  )),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorBgDark,
                  foregroundColor: colorWhite,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isSubmitting ? null : submitFeedback,
                child: _isSubmitting
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: colorWhite,
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  "Submit Feedback",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40), // Extra spacing at bottom
          ],
        ),
      ),
    );
  }
}