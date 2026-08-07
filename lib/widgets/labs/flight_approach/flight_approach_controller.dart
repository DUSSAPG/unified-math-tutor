import 'package:flutter/material.dart';

import '../../../models/flight_approach_model.dart';

/// Drives a [FlightApproachView]'s [FlightApproachModel] and its
/// "Test Approach" flight animation — the logical model
/// ([FlightApproachModel]) stays entirely independent of the animation
/// state ([flightProgress]), matching the brief's "the mathematical state
/// must drive the animation" requirement: the painter only ever samples
/// [FlightApproachModel.altitudeAtHorizontalDistanceRemaining], never a
/// separately hand-animated path.
///
/// [motionEnabled] must be kept in sync by the owning widget (Reduce
/// Motion setting **and** the OS-level `MediaQuery.disableAnimationsOf`),
/// matching `FlightPathLabScreen`'s existing `_motionEnabled` convention —
/// when false, [testApproach] jumps straight to the final frame instead of
/// animating.
class FlightApproachController extends ChangeNotifier {
  FlightApproachController({
    required TickerProvider vsync,
    required FlightApproachModel initialModel,
  }) : _model = initialModel {
    _flightController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1400),
    )..addListener(notifyListeners);
  }

  FlightApproachModel _model;
  FlightApproachModel get model => _model;

  /// Set by the owning widget every build; see class doc.
  bool motionEnabled = true;

  late final AnimationController _flightController;

  bool get isFlying => _flightController.isAnimating;

  /// 0 at the starting position, 1 once the flight animation (or its
  /// Reduce-Motion instant jump) has finished.
  double get flightProgress => _flightController.value;

  bool _hasTested = false;
  bool get hasTested => _hasTested;

  void updateAngle(double radians) {
    _model = _model.copyWith(descentAngleRadians: radians);
    notifyListeners();
  }

  void updateSpeed(double metresPerSecond) {
    _model = _model.copyWith(airspeedMps: metresPerSecond);
    notifyListeners();
  }

  /// Replaces the whole model at once — used when loading a new deterministic
  /// challenge scenario ("Next Challenge"), as opposed to a single-field
  /// learner adjustment.
  void setModel(FlightApproachModel model) {
    _model = model;
    notifyListeners();
  }

  Future<void> testApproach() async {
    _hasTested = true;
    if (!motionEnabled) {
      _flightController.value = 1.0;
      return;
    }
    _flightController.reset();
    await _flightController.forward();
  }

  /// Returns to the pre-test starting frame without changing the current
  /// angle/speed inputs — "Try Again" adjusts and re-tests, it doesn't
  /// forget what the learner already chose.
  void reset() {
    _hasTested = false;
    _flightController.reset();
    notifyListeners();
  }

  @override
  void dispose() {
    _flightController.dispose();
    super.dispose();
  }
}
