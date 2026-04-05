import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';

class ReminderSettingsPage extends StatefulWidget {
  const ReminderSettingsPage({super.key});

  @override
  State<ReminderSettingsPage> createState() => _ReminderSettingsPageState();
}

class _ReminderSettingsPageState extends State<ReminderSettingsPage> {
  bool morningOn = false;
  bool nightOn = false;

  TimeOfDay morningTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay nightTime = const TimeOfDay(hour: 21, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      morningOn = prefs.getBool('morningOn') ?? false;
      nightOn = prefs.getBool('nightOn') ?? false;
      morningTime = TimeOfDay(
        hour: prefs.getInt('morningHour') ?? 8,
        minute: prefs.getInt('morningMinute') ?? 0,
      );
      nightTime = TimeOfDay(
        hour: prefs.getInt('nightHour') ?? 21,
        minute: prefs.getInt('nightMinute') ?? 0,
      );
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('morningOn', morningOn);
    await prefs.setBool('nightOn', nightOn);
    await prefs.setInt('morningHour', morningTime.hour);
    await prefs.setInt('morningMinute', morningTime.minute);
    await prefs.setInt('nightHour', nightTime.hour);
    await prefs.setInt('nightMinute', nightTime.minute);
  }

  Future<void> pickTime(bool isMorning) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isMorning ? morningTime : nightTime,
    );

    if (picked != null) {
      setState(() {
        if (isMorning) {
          morningTime = picked;
        } else {
          nightTime = picked;
        }
      });

      await _saveSettings();

      if (isMorning && morningOn) {
        await NotificationService.scheduleDailyReminder(
          id: 1,
          title: "🌅 Morning Revision",
          body: "Start your day with revision 📚",
          hour: morningTime.hour,
          minute: morningTime.minute,
        );
      }

      if (!isMorning && nightOn) {
        await NotificationService.scheduleDailyReminder(
          id: 2,
          title: "🌙 Night Revision",
          body: "End your day strong 💪",
          hour: nightTime.hour,
          minute: nightTime.minute,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("⏰ Reminder Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text("🌅 Morning Reminder"),
              subtitle: Text(morningTime.format(context)),
              value: morningOn,
              onChanged: (val) async {
                setState(() => morningOn = val);
                await _saveSettings();
                if (val) {
                  await NotificationService.scheduleDailyReminder(
                    id: 1,
                    title: "🌅 Morning Revision",
                    body: "Start your day with revision 📚",
                    hour: morningTime.hour,
                    minute: morningTime.minute,
                  );
                } else {
                  await NotificationService.cancel(1);
                }
              },
            ),
            ElevatedButton(
              onPressed: () => pickTime(true),
              child: const Text("Change Morning Time"),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text("🌙 Night Reminder"),
              subtitle: Text(nightTime.format(context)),
              value: nightOn,
              onChanged: (val) async {
                setState(() => nightOn = val);
                await _saveSettings();
                if (val) {
                  await NotificationService.scheduleDailyReminder(
                    id: 2,
                    title: "🌙 Night Revision",
                    body: "End your day strong 💪",
                    hour: nightTime.hour,
                    minute: nightTime.minute,
                  );
                } else {
                  await NotificationService.cancel(2);
                }
              },
            ),
            ElevatedButton(
              onPressed: () => pickTime(false),
              child: const Text("Change Night Time"),
            ),
          ],
        ),
      ),
    );
  }
}
