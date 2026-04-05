import 'dart:math';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class FlashCardsPage extends StatefulWidget {
  final String summaryText;
  final String summaryId; // Firestore document id

  const FlashCardsPage({
    super.key,
    required this.summaryText,
    required this.summaryId,
  });

  @override
  State<FlashCardsPage> createState() => _FlashCardsPageState();
}

class _FlashCardsPageState extends State<FlashCardsPage> {
  int currentIndex = 0;
  late List<Map<String, dynamic>> cards;

  final FirestoreService _firestore = FirestoreService();

  @override
  void initState() {
    super.initState();
    cards = _generateFlashCards(widget.summaryText);
    _loadProgress();
  }

  List<Map<String, dynamic>> _generateFlashCards(String summary) {
    final lines = summary
        .split(RegExp(r'[.\n•-]'))
        .map((e) => e.trim())
        .where((e) => e.length > 20)
        .toList();

    return List.generate(lines.length, (i) {
      return {
        "front": "Recall this concept",
        "back": lines[i],
        "remembered": false,
        "saved": false,
        "showBack": false,
      };
    });
  }

  Future<void> _loadProgress() async {
    final data = await _firestore.getFlashCardProgress(widget.summaryId);

    if (data == null) return;

    final remembered = List<int>.from(data["rememberedIndexes"] ?? []);
    final saved = List<int>.from(data["savedIndexes"] ?? []);
    final lastIndex = data["lastIndex"] ?? 0;

    setState(() {
      currentIndex = lastIndex;

      for (int i = 0; i < cards.length; i++) {
        cards[i]["remembered"] = remembered.contains(i);
        cards[i]["saved"] = saved.contains(i);
      }
    });
  }

  Future<void> _saveProgress() async {
    final remembered = <int>[];
    final saved = <int>[];

    for (int i = 0; i < cards.length; i++) {
      if (cards[i]["remembered"] == true) remembered.add(i);
      if (cards[i]["saved"] == true) saved.add(i);
    }

    await _firestore.saveFlashCardProgress(
      summaryId: widget.summaryId,
      remembered: remembered,
      saved: saved,
      lastIndex: currentIndex,
    );
  }

  void nextCard() {
    if (currentIndex < cards.length - 1) {
      setState(() => currentIndex++);
      _saveProgress();
    }
  }

  void prevCard() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
      _saveProgress();
    }
  }

  void shuffleCards() {
    setState(() {
      cards.shuffle(Random());
      currentIndex = 0;
    });
    _saveProgress();
  }

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return const Scaffold(body: Center(child: Text("No flash cards 😕")));
    }

    final card = cards[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flash Cards"),
        actions: [
          IconButton(icon: const Icon(Icons.shuffle), onPressed: shuffleCards)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Card ${currentIndex + 1} / ${cards.length}"),

            const SizedBox(height: 20),

            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    card["showBack"] = !card["showBack"];
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      card["showBack"] ? card["back"] : card["front"],
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(icon: const Icon(Icons.arrow_back), onPressed: prevCard),

                IconButton(
                  icon: Icon(
                    card["remembered"]
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    setState(() {
                      card["remembered"] = !card["remembered"];
                    });
                    _saveProgress();
                  },
                ),

                IconButton(
                  icon: Icon(
                    card["saved"] ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    setState(() {
                      card["saved"] = !card["saved"];
                    });
                    _saveProgress();
                  },
                ),

                IconButton(icon: const Icon(Icons.arrow_forward), onPressed: nextCard),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
