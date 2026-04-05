
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'practice_options_page.dart';
import 'read_summary_page.dart';
import 'edit_summary_page..dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  // --- PALETTE COLORS ---
  final Color colorBgDark = Color(0xFF1A3263);      // Deep Navy
  final Color colorSecondary = Color(0xFF547792);  // Steel Blue
  final Color colorAccent = Color(0xFFFAB95B);     // Gold/Orange
  final Color colorLight = Color(0xFFE8E2DB);      // Beige/White
  final Color colorWhite = Color(0xFFFFFFFF);      // Pure White

  String searchQuery = "";

  Future<void> deleteSummary(String docId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('records')
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: colorWhite, // Changed background to White
      appBar: AppBar(
        backgroundColor: colorWhite, // White AppBar
        elevation: 1,
        iconTheme: IconThemeData(color: colorBgDark), // Dark icon for contrast
        title: Text( // Removed const to use colorBgDark
          "Your Summaries",
          style: TextStyle(
            color: colorBgDark, // Dark Text for White background
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /// 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: colorLight, // Beige container for search bar
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search summaries...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(Icons.search, color: colorSecondary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
          ),

          /// 📚 SUMMARY LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('records')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                /// ⏳ Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFFAB95B)));
                }

                /// ❌ Error
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colorBgDark),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_open_outlined, size: 60, color: colorSecondary.withOpacity(0.6)),
                        const SizedBox(height: 10),
                        Text("No summaries yet 🫥", style: TextStyle(color: colorBgDark)), // Dark text
                      ],
                    ),
                  );
                }

                final docs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final summary =
                  (data['summary'] ?? '').toString().toLowerCase();
                  return summary.contains(searchQuery);
                }).toList();

                if (docs.isEmpty) {
                  return Center(child: Text("No matching results 🔍", style: TextStyle(color: colorBgDark)));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;

                    final summary = data['summary']?.toString() ?? '';
                    final transcription =
                        data['transcription']?.toString() ?? '';

                    return Card(
                      color: colorLight, // Using Beige for cards on White background
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text( // Removed const
                              "📝 Summary",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorBgDark, // Dark text
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              summary.length > 150
                                  ? "${summary.substring(0, 150)}..."
                                  : summary,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.5,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 18),

                            /// 🔘 ACTION BUTTONS
                            Row(
                              children: [
                                // READ BUTTON
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.menu_book, size: 18),
                                  label: Text("Read", style: TextStyle(color: colorBgDark, fontWeight: FontWeight.bold)), // Removed const
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ReadSummaryPage(
                                          title: "Summary",
                                          content: summary,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorAccent,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // PRACTICE BUTTON
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.quiz, size: 18),
                                  label: const Text("Practice"),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PracticeOptionsPage(
                                          summaryText: summary,
                                          summaryId: doc.id,
                                        ),
                                      ),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: colorSecondary,
                                    side: BorderSide(color: colorSecondary),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const Spacer(),

                                /// ✏️ EDIT
                                IconButton(
                                  icon: Icon(Icons.edit_outlined, color: colorSecondary),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EditSummaryPage(
                                          docId: doc.id,
                                          initialSummary: summary,
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                /// 🗑 DELETE
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () async {
                                    await deleteSummary(doc.id);
                                  },
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            /// 🔽 TRANSCRIPTION
                            ExpansionTile(
                              tilePadding: EdgeInsets.zero,
                              title: Text(
                                "View Full Transcription",
                                style: TextStyle(fontSize: 14, color: colorSecondary, fontWeight: FontWeight.w600),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                  child: Text(
                                    transcription,
                                    style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}