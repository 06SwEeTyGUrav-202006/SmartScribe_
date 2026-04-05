

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

class CodeHistoryPage extends StatefulWidget {
  const CodeHistoryPage({super.key});

  @override
  State<CodeHistoryPage> createState() => _CodeHistoryPageState();
}

class _CodeHistoryPageState extends State<CodeHistoryPage> {
  // --- PALETTE COLORS ---
  final Color colorBgDark = Color(0xFF1A3263);      // Deep Navy
  final Color colorSecondary = Color(0xFF547792);  // Steel Blue
  final Color colorAccent = Color(0xFFFAB95B);     // Gold/Orange
  final Color colorLight = Color(0xFFE8E2DB);      // Beige/White
  final Color colorWhite = Color(0xFFFFFFFF);      // Pure White

  List<Map<String, dynamic>> history = [];
  String query = "";

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList("code_history") ?? [];

    final items = raw
        .map((e) => Map<String, dynamic>.from(jsonDecode(e)))
        .toList()
        .reversed
        .toList();

    setState(() {
      history = items;
    });
  }

  Future<void> saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = history.reversed.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList("code_history", encoded);
  }

  void deleteItem(int index) async {
    history.removeAt(index);
    await saveHistory();
    setState(() {});
  }

  void togglePin(int index) async {
    history[index]["pinned"] = !(history[index]["pinned"] ?? false);
    history.sort((a, b) {
      final ap = a["pinned"] == true ? 0 :1;
      final bp = b["pinned"] == true ? 0 :1;
      return ap.compareTo(bp);
    });
    await saveHistory();
    setState(() {});
  }

  void shareItem(Map item) {
    Share.share(
      "Language: ${item["language"]}\n\nCode:\n${item["code"]}\n\nOutput:\n${item["output"]}",
    );
  }

  void openDetails(Map item, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorWhite, // White Sheet Background
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Code Details",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorBgDark)),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.push_pin, color: colorAccent),
                      onPressed: () {
                        Navigator.pop(context);
                        togglePin(index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.share, color: colorSecondary),
                      onPressed: () => shareItem(item),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        Navigator.pop(context);
                        deleteItem(index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: colorBgDark),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 20),

            // Code Section
            Text("Code",
                style: TextStyle(color: colorBgDark, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorBgDark, // Navy Code Block
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorSecondary.withOpacity(0.3)),
              ),
              child: SelectableText(item["code"] ?? "",
                  style: const TextStyle(color: Colors.greenAccent, fontFamily: 'monospace', height: 1.5)),
            ),

            const SizedBox(height: 20),

            // Output Section
            Text("Output",
                style: TextStyle(color: colorBgDark, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorBgDark, // Navy Output Block
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorSecondary.withOpacity(0.3)),
              ),
              child: SelectableText(item["output"] ?? "",
                  style: const TextStyle(color: Colors.orangeAccent, fontFamily: 'monospace', height: 1.5)),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = history.where((item) {
      final code = (item["code"] ?? "").toString().toLowerCase();
      final title = (item["title"] ?? "").toString().toLowerCase();
      return code.contains(query.toLowerCase()) ||
          title.contains(query.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: colorWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: colorBgDark),
        title:  Text(
          "Code History",
          style: TextStyle(
            color: colorBgDark,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: colorLight,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search saved code...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(Icons.search, color: colorBgDark),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                ),
                onChanged: (v) => setState(() => query = v),
              ),
            ),
          ),

          // List
          Expanded(
            child: filtered.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_edu, size: 60, color: colorSecondary.withOpacity(0.4)),
                  SizedBox(height: 10),
                  Text("No matching history found", style: TextStyle(color: colorSecondary)),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final item = filtered[i];
                final index = history.indexOf(item);

                return Dismissible(
                  key: Key(item["time"] ?? i.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,   // ✅ moved here
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),

                  onDismissed: (_) => deleteItem(index),
                  child: Card(
                    color: colorLight,
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorWhite,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item["pinned"] == true ? Icons.push_pin : Icons.code,
                          color: item["pinned"] == true ? colorAccent : colorBgDark,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        item["title"] ?? "Untitled Code",
                        style: TextStyle(
                          color: colorBgDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          "${item["language"]?.toUpperCase() ?? ""} • ${item["time"] ?? ""}",
                          style: TextStyle(color: colorSecondary, fontSize: 13),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.share, color: colorSecondary, size: 20),
                        onPressed: () => shareItem(item),
                      ),
                      onTap: () => openDetails(item, index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}