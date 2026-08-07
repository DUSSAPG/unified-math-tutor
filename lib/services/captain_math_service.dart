import 'package:flutter/foundation.dart';

/// Captain Math's mood/message state. Deliberately transient (no persisted
/// "fuel" economy like Captain Number) — Captain Math introduces a
/// discovery, offers a short encouragement, points out a connection, or
/// celebrates completion subtly. Never conversational, never blocking.
enum CaptainMathState { curious, encouraging, calm, celebrating }

class CaptainMathService {
  CaptainMathService._();
  static final instance = CaptainMathService._();

  final ValueNotifier<CaptainMathState> state =
      ValueNotifier(CaptainMathState.calm);
  final ValueNotifier<int> celebrationSerial = ValueNotifier(0);

  void showDiscoveryIntro() => state.value = CaptainMathState.curious;
  void showEncouragement() => state.value = CaptainMathState.encouraging;
  void showConnection() => state.value = CaptainMathState.calm;

  void showCompletion() {
    state.value = CaptainMathState.celebrating;
    celebrationSerial.value++;
  }
}
