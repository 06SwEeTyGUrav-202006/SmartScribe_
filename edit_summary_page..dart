import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditSummaryPage extends StatefulWidget {
  final String docId;
  final String initialSummary;

  const EditSummaryPage({
    super.key,
    required this.docId,
    required this.initialSummary,
  });

  @override
  State<EditSummaryPage> createState() => _EditSummaryPageState();
}

class _EditSummaryPageState extends State<EditSummaryPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialSummary);
  }

  Future<void> saveEdit() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('records')
        .doc(widget.docId)
        .update({
      "summary": _controller.text,
      "editedAt": FieldValue.serverTimestamp(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Summary")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Edit your summary...",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: saveEdit,
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
