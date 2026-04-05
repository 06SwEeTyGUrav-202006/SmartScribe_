import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _plugin.initialize(initSettings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'daily_channel',
      'Daily Reminders',
      description: 'Daily study reminders',
      importance: Importance.max,
    );

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(channel);

    await Permission.notification.request();
    await Permission.scheduleExactAlarm.request();
  }

  /// ✅ INSTANT TEST (for debugging)
  static Future<void> showInstant() async {
    const androidDetails = AndroidNotificationDetails(
      'daily_channel',
      'Daily Reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      999,
      "🔔 SmartScribe Test",
      "Notification is working!",
      details,
    );
  }

  /// ✅ GENERIC DAILY REMINDER (Used by ReminderSettingsPage)
  static Future<void> scheduleDailyReminder({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'daily_channel',
      'Daily Reminders',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// 🔥 STREAK REMINDER (Auto every day at 8:00 PM)
  static Future<void> scheduleDailyStreakReminder() async {
    await scheduleDailyReminder(
      id: 100, // fixed ID for streak reminder
      title: "🔥 Don’t break your streak!",
      body: "Open SmartScribe today and keep your learning streak alive 💪",
      hour: 20,
      minute: 0,
    );
  }

  /// ❌ Cancel any notification by ID
  static Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }
}
