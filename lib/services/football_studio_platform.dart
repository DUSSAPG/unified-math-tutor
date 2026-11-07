import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:unified_math_tutor/models/companion_app.dart';

abstract interface class FootballStudioPlatform {
  bool get supportsAndroid;

  Future<bool> isInstalled();

  Future<bool> launch();
}

class MethodChannelFootballStudioPlatform implements FootballStudioPlatform {
  const MethodChannelFootballStudioPlatform({
    MethodChannel channel = const MethodChannel(
      'com.quantumlab.unified_math_tutor/football_studio',
    ),
  }) : _channel = channel;

  final MethodChannel _channel;

  @override
  bool get supportsAndroid => defaultTargetPlatform == TargetPlatform.android;

  @override
  Future<bool> isInstalled() => _invokeBoolean('isInstalled');

  @override
  Future<bool> launch() => _invokeBoolean('launch');

  Future<bool> _invokeBoolean(String method) async {
    final result = await _channel.invokeMethod<bool>(method);
    if (result == null) {
      throw PlatformException(
        code: 'invalid_response',
        message: 'Football Studio returned no availability result.',
      );
    }
    return result;
  }
}

enum CompanionLaunchResult { launched, unavailable, unsupported, failed }

class FootballStudioCompanionService {
  const FootballStudioCompanionService(this.platform);

  final FootballStudioPlatform platform;

  Future<CompanionAvailability> checkAvailability() async {
    if (!platform.supportsAndroid) {
      return CompanionAvailability.unsupported;
    }
    try {
      return await platform.isInstalled()
          ? CompanionAvailability.installed
          : CompanionAvailability.notInstalled;
    } on PlatformException {
      return CompanionAvailability.checkFailed;
    } on MissingPluginException {
      return CompanionAvailability.checkFailed;
    }
  }

  Future<CompanionLaunchResult> launch() async {
    if (!platform.supportsAndroid) return CompanionLaunchResult.unsupported;
    try {
      if (!await platform.isInstalled()) {
        return CompanionLaunchResult.unavailable;
      }
      return await platform.launch()
          ? CompanionLaunchResult.launched
          : CompanionLaunchResult.unavailable;
    } on PlatformException {
      return CompanionLaunchResult.failed;
    } on MissingPluginException {
      return CompanionLaunchResult.failed;
    }
  }
}
