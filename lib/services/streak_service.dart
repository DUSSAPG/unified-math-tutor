import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  StreakService._();
  static final instance = StreakService._();

  static const _countKey = 'learning_streak_days';
  static const _lastCompletionKey = 'learning_streak_last_completion';
  static const milestones = {7, 14, 30};

  late SharedPreferences _prefs;
  final ValueNotifier<int> days = ValueNotifier(0);
  final ValueNotifier<int> celebrationSerial = ValueNotifier(0);
  final ValueNotifier<int?> lastMilestone = ValueNotifier(null);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    days.value = _prefs.getInt(_countKey) ?? 0;
  }

  Future<bool> recordSessionCompletion() async {
    final today = DateTime.now();
    final currentDay = DateTime(today.year, today.month, today.day);
    final saved = _prefs.getString(_lastCompletionKey);
    final lastDay = saved == null ? null : DateTime.parse(saved);
    if (lastDay == currentDay) return false;
    final yesterday = currentDay.subtract(const Duration(days: 1));
    days.value = lastDay == yesterday ? days.value + 1 : 1;
    await _prefs.setInt(_countKey, days.value);
    await _prefs.setString(_lastCompletionKey, currentDay.toIso8601String());
    celebrationSerial.value++;
    final isMilestone = milestones.contains(days.value);
    lastMilestone.value = isMilestone ? days.value : null;
    return isMilestone;
  }
}
