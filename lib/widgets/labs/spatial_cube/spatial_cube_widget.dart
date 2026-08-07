import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/spatial_cube_face.dart';
import '../../../models/spatial_cube_orientation.dart';
import '../../../services/local_preferences_service.dart';
import 'spatial_cube_controller.dart';

/// Keyboard nudge size for arrow-key rotation — a comfortable, discoverable
/// increment (8 presses covers a quarter turn) rather than a single huge
/// jump.
const double _kKeyboardStepRadians = 11 * math.pi / 180;

/// A reusable, mathematically-projected cube: six independently
/// labelled/coloured faces, drag-to-rotate with inertia (Reduce-Motion
/// aware), keyboard rotation, and an accessible orientation description.
/// The painter is a pure function of [controller]'s [CubeOrientation] — see
/// [SpatialCubeController] for the logical model it renders.
class SpatialCube extends StatefulWidget {
  const SpatialCube({
    super.key,
    required this.controller,
    this.faceContent = kDefaultCubeFaceContent,
    this.size = 240,
    this.interactive = true,
    this.semanticLabelPrefix,
  });

  final SpatialCubeController controller;
  final Map<CubeFace, CubeFaceContent> faceContent;
  final double size;

  /// When false, renders the cube read-only (no drag, no focus) — used for
  /// the static "target orientation" preview in Rotate to Match.
  final bool interactive;

  /// Prefixed onto the generated orientation description, e.g. "Target
  /// orientation." vs the default "Cube orientation."
  final String? semanticLabelPrefix;

  @override
  State<SpatialCube> createState() => _SpatialCubeState();
}

class _SpatialCubeState extends State<SpatialCube> {
  final _focusNode = FocusNode(debugLabel: 'spatial-cube');
  String _description = '';

  bool get _motionEnabled =>
      !LocalPreferencesService.instance.reduceMotion.value &&
      !MediaQuery.disableAnimationsOf(context);

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onOrientationChanged);
    _description = _describeOrientation(widget.controller.orientation);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller.motionEnabled = _motionEnabled;
  }

  @override
  void didUpdateWidget(covariant SpatialCube oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onOrientationChanged);
      widget.controller.addListener(_onOrientationChanged);
    }
    widget.controller.motionEnabled = _motionEnabled;
  }

  void _onOrientationChanged() {
    if (mounted) setState(() {});
  }

  String _describeOrientation(CubeOrientation orientation) {
    final front =
        widget.faceContent[orientation.faceClosestToDirection(0, 0, -1)]!;
    final top =
        widget.faceContent[orientation.faceClosestToDirection(0, 1, 0)]!;
    return '${front.label} face at the front. ${top.label} face at the top.';
  }

  void _refreshDescription() {
    final next = _describeOrientation(widget.controller.orientation);
    if (next != _description) {
      setState(() => _description = next);
    }
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final step = _kKeyboardStepRadians;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        widget.controller.rotateBy(deltaYaw: -step);
      case LogicalKeyboardKey.arrowRight:
        widget.controller.rotateBy(deltaYaw: step);
      case LogicalKeyboardKey.arrowUp:
        widget.controller.rotateBy(deltaPitch: -step);
      case LogicalKeyboardKey.arrowDown:
        widget.controller.rotateBy(deltaPitch: step);
      default:
        return KeyEventResult.ignored;
    }
    _refreshDescription();
    return KeyEventResult.handled;
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onOrientationChanged);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.controller.motionEnabled = _motionEnabled;
    final prefix = widget.semanticLabelPrefix ?? 'Cube orientation.';
    final label = '$prefix $_description';

    Widget cube = CustomPaint(
      size: Size.square(widget.size),
      painter: _SpatialCubePainter(
        orientation: widget.controller.orientation,
        faceContent: widget.faceContent,
      ),
    );

    if (!widget.interactive) {
      return Semantics(
        label: label,
        image: true,
        child: ExcludeSemantics(child: cube),
      );
    }

    return Semantics(
      label: label,
      image: true,
      child: ExcludeSemantics(
        child: Focus(
          focusNode: _focusNode,
          onKeyEvent: _handleKey,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _focusNode.requestFocus(),
            onPanStart: (details) =>
                widget.controller.dragStart(details.localPosition),
            onPanUpdate: (details) =>
                widget.controller.dragUpdate(details.localPosition),
            onPanEnd: (_) {
              widget.controller.dragEnd();
              _refreshDescription();
            },
            child: cube,
          ),
        ),
      ),
    );
  }
}

class _SpatialCubePainter extends CustomPainter {
  const _SpatialCubePainter({
    required this.orientation,
    required this.faceContent,
  });

  final CubeOrientation orientation;
  final Map<CubeFace, CubeFaceContent> faceContent;

  @override
  void paint(Canvas canvas, Size size) {
    final projected = orientation.project(viewport: size);
    final strokePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeJoin = StrokeJoin.round;

    for (final face in projected) {
      final content = faceContent[face.face]!;
      final path = Path()..addPolygon(face.points, true);
      final fillPaint = Paint()
        ..color = Color.lerp(Colors.black, content.color, face.shade)!;
      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SpatialCubePainter oldDelegate) {
    return oldDelegate.orientation.yaw != orientation.yaw ||
        oldDelegate.orientation.pitch != orientation.pitch ||
        oldDelegate.faceContent != faceContent;
  }
}
