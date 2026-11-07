import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/companion_app.dart';
import 'package:unified_math_tutor/services/football_studio_platform.dart';

class _FakeFootballStudioPlatform implements FootballStudioPlatform {
  _FakeFootballStudioPlatform({
    this.supportsAndroid = true,
    this.installed = true,
    this.launchResult = true,
    this.checkError,
    this.launchError,
  });

  @override
  bool supportsAndroid;
  bool installed;
  bool launchResult;
  Object? checkError;
  Object? launchError;
  var checks = 0;
  var launches = 0;

  @override
  Future<bool> isInstalled() async {
    checks++;
    if (checkError case final error?) throw error;
    return installed;
  }

  @override
  Future<bool> launch() async {
    launches++;
    if (launchError case final error?) throw error;
    return launchResult;
  }
}

void main() {
  group('FootballStudioCompanionService', () {
    test('checks for installation only on Android', () async {
      final platform = _FakeFootballStudioPlatform(supportsAndroid: false);
      final availability = await FootballStudioCompanionService(
        platform,
      ).checkAvailability();

      expect(availability, CompanionAvailability.unsupported);
      expect(platform.checks, 0);
    });

    test('reports installed and missing companion states', () async {
      final installed = _FakeFootballStudioPlatform();
      final missing = _FakeFootballStudioPlatform(installed: false);

      expect(
        await FootballStudioCompanionService(installed).checkAvailability(),
        CompanionAvailability.installed,
      );
      expect(
        await FootballStudioCompanionService(missing).checkAvailability(),
        CompanionAvailability.notInstalled,
      );
    });

    test(
      'reports availability check failures without claiming installation',
      () async {
        final platform = _FakeFootballStudioPlatform(
          checkError: PlatformException(code: 'check_failed'),
        );

        expect(
          await FootballStudioCompanionService(platform).checkAvailability(),
          CompanionAvailability.checkFailed,
        );
      },
    );

    test('launches only after an installed check succeeds', () async {
      final platform = _FakeFootballStudioPlatform();

      expect(
        await FootballStudioCompanionService(platform).launch(),
        CompanionLaunchResult.launched,
      );
      expect(platform.checks, 1);
      expect(platform.launches, 1);
    });

    test('does not attempt launch when unavailable or unsupported', () async {
      final missing = _FakeFootballStudioPlatform(installed: false);
      final unsupported = _FakeFootballStudioPlatform(supportsAndroid: false);

      expect(
        await FootballStudioCompanionService(missing).launch(),
        CompanionLaunchResult.unavailable,
      );
      expect(
        await FootballStudioCompanionService(unsupported).launch(),
        CompanionLaunchResult.unsupported,
      );
      expect(missing.launches, 0);
      expect(unsupported.checks, 0);
      expect(unsupported.launches, 0);
    });

    test('reports a launch failure explicitly', () async {
      final platform = _FakeFootballStudioPlatform(
        launchError: PlatformException(code: 'launch_failed'),
      );

      expect(
        await FootballStudioCompanionService(platform).launch(),
        CompanionLaunchResult.failed,
      );
    });

    test('reports a failed launch result as unavailable', () async {
      final platform = _FakeFootballStudioPlatform(launchResult: false);

      expect(
        await FootballStudioCompanionService(platform).launch(),
        CompanionLaunchResult.unavailable,
      );
    });
  });
}
