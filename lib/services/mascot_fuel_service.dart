import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MascotState { greeting, thinking, success, encouragement, levelUp }

class MascotFuelService {
  MascotFuelService({
    SharedPreferences? preferences,
    DateTime Function()? clock,
  })  : _preferences = preferences,
        _clock = clock ?? DateTime.now;

  static final MascotFuelService instance = MascotFuelService();
  static const missionTarget = 5;
  static const _fuelKey = 'captain_number_fuel';
  static const _missionDateKey = 'captain_number_mission_date';
  static const _missionProgressKey = 'captain_number_mission_progress';

  final DateTime Function() _clock;
  SharedPreferences? _preferences;
  bool _initialized = false;

  final ValueNotifier<int> fuel = ValueNotifier<int>(0);
  final ValueNotifier<int> dailyMissionProgress = ValueNotifier<int>(0);
  final ValueNotifier<MascotState> mascotState =
      ValueNotifier<MascotState>(MascotState.greeting);
  final ValueNotifier<int> celebrationSerial = ValueNotifier<int>(0);

  Future<void> init() async {
    if (_initialized) return;
    _preferences ??= await SharedPreferences.getInstance();
    await resetIfNewDay();
    fuel.value = _preferences!.getInt(_fuelKey) ?? 0;
    dailyMissionProgress.value = _preferences!.getInt(_missionProgressKey) ?? 0;
    _initialized = true;
  }

  Future<int> getFuel() async {
    await init();
    return fuel.value;
  }

  Future<int> addFuel(int delta) async {
    await init();
    final previous = fuel.value;
    final next = (previous + delta).clamp(0, 100);
    fuel.value = next;
    mascotState.value = next == 100 && previous < 100
        ? MascotState.levelUp
        : MascotState.success;
    await _preferences!.setInt(_fuelKey, next);
    return next;
  }

  Future<int> getDailyMissionProgress() async {
    await init();
    await resetIfNewDay();
    return dailyMissionProgress.value;
  }

  Future<int> incrementDailyMission() async {
    await init();
    await resetIfNewDay();
    final previous = dailyMissionProgress.value;
    final next = (previous + 1).clamp(0, missionTarget);
    dailyMissionProgress.value = next;
    await _preferences!.setInt(_missionProgressKey, next);
    if (previous < missionTarget && next == missionTarget) {
      celebrationSerial.value++;
      mascotState.value = MascotState.levelUp;
    }
    return next;
  }

  Future<void> resetIfNewDay() async {
    _preferences ??= await SharedPreferences.getInstance();
    final today = _dateKey(_clock());
    if (_preferences!.getString(_missionDateKey) == today) return;
    await _preferences!.setString(_missionDateKey, today);
    await _preferences!.setInt(_missionProgressKey, 0);
    dailyMissionProgress.value = 0;
  }

  void showIncorrectFeedback() {
    mascotState.value = MascotState.encouragement;
  }

  static String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
