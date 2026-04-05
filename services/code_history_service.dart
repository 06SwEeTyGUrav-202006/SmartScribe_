import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/code_history.dart';

class CodeHistoryService {
  static const String _key = "code_history";

  static Future<void> saveHistory(CodeHistory item) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_key) ?? [];

    existing.insert(0, jsonEncode(item.toJson())); // latest first
    await prefs.setStringList(_key, existing);
  }

  static Future<List<CodeHistory>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];

    return list
        .map((e) => CodeHistory.fromJson(jsonDecode(e)))
        .toList();
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
