import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/services/mascot_fuel_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('fuel persists and caps at 100', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final service = MascotFuelService(preferences: prefs);

    await service.addFuel(70);
    await service.addFuel(50);

    expect(await service.getFuel(), 100);
    final reloaded = MascotFuelService(preferences: prefs);
    expect(await reloaded.getFuel(), 100);
  });

  test('daily mission resets when the date changes', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    var now = DateTime(2026, 6, 6, 10);
    final service = MascotFuelService(
      preferences: prefs,
      clock: () => now,
    );

    await service.incrementDailyMission();
    await service.incrementDailyMission();
    expect(await service.getDailyMissionProgress(), 2);

    now = DateTime(2026, 6, 7, 9);
    expect(await service.getDailyMissionProgress(), 0);
  });
}
