import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../models/spatial_cube_orientation.dart';

/// Pixels-of-drag-per-radian sensitivity — tuned so a comfortable single
/// drag gesture (roughly a third of a typical phone width) can turn the
/// cube a quarter-turn.
const double _kDragSensitivity = math.pi / 260;

/// Per-second exponential decay applied to drag-release velocity — after
/// one second, roughly 6% of the initial spin speed remains.
const double _kInertiaDecayPerSecond = 0.06;

/// Velocity (radians/second) below which inertia is considered settled.
const double _kInertiaStopThreshold = 0.05;

/// The six fixed views [stepAutoDemo] cycles through when Reduce Motion is
/// on — a static "look at every face" sequence with no continuous spin, in
/// place of [startAutoDemo]'s slow rotation.
const List<CubeOrientation> kSpatialCubeDemoSteps = [
  CubeOrientation.initial, // front
  CubeOrientation(yaw: math.pi / 2, pitch: 0), // right
  CubeOrientation(yaw: math.pi, pitch: 0), // back
  CubeOrientation(yaw: -math.pi / 2, pitch: 0), // left
  CubeOrientation(yaw: 0, pitch: -math.pi / 2), // top
  CubeOrientation(yaw: 0, pitch: math.pi / 2), // bottom
];

/// Drives a [SpatialCube]'s [CubeOrientation] from drag gestures, keyboard
/// nudges, snap/reset commands and an optional auto-demonstration —
/// entirely independent of the painter, per the brief's "maintain a
/// logical cube orientation model independently of visual animation."
///
/// [motionEnabled] must be kept in sync by the owning widget (Reduce Motion
/// setting OR the OS-level `MediaQuery.disableAnimationsOf`, matching
/// [FlightPathLabScreen]'s `_motionEnabled` convention) — when false, drag
/// release never carries inertia, snaps/reset happen instantly, and the
/// auto-demo becomes a manual step-through instead of a continuous spin.
class SpatialCubeController extends ChangeNotifier {
  SpatialCubeController({
    required TickerProvider vsync,
    CubeOrientation initialOrientation = CubeOrientation.initial,
  })  : _vsync = vsync,
        _orientation = initialOrientation {
    _snapController = AnimationController(
      vsync: _vsync,
      duration: const Duration(milliseconds: 260),
    )..addListener(_onSnapTick);
    _demoController = AnimationController(
      vsync: _vsync,
      duration: const Duration(seconds: 16),
    )..addListener(_onDemoTick);
    _inertiaTicker = _vsync.createTicker(_onInertiaTick);
  }

  final TickerProvider _vsync;
  CubeOrientation _orientation;
  CubeOrientation get orientation => _orientation;

  /// Set by the owning widget every build; see class doc.
  bool motionEnabled = true;

  Offset? _lastDragPosition;
  DateTime? _lastDragTime;
  double _yawVelocity = 0; // radians/second
  double _pitchVelocity = 0;

  late final AnimationController _snapController;
  CubeOrientation? _snapFrom;
  CubeOrientation? _snapTo;

  late final AnimationController _demoController;
  double _demoStartYaw = 0;
  bool _autoDemoRunning = false;
  bool get isAutoDemoRunning => _autoDemoRunning;

  int _demoStepIndex = 0;

  late final Ticker _inertiaTicker;
  Duration _lastInertiaElapsed = Duration.zero;
  bool _inertiaRunning = false;

  // --- Drag ---------------------------------------------------------------

  void dragStart(Offset position) {
    stopInertia();
    stopAutoDemo();
    _lastDragPosition = position;
    _lastDragTime = DateTime.now();
    _yawVelocity = 0;
    _pitchVelocity = 0;
  }

  void dragUpdate(Offset position) {
    final lastPosition = _lastDragPosition;
    final lastTime = _lastDragTime;
    _lastDragPosition = position;
    _lastDragTime = DateTime.now();
    if (lastPosition == null) return;

    final delta = position - lastPosition;
    final deltaYaw = delta.dx * _kDragSensitivity;
    // Dragging up (negative dy) should tip the cube toward the "top"
    // snap's negative-pitch convention, so no sign flip is needed here.
    final deltaPitch = delta.dy * _kDragSensitivity;
    _orientation =
        _orientation.rotated(deltaYaw: deltaYaw, deltaPitch: deltaPitch);

    if (lastTime != null) {
      final dtSeconds =
          DateTime.now().difference(lastTime).inMicroseconds / 1e6;
      if (dtSeconds > 0.001) {
        _yawVelocity = deltaYaw / dtSeconds;
        _pitchVelocity = deltaPitch / dtSeconds;
      }
    }
    notifyListeners();
  }

  void dragEnd() {
    _lastDragPosition = null;
    _lastDragTime = null;
    if (motionEnabled &&
        (_yawVelocity.abs() > _kInertiaStopThreshold ||
            _pitchVelocity.abs() > _kInertiaStopThreshold)) {
      _startInertia();
    } else {
      _yawVelocity = 0;
      _pitchVelocity = 0;
    }
  }

  void _startInertia() {
    _inertiaRunning = true;
    _lastInertiaElapsed = Duration.zero;
    _inertiaTicker.start();
  }

  void stopInertia() {
    if (!_inertiaRunning) return;
    _inertiaRunning = false;
    _inertiaTicker.stop();
    _yawVelocity = 0;
    _pitchVelocity = 0;
  }

  void _onInertiaTick(Duration elapsed) {
    final dt = (elapsed - _lastInertiaElapsed).inMicroseconds / 1e6;
    _lastInertiaElapsed = elapsed;
    if (dt <= 0) return;

    _orientation = _orientation.rotated(
      deltaYaw: _yawVelocity * dt,
      deltaPitch: _pitchVelocity * dt,
    );
    final decay = math.pow(_kInertiaDecayPerSecond, dt).toDouble();
    _yawVelocity *= decay;
    _pitchVelocity *= decay;
    notifyListeners();

    if (_yawVelocity.abs() < _kInertiaStopThreshold &&
        _pitchVelocity.abs() < _kInertiaStopThreshold) {
      stopInertia();
    }
  }

  // --- Keyboard / programmatic nudge --------------------------------------

  void rotateBy({double deltaYaw = 0, double deltaPitch = 0}) {
    stopInertia();
    stopAutoDemo();
    _orientation =
        _orientation.rotated(deltaYaw: deltaYaw, deltaPitch: deltaPitch);
    notifyListeners();
  }

  // --- Snap / reset ---------------------------------------------------------

  void snapTo(CubeSnapTarget target) => _animateTo(target.orientation);

  void reset() => _animateTo(CubeOrientation.initial);

  void _animateTo(CubeOrientation target) {
    stopInertia();
    stopAutoDemo();
    if (!motionEnabled) {
      _orientation = target;
      notifyListeners();
      return;
    }
    _snapFrom = _orientation;
    _snapTo = target;
    _snapController
      ..stop()
      ..reset()
      ..forward();
  }

  void _onSnapTick() {
    final from = _snapFrom;
    final to = _snapTo;
    if (from == null || to == null) return;
    final t = Curves.easeInOutCubic.transform(_snapController.value);
    _orientation = CubeOrientation.lerp(from, to, t);
    notifyListeners();
  }

  // --- Auto demonstration ---------------------------------------------------

  /// Continuous slow spin — only ever called when [motionEnabled] is true;
  /// callers should offer [stepAutoDemo] instead when it is false.
  void startAutoDemo() {
    if (!motionEnabled || _autoDemoRunning) return;
    stopInertia();
    _autoDemoRunning = true;
    _demoStartYaw = _orientation.yaw;
    _demoController
      ..reset()
      ..repeat();
    notifyListeners();
  }

  void stopAutoDemo() {
    if (!_autoDemoRunning) return;
    _autoDemoRunning = false;
    _demoController.stop();
    notifyListeners();
  }

  void _onDemoTick() {
    if (!_autoDemoRunning) return;
    _orientation = CubeOrientation(
      yaw: _demoStartYaw + _demoController.value * 2 * math.pi,
      pitch: -0.28,
    );
    notifyListeners();
  }

  /// Reduce-Motion-safe alternative to [startAutoDemo]: one tap advances to
  /// the next of [kSpatialCubeDemoSteps], instantly, no continuous
  /// animation — "step-by-step" rather than "spin."
  void stepAutoDemo() {
    stopInertia();
    _demoStepIndex = (_demoStepIndex + 1) % kSpatialCubeDemoSteps.length;
    _orientation = kSpatialCubeDemoSteps[_demoStepIndex];
    notifyListeners();
  }

  @override
  void dispose() {
    _snapController.dispose();
    _demoController.dispose();
    _inertiaTicker.dispose();
    super.dispose();
  }
}
