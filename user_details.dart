import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailsPage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  // --- App Color Palette ---
  static const Color kDarkBlue = Color(0xFF1A3263);
  static const Color kMutedBlue = Color(0xFF547792);
  static const Color kGold = Color(0xFFFAB95B);
  static const Color kCream = Color(0xFFE8E2DB);
  static const Color kWhite = Color(0xFFFFFFFF);

  UserDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCream,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get(),
        builder: (context, snapshot) {
          // --- Loading State ---
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: kDarkBlue,
                strokeWidth: 3,
              ),
            );
          }

          // --- Error / No Data State ---
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 60, color: kMutedBlue),
                  const SizedBox(height: 16),
                  Text(
                    "No user data found",
                    style: TextStyle(
                      fontSize: 18,
                      color: kMutedBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          // --- Data Found ---
          var data = snapshot.data!.data() as Map<String, dynamic>;
          String name = data['name'] ?? 'User';
          String email = data['email'] ?? 'Not Provided';
          String uid = data['uid'] ?? user!.uid;

          return Stack(
            children: [
              // 1. Curved Header Background
              Container(
                height: 280,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kDarkBlue, const Color(0xFF2A4277)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: kDarkBlue.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
              ),

              // 2. Back Button & Title
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        "My Profile",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Main Content Card
              SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: 140, left: 20, right: 20, bottom: 40),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Profile Avatar
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: kGold, width: 3),
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: kCream,
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : "U",
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: kDarkBlue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Name
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: kDarkBlue,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Role / Subtitle
                      Text(
                        "SmartScribe User",
                        style: TextStyle(
                          fontSize: 14,
                          color: kMutedBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Info List
                      _buildInfoTile(
                        icon: Icons.person_outline,
                        title: "Full Name",
                        value: name,
                      ),
                      const Divider(height: 30, thickness: 1, color: Color(0xFFE8E2DB)),

                      _buildInfoTile(
                        icon: Icons.email_outlined,
                        title: "Email Address",
                        value: email,
                      ),
                      const Divider(height: 30, thickness: 1, color: Color(0xFFE8E2DB)),

                      _buildInfoTile(
                        icon: Icons.fingerprint,
                        title: "User ID",
                        value: uid,
                        isSmallText: true,
                      ),

                      const SizedBox(height: 20), // Bottom padding
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper Widget for Info Rows
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    bool isSmallText = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kDarkBlue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: kMutedBlue, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: kMutedBlue.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: isSmallText ? 12 : 16,
                  color: kDarkBlue,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}