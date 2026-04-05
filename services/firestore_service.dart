import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Current user ID
  String get userId => _auth.currentUser!.uid;

  // ---------------- POMODORO ----------------
  Future<void> savePomodoroSession(int minutes) async {
    final ref = _db.collection('users').doc(userId);

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(ref);

      int totalMinutes = 0;
      int sessions = 0;

      if (snapshot.exists) {
        totalMinutes = snapshot['totalMinutes'] ?? 0;
        sessions = snapshot['sessionsCompleted'] ?? 0;
      }

      transaction.set(ref, {
        'totalMinutes': totalMinutes + minutes,
        'sessionsCompleted': sessions + 1,
        'lastSession': Timestamp.now(),
      }, SetOptions(merge: true));
    });
  }

  // ---------------- GOALS ----------------
  Stream<QuerySnapshot> getGoals() {
    return _db
        .collection('users')
        .doc(userId)
        .collection('goals')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> addGoal(String title) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('goals')
        .add({
      'title': title,
      'completed': false,
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> addGoalWithMeta(String title, String category, String priority) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('goals')
        .add({
      'title': title,
      'completed': false,
      'category': category,
      'priority': priority,
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> toggleGoal(String goalId, bool value) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(goalId)
        .update({'completed': value});
  }

  Future<void> deleteGoal(String goalId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(goalId)
        .delete();
  }

  // ---------------- FLASH CARDS ----------------

  Future<void> saveFlashCardProgress({
    required String summaryId,
    required List<int> remembered,
    required List<int> saved,
    required int lastIndex,
  }) async {
    await _db
        .collection("users")
        .doc(userId)
        .collection("flashcards")
        .doc(summaryId)
        .set({
      "rememberedIndexes": remembered,
      "savedIndexes": saved,
      "lastIndex": lastIndex,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getFlashCardProgress(String summaryId) async {
    final doc = await _db
        .collection("users")
        .doc(userId)
        .collection("flashcards")
        .doc(summaryId)
        .get();

    return doc.data();
  }
}
