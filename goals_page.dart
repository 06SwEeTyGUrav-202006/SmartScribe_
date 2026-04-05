
// import 'package:flutter/material.dart';
// import '../services/firestore_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class GoalsScreen extends StatelessWidget {
//   GoalsScreen({super.key});
//
//   final FirestoreService _firestore = FirestoreService();
//   final TextEditingController _goalController = TextEditingController();
//
//   String _priority = "Medium";
//   String _category = "Study";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('My Goals')),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () => _showAddGoalDialog(context),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _firestore.getGoals(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.flag_outlined, size: 80, color: Colors.grey),
//                   SizedBox(height: 10),
//                   Text("No goals yet 🌱", style: TextStyle(fontSize: 18)),
//                   Text("Add your first goal and start growing!"),
//                 ],
//               ),
//             );
//           }
//
//           final goals = snapshot.data!.docs;
//           final completed = goals.where((g) => g['completed'] == true).length;
//           final progress = completed / goals.length;
//
//           return Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text("Today's Progress", style: TextStyle(fontSize: 16)),
//                     const SizedBox(height: 6),
//                     LinearProgressIndicator(value: progress),
//                     const SizedBox(height: 6),
//                     Text("${(progress * 100).toInt()}% Completed"),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: ListView(
//                   children: goals.map((doc) {
//                     final data = doc.data() as Map<String, dynamic>;
//                     final title = data['title'] ?? 'Untitled';
//                     final category = data['category'] ?? 'General';
//                     final priority = data['priority'] ?? 'Medium';
//                     final completed = data['completed'] ?? false;
//
//                     return Dismissible(
//                       key: ValueKey(doc.id),
//                       background: Container(
//                         color: Colors.red,
//                         padding: const EdgeInsets.only(left: 20),
//                         alignment: Alignment.centerLeft,
//                         child: const Icon(Icons.delete, color: Colors.white),
//                       ),
//                       onDismissed: (_) => _firestore.deleteGoal(doc.id),
//                       child: Card(
//                         margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         child: ListTile(
//                           leading: Checkbox(
//                             value: completed,
//                             onChanged: (value) {
//                               _firestore.toggleGoal(doc.id, value!);
//                             },
//                           ),
//                           title: Text(
//                             title,
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               decoration: completed
//                                   ? TextDecoration.lineThrough
//                                   : null,
//                             ),
//                           ),
//                           subtitle: Text("$category • Priority: $priority"),
//                           trailing: IconButton(
//                             icon: const Icon(Icons.delete_outline, color: Colors.red),
//                             onPressed: () async {
//                               await _firestore.deleteGoal(doc.id);
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(content: Text("Goal deleted 🗑️")),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   void _showAddGoalDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Add Goal"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: _goalController,
//               decoration: const InputDecoration(hintText: "Enter your goal"),
//             ),
//             const SizedBox(height: 12),
//             DropdownButtonFormField(
//               value: _category,
//               items: const [
//                 DropdownMenuItem(value: "Study", child: Text("📚 Study")),
//                 DropdownMenuItem(value: "Health", child: Text("💪 Health")),
//                 DropdownMenuItem(value: "Personal", child: Text("🌱 Personal")),
//               ],
//               onChanged: (v) => _category = v!,
//               decoration: const InputDecoration(labelText: "Category"),
//             ),
//             DropdownButtonFormField(
//               value: _priority,
//               items: const [
//                 DropdownMenuItem(value: "Low", child: Text("Low")),
//                 DropdownMenuItem(value: "Medium", child: Text("Medium")),
//                 DropdownMenuItem(value: "High", child: Text("High")),
//               ],
//               onChanged: (v) => _priority = v!,
//               decoration: const InputDecoration(labelText: "Priority"),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (_goalController.text.isNotEmpty) {
//                 _firestore.addGoalWithMeta(
//                   _goalController.text.trim(),
//                   _category,
//                   _priority,
//                 );
//                 _goalController.clear();
//                 Navigator.pop(context);
//               }
//             },
//             child: const Text("Add"),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoalsScreen extends StatelessWidget {
  GoalsScreen({super.key});

  // --- PALETTE COLORS ---
  static const Color colorBgDark = Color(0xFF1A3263);      // Deep Navy
  static const Color colorSecondary = Color(0xFF547792);  // Steel Blue
  static const Color colorAccent = Color(0xFFFAB95B);     // Gold/Orange
  static const Color colorLight = Color(0xFFE8E2DB);      // Beige/White
  static const Color colorWhite = Color(0xFFFFFFFF);      // Pure White

  final FirestoreService _firestore = FirestoreService();
  final TextEditingController _goalController = TextEditingController();

  String _priority = "Medium";
  String _category = "Study";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite, // Main White Background
      appBar: AppBar(
        backgroundColor: colorWhite,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Goals',
          style: TextStyle(
            color: colorBgDark,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        iconTheme: const IconThemeData(color: colorBgDark),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: colorAccent,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: colorAccent.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: colorBgDark, size: 30),
          onPressed: () => _showAddGoalDialog(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.getGoals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: colorAccent));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.flag_outlined, size: 80, color: colorSecondary.withOpacity(0.4)),
                  const SizedBox(height: 20),
                  const Text("No goals yet 🌱", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colorBgDark)),
                  const SizedBox(height: 8),
                  const Text("Add your first goal and start growing!", style: TextStyle(color: colorSecondary)),
                ],
              ),
            );
          }

          final goals = snapshot.data!.docs;
          final completed = goals.where((g) => g['completed'] == true).length;
          final progress = completed / goals.length;

          return Column(
            children: [
              // --- PROGRESS SECTION ---
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorLight,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Today's Progress", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorBgDark)),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white,
                        valueColor: const AlwaysStoppedAnimation<Color>(colorAccent),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text("${(progress * 100).toInt()}% Completed", style: TextStyle(color: colorSecondary, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),

              // --- GOAL LIST ---
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  children: goals.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final title = data['title'] ?? 'Untitled';
                    final category = data['category'] ?? 'General';
                    final priority = data['priority'] ?? 'Medium';
                    final completed = data['completed'] ?? false;

                    return Dismissible(
                      key: ValueKey(doc.id),
                      background: Container(
                        color: Colors.red.shade400,
                        padding: const EdgeInsets.only(left: 20),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        alignment: Alignment.centerLeft,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) => _firestore.deleteGoal(doc.id),
                      child: Card(
                        color: colorLight, // Beige Card
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          leading: Checkbox(
                            value: completed,
                            activeColor: colorBgDark,
                            checkColor: colorAccent,
                            onChanged: (value) {
                              _firestore.toggleGoal(doc.id, value!);
                            },
                          ),
                          title: Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorBgDark,
                              decoration: completed ? TextDecoration.lineThrough : null,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              "$category • Priority: $priority",
                              style: const TextStyle(color: colorSecondary, fontSize: 13),
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () async {
                              await _firestore.deleteGoal(doc.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text("Goal deleted 🗑️", style: TextStyle(color: Colors.white)),
                                  backgroundColor: colorBgDark,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: colorLight, // Light background for dialog
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text("Add New Goal", style: TextStyle(color: colorBgDark, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _goalController,
                style: const TextStyle(color: colorBgDark, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: "Enter your goal",
                  filled: true,
                  fillColor: colorWhite,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // --- CATEGORY DROPDOWN ---
              DropdownButtonFormField(
                value: _category,
                style: const TextStyle(
                  color: colorBgDark, // Navy text inside dropdown
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                dropdownColor: colorWhite,
                icon: const Icon(Icons.keyboard_arrow_down, color: colorAccent), // Gold arrow
                items: const [
                  DropdownMenuItem(value: "Study", child: Text("📚 Study")),
                  DropdownMenuItem(value: "Health", child: Text("💪 Health")),
                  DropdownMenuItem(value: "Personal", child: Text("🌱 Personal")),
                ],
                onChanged: (v) => _category = v!,
                decoration: InputDecoration(
                  labelText: "Category",
                  labelStyle: const TextStyle(
                    color: colorBgDark, // Navy label
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: colorWhite,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18), // Taller box

                  // Navy Border
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: colorBgDark, width: 1.5),
                  ),

                  // Gold Border on Focus
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: colorAccent, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // --- PRIORITY DROPDOWN ---
              DropdownButtonFormField(
                value: _priority,
                style: const TextStyle(
                  color: colorBgDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                dropdownColor: colorWhite,
                icon: const Icon(Icons.keyboard_arrow_down, color: colorAccent),
                items: const [
                  DropdownMenuItem(value: "Low", child: Text("Low")),
                  DropdownMenuItem(value: "Medium", child: Text("Medium")),
                  DropdownMenuItem(value: "High", child: Text("High")),
                ],
                onChanged: (v) => _priority = v!,
                decoration: InputDecoration(
                  labelText: "Priority",
                  labelStyle: const TextStyle(
                    color: colorBgDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: colorWhite,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: colorBgDark, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: colorAccent, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: colorSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              if (_goalController.text.isNotEmpty) {
                _firestore.addGoalWithMeta(
                  _goalController.text.trim(),
                  _category,
                  _priority,
                );
                _goalController.clear();
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorBgDark,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Add Goal", style: TextStyle(color: colorAccent)),
          ),
        ],
      ),
    );
  }
}
