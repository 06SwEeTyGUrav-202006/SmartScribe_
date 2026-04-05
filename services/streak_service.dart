import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  static SharedPreferences? _local;

  static Future<void> _init() async {
    _local ??= await SharedPreferences.getInstance();
  }

  static Future<void> updateStreakIfNeeded() async {
    try {
      await _init();

      final lastUsed = _local!.getString('last_used_date');
      final today = DateTime.now().toIso8601String().substring(0, 10);

      if (lastUsed == today) return;

      int streak = _local!.getInt('streak') ?? 0;

      if (lastUsed != null) {
        final lastDate = DateTime.parse(lastUsed);
        final diff = DateTime.now().difference(lastDate).inDays;

        if (diff == 1) {
          streak++;
        } else {
          streak = 1;
        }
      } else {
        streak = 1;
      }

      await _local!.setInt('streak', streak);
      await _local!.setString('last_used_date', today);

      print("🔥 Streak updated: $streak");
    } catch (e) {
      print("❌ Streak init failed: $e");
    }
  }

  static Future<int> getStreak() async {
    await _init();
    return _local!.getInt('streak') ?? 0;
  }
}
