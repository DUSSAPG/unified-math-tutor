import 'package:flutter/material.dart';

import '../../../shared/theme/app_theme.dart';

/// Decorative, non-interactive habitat shell for Feed the Hungry Panda.
///
/// The gameplay layer is passed through as [child] and is never transformed:
/// all parallax is confined to background/foreground painters so apple
/// positions, drop targets, semantics bounds, and button hit tests stay
/// anchored to Flutter's normal layout.
class PandaHabitatBackdrop extends StatefulWidget {
  const PandaHabitatBackdrop({
    super.key,
    required this.reduceMotion,
    required this.child,
  });

  final bool reduceMotion;
  final Widget child;

  static const double distantMaxOffset = 4;
  static const double middleMaxOffset = 8;
  static const double foregroundMaxOffset = 12;

  @visibleForTesting
  static Offset parallaxOffset(Offset normalized, double maxOffset) {
    return Offset(
      normalized.dx.clamp(-1.0, 1.0) * maxOffset,
      normalized.dy.clamp(-1.0, 1.0) * maxOffset,
    );
  }

  @override
  State<PandaHabitatBackdrop> createState() => _PandaHabitatBackdropState();
}

class _PandaHabitatBackdropState extends State<PandaHabitatBackdrop> {
  final ValueNotifier<Offset> _pointer = ValueNotifier(Offset.zero);

  @override
  void didUpdateWidget(covariant PandaHabitatBackdrop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reduceMotion && _pointer.value != Offset.zero) {
      _pointer.value = Offset.zero;
    }
  }

  @override
  void dispose() {
    _pointer.dispose();
    super.dispose();
  }

  void _updatePointer(PointerEvent event, Size size) {
    if (widget.reduceMotion || size.width <= 0 || size.height <= 0) return;
    final next = Offset(
      (event.localPosition.dx / size.width * 2 - 1).clamp(-1.0, 1.0),
      (event.localPosition.dy / size.height * 2 - 1).clamp(-1.0, 1.0),
    );
    if ((_pointer.value - next).distance > 0.03) {
      _pointer.value = next;
    }
  }

  void _resetPointer() {
    if (_pointer.value != Offset.zero) _pointer.value = Offset.zero;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final brightness = Theme.of(context).brightness;
    final motionOff =
        widget.reduceMotion || MediaQuery.disableAnimationsOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final compact = constraints.maxWidth < 600;
        final foregroundLimit = compact
            ? PandaHabitatBackdrop.foregroundMaxOffset * 0.65
            : PandaHabitatBackdrop.foregroundMaxOffset;

        return Listener(
          onPointerHover: (event) => _updatePointer(event, size),
          onPointerMove: (event) => _updatePointer(event, size),
          onPointerCancel: (_) => _resetPointer(),
          onPointerUp: (_) => _resetPointer(),
          child: Stack(
            key: const Key('feedPandaHabitatBackdrop'),
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: ExcludeSemantics(
                  child: RepaintBoundary(
                    key: const Key('feedPandaHabitatBackgroundBoundary'),
                    child: ValueListenableBuilder<Offset>(
                      valueListenable: _pointer,
                      builder: (context, pointer, _) {
                        return CustomPaint(
                          key: const Key('feedPandaHabitatBackground'),
                          painter: _PandaHabitatBackgroundPainter(
                            colors: colors,
                            brightness: brightness,
                            parallax: motionOff ? Offset.zero : pointer,
                            compact: compact,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, 0.2),
                      radius: compact ? 0.95 : 0.78,
                      colors: [
                        colors.cardSurface.withValues(alpha: 0.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              widget.child,
              Positioned.fill(
                child: IgnorePointer(
                  child: ExcludeSemantics(
                    child: RepaintBoundary(
                      key: const Key('feedPandaHabitatForegroundBoundary'),
                      child: ValueListenableBuilder<Offset>(
                        valueListenable: _pointer,
                        builder: (context, pointer, _) {
                          final parallax = motionOff
                              ? Offset.zero
                              : Offset(
                                  pointer.dx *
                                      foregroundLimit /
                                      PandaHabitatBackdrop.foregroundMaxOffset,
                                  pointer.dy *
                                      foregroundLimit /
                                      PandaHabitatBackdrop.foregroundMaxOffset,
                                );
                          return CustomPaint(
                            key: const Key('feedPandaHabitatForeground'),
                            painter: _PandaHabitatForegroundPainter(
                              colors: colors,
                              brightness: brightness,
                              parallax: parallax,
                              compact: compact,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PandaHabitatBackgroundPainter extends CustomPainter {
  const _PandaHabitatBackgroundPainter({
    required this.colors,
    required this.brightness,
    required this.parallax,
    required this.compact,
  });

  final AppSemanticColors colors;
  final Brightness brightness;
  final Offset parallax;
  final bool compact;

  bool get _dark => brightness == Brightness.dark;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final skyTop = _dark ? const Color(0xFF122A26) : const Color(0xFFE8F8EC);
    final skyBottom = _dark ? const Color(0xFF091615) : const Color(0xFFF8FFF5);
    final ground = _dark ? const Color(0xFF17322B) : const Color(0xFFDDF4D5);

    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [skyTop, skyBottom],
        ).createShader(rect),
    );

    final distant = PandaHabitatBackdrop.parallaxOffset(
      parallax,
      PandaHabitatBackdrop.distantMaxOffset,
    );
    final middle = PandaHabitatBackdrop.parallaxOffset(
      parallax,
      PandaHabitatBackdrop.middleMaxOffset,
    );

    _drawHills(canvas, size, distant);
    _drawBambooLayer(
      canvas,
      size,
      distant,
      color: (_dark ? const Color(0xFF45675B) : const Color(0xFF9ACBA2))
          .withValues(alpha: _dark ? 0.4 : 0.5),
      strokeWidth: compact ? 5 : 7,
      count: compact ? 6 : 9,
      heightFactor: 0.56,
    );
    _drawBambooLayer(
      canvas,
      size,
      middle,
      color: (_dark ? const Color(0xFF75A878) : const Color(0xFF5FA96B))
          .withValues(alpha: _dark ? 0.42 : 0.46),
      strokeWidth: compact ? 7 : 10,
      count: compact ? 5 : 7,
      heightFactor: 0.76,
    );

    final clearingCenter = Offset(size.width / 2, size.height * 0.72);
    canvas.drawOval(
      Rect.fromCenter(
        center: clearingCenter,
        width: size.width * (compact ? 0.92 : 0.72),
        height: size.height * 0.18,
      ),
      Paint()..color = ground.withValues(alpha: _dark ? 0.56 : 0.72),
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: clearingCenter.translate(0, size.height * 0.015),
        width: size.width * (compact ? 0.72 : 0.46),
        height: size.height * 0.075,
      ),
      Paint()
        ..color = (_dark ? Colors.black : const Color(0xFF37543D))
            .withValues(alpha: _dark ? 0.2 : 0.11),
    );
  }

  void _drawHills(Canvas canvas, Size size, Offset offset) {
    final paint = Paint()
      ..color = (_dark ? const Color(0xFF1B3A34) : const Color(0xFFC9EACB))
          .withValues(alpha: _dark ? 0.8 : 0.72);
    final path = Path()
      ..moveTo(-24 + offset.dx, size.height * 0.48 + offset.dy)
      ..quadraticBezierTo(
        size.width * 0.2,
        size.height * 0.32 + offset.dy,
        size.width * 0.46,
        size.height * 0.46 + offset.dy,
      )
      ..quadraticBezierTo(
        size.width * 0.72,
        size.height * 0.58 + offset.dy,
        size.width + 24 + offset.dx,
        size.height * 0.4 + offset.dy,
      )
      ..lineTo(size.width + 24, size.height)
      ..lineTo(-24, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _drawBambooLayer(
    Canvas canvas,
    Size size,
    Offset offset, {
    required Color color,
    required double strokeWidth,
    required int count,
    required double heightFactor,
  }) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final nodePaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    for (var index = 0; index < count; index++) {
      final fraction = count == 1 ? 0.5 : index / (count - 1);
      final x = size.width * fraction + offset.dx * (index.isEven ? 1 : -0.8);
      final lean = (index.isEven ? 1 : -1) * strokeWidth * 0.9;
      final top = size.height * (1 - heightFactor) + offset.dy;
      final bottom = size.height + strokeWidth;
      canvas.drawLine(Offset(x + lean, top), Offset(x, bottom), paint);
      for (var node = 1; node <= 4; node++) {
        final y = top + (bottom - top) * node / 5;
        canvas.drawLine(
          Offset(x - strokeWidth * 0.75, y),
          Offset(x + strokeWidth * 0.75, y),
          nodePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PandaHabitatBackgroundPainter oldDelegate) {
    return oldDelegate.colors != colors ||
        oldDelegate.brightness != brightness ||
        oldDelegate.parallax != parallax ||
        oldDelegate.compact != compact;
  }
}

class _PandaHabitatForegroundPainter extends CustomPainter {
  const _PandaHabitatForegroundPainter({
    required this.colors,
    required this.brightness,
    required this.parallax,
    required this.compact,
  });

  final AppSemanticColors colors;
  final Brightness brightness;
  final Offset parallax;
  final bool compact;

  bool get _dark => brightness == Brightness.dark;

  @override
  void paint(Canvas canvas, Size size) {
    final leafColor =
        (_dark ? const Color(0xFF8CCB80) : const Color(0xFF4F9D58))
            .withValues(alpha: _dark ? 0.42 : 0.32);
    final stemColor =
        (_dark ? const Color(0xFF6FA766) : const Color(0xFF3E8148))
            .withValues(alpha: _dark ? 0.38 : 0.28);
    final paint = Paint()..color = leafColor;
    final stemPaint = Paint()
      ..color = stemColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final density = compact ? 4 : 7;
    _drawLeafCluster(
      canvas,
      size,
      Offset(12 + parallax.dx, size.height * 0.1 + parallax.dy),
      density,
      paint,
      stemPaint,
      mirror: false,
    );
    _drawLeafCluster(
      canvas,
      size,
      Offset(size.width - 12 - parallax.dx, size.height * 0.12 + parallax.dy),
      density,
      paint,
      stemPaint,
      mirror: true,
    );

    final lowerAlpha = compact ? 0.12 : 0.18;
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.86, size.width, size.height * 0.14),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            colors.background.withValues(alpha: lowerAlpha),
          ],
        ).createShader(
          Rect.fromLTWH(0, size.height * 0.86, size.width, size.height * 0.14),
        ),
    );
  }

  void _drawLeafCluster(
    Canvas canvas,
    Size size,
    Offset origin,
    int count,
    Paint leafPaint,
    Paint stemPaint, {
    required bool mirror,
  }) {
    final direction = mirror ? -1.0 : 1.0;
    canvas.drawLine(
      origin,
      origin + Offset(direction * (compact ? 52 : 84), compact ? 34 : 46),
      stemPaint,
    );
    for (var index = 0; index < count; index++) {
      final x = origin.dx + direction * (18 + index * (compact ? 10 : 13));
      final y = origin.dy + 8 + index * (compact ? 5 : 6);
      final rect = Rect.fromCenter(
        center: Offset(x, y),
        width: compact ? 28 : 38,
        height: compact ? 12 : 16,
      );
      canvas.save();
      canvas.translate(rect.center.dx, rect.center.dy);
      canvas.rotate(direction * (-0.62 + index * 0.08));
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: rect.width,
          height: rect.height,
        ),
        leafPaint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _PandaHabitatForegroundPainter oldDelegate) {
    return oldDelegate.colors != colors ||
        oldDelegate.brightness != brightness ||
        oldDelegate.parallax != parallax ||
        oldDelegate.compact != compact;
  }
}
