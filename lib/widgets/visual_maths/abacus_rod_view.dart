import 'dart:math' as math;

import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';

import '../../models/abacus_state.dart';
import '../../shared/theme/app_theme.dart';

/// Pure layout maths for one rod, so the widget and its tests agree on where
/// every bead sits.
///
/// The rod is a horizontal line with a fixed divider bar at its centre.
/// Counted beads are packed against the divider on its right, waiting beads
/// against it on its left. Beads overlap slightly (like beads on a wire), so
/// nine fit in each half at any width without a fixed pixel size. Bead `k`
/// (1..9) is counted when `k <= count`; its distance from the divider is `k`
/// when counted and `k - count` when waiting.
class AbacusRodGeometry {
  const AbacusRodGeometry(this.width, {this.dividerWidth = 8});

  final double width;
  final double dividerWidth;

  static const _edgePad = 4.0;
  static const _beadOverlap = 1.5; // bead width in steps
  static const _fitSteps = 9.5; // 8 steps + one bead width

  double get center => width / 2;
  double get _zone => (width - dividerWidth) / 2 - _edgePad;
  double get step => _zone / _fitSteps;
  double get beadWidth => step * _beadOverlap;

  /// Left edge of the counted bead at distance [i] (1..9) from the divider.
  double countedLeft(int i) => center + dividerWidth / 2 + (i - 1) * step;

  /// Left edge of the waiting bead at distance [j] (1..9) from the divider.
  double waitingLeft(int j) =>
      center - dividerWidth / 2 - (j - 1) * step - beadWidth;

  double leftOf(int bead, int count) =>
      bead <= count ? countedLeft(bead) : waitingLeft(bead - count);

  /// Which bead a horizontal position [x] (relative to the rod's left edge)
  /// falls on, or null for the divider or empty space.
  int? beadAt(double x, int count) {
    if (x >= center + dividerWidth / 2) {
      return _hit((x - center - dividerWidth / 2) / step, count, (d) => d);
    }
    if (x <= center - dividerWidth / 2) {
      return _hit((center - dividerWidth / 2 - x) / step,
          AbacusState.beadsPerRod - count, (d) => count + d);
    }
    return null;
  }

  int? _hit(double raw, int available, int Function(int distance) toBead) {
    if (raw < 0 || available <= 0) return null;
    var distance = raw.floor() + 1;
    if (distance > available) {
      // The last bead is wider than one step; count its tail as a hit.
      if (raw < available + 0.5) {
        distance = available;
      } else {
        return null;
      }
    }
    return toBead(distance);
  }

  /// How far bead [bead] must travel for the group led by [grabbed] to cross.
  double travelFor(int bead, int grabbed, int count) {
    if (grabbed > count) {
      return countedLeft(bead) - waitingLeft(bead - count);
    }
    return countedLeft(bead) - waitingLeft(bead - (grabbed - 1));
  }

  /// Distance from the grabbed bead's centre to the divider's centre: the
  /// drag has to carry the bead at least this far to count as crossing.
  double crossingDistance(int grabbed, int count) {
    if (grabbed > count) {
      return center - (waitingLeft(grabbed - count) + beadWidth / 2);
    }
    return (countedLeft(grabbed) + beadWidth / 2) - center;
  }
}

/// One rod: label, nine beads on a rod either side of a divider, and the
/// gestures that move them.
///
/// Interaction contract (also exposed as semantics actions):
///  * Tap a waiting bead: it and every waiting bead between it and the
///    divider slide across (count becomes that bead's number).
///  * Tap a counted bead: it and every counted bead beyond it slide back
///    (count becomes one less than that bead's number).
///  * Drag a bead horizontally across the divider: same result as tapping
///    it. Released before crossing (and without a flick) it springs back.
///  * Screen readers: increase / decrease actions add or remove one bead.
class AbacusRodView extends StatefulWidget {
  const AbacusRodView({
    super.key,
    required this.rod,
    required this.count,
    required this.color,
    required this.label,
    required this.valueLabel,
    required this.onCountChanged,
    required this.reduceMotion,
    this.minRowHeight = 48,
  });

  final AbacusRod rod;
  final int count;
  final Color color;
  final String label;
  final String valueLabel;
  final ValueChanged<int> onCountChanged;
  final bool reduceMotion;

  /// Height of the rod's touch row; never below the 44 dp touch minimum.
  final double minRowHeight;

  static const _flingSpeed = 500.0;
  static const _flingMinDistance = 20.0;

  @override
  State<AbacusRodView> createState() => _AbacusRodViewState();
}

class _AbacusRodViewState extends State<AbacusRodView> {
  int? _grabbed;
  double _dx = 0;

  void _clearDrag() {
    _grabbed = null;
    _dx = 0;
  }

  double _offsetFor(int bead, AbacusRodGeometry geo) {
    final grabbed = _grabbed;
    if (grabbed == null) return 0;
    final n = widget.count;
    if (grabbed > n) {
      if (bead <= n || bead > grabbed || _dx <= 0) return 0;
      return math.min(_dx, geo.travelFor(bead, grabbed, n));
    }
    if (bead < grabbed || bead > n || _dx >= 0) return 0;
    return -math.min(-_dx, geo.travelFor(bead, grabbed, n));
  }

  void _onDragEnd(DragEndDetails details, AbacusRodGeometry geo) {
    final grabbed = _grabbed;
    final n = widget.count;
    var next = n;
    if (grabbed != null) {
      final moving = grabbed > n ? _dx : -_dx;
      final speed = (grabbed > n ? 1 : -1) * (details.primaryVelocity ?? 0);
      final crossed = moving >= geo.crossingDistance(grabbed, n);
      final flicked = speed > AbacusRodView._flingSpeed &&
          moving >= AbacusRodView._flingMinDistance;
      if (crossed || flicked) next = grabbed > n ? grabbed : grabbed - 1;
    }
    setState(_clearDrag);
    if (next != n) widget.onCountChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final n = widget.count;
    final dragging = _grabbed != null;
    final duration = (widget.reduceMotion || dragging)
        ? Duration.zero
        : const Duration(milliseconds: 180);

    final rod = Semantics(
      container: true,
      label: widget.label,
      value: widget.valueLabel,
      increasedValue: n < AbacusState.beadsPerRod ? '${n + 1}' : null,
      decreasedValue: n > 0 ? '${n - 1}' : null,
      onIncrease: n < AbacusState.beadsPerRod
          ? () => widget.onCountChanged(n + 1)
          : null,
      onDecrease: n > 0 ? () => widget.onCountChanged(n - 1) : null,
      child: ExcludeSemantics(
        child: LayoutBuilder(builder: (context, constraints) {
          final geo = AbacusRodGeometry(constraints.maxWidth);
          final beadHeight = (geo.beadWidth * 1.1).clamp(28.0, 40.0);
          final rowHeight = math.max(widget.minRowHeight, beadHeight + 12);
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            // Report the drag from where the finger went down, not from
            // where the touch slop was passed: the slop is about as wide as
            // one bead, so the default would grab the bead next to the one
            // the child touched.
            dragStartBehavior: DragStartBehavior.down,
            onTapUp: (d) {
              final bead = geo.beadAt(d.localPosition.dx, n);
              if (bead == null) return;
              widget.onCountChanged(bead <= n ? bead - 1 : bead);
            },
            onHorizontalDragStart: (d) => setState(() {
              _grabbed = geo.beadAt(d.localPosition.dx, n);
              _dx = 0;
            }),
            onHorizontalDragUpdate: (d) {
              if (_grabbed != null) setState(() => _dx += d.delta.dx);
            },
            onHorizontalDragEnd: (d) => _onDragEnd(d, geo),
            onHorizontalDragCancel: () => setState(_clearDrag),
            child: SizedBox(
              height: rowHeight,
              width: constraints.maxWidth,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // The rod itself.
                  Positioned(
                    left: 2,
                    right: 2,
                    top: (rowHeight - 6) / 2,
                    height: 6,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            colors.divider,
                            colors.tertiaryText.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // The divider bar beads are counted across.
                  Positioned(
                    left: geo.center - geo.dividerWidth / 2,
                    width: geo.dividerWidth,
                    top: 2,
                    bottom: 2,
                    child: DecoratedBox(
                      key: Key('abacusDivider-${widget.rod.name}'),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: colors.tertiaryText,
                      ),
                    ),
                  ),
                  for (var bead = 1; bead <= AbacusState.beadsPerRod; bead++)
                    AnimatedPositioned(
                      duration: duration,
                      curve: Curves.easeOutCubic,
                      left: geo.leftOf(bead, n) + _offsetFor(bead, geo),
                      top: (rowHeight - beadHeight) / 2,
                      width: geo.beadWidth,
                      height: beadHeight,
                      child: _Bead(
                        key: Key('abacusBead-${widget.rod.name}-$bead'),
                        color: widget.color,
                        counted: bead <= n,
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
    return rod;
  }
}

/// A single dimensional bead: a capsule with a lit top edge, a darker lower
/// edge, a soft highlight and a contact shadow. Drawn from plain gradients so
/// it needs no image asset.
class _Bead extends StatelessWidget {
  const _Bead({super.key, required this.color, required this.counted});

  final Color color;
  final bool counted;

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(color);
    final light =
        hsl.withLightness((hsl.lightness + 0.22).clamp(0.0, 0.9)).toColor();
    final dark =
        hsl.withLightness((hsl.lightness - 0.16).clamp(0.1, 1.0)).toColor();
    return LayoutBuilder(builder: (context, c) {
      final radius = c.maxHeight / 2;
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [light, color, dark],
            stops: const [0.0, 0.45, 1.0],
          ),
          border: Border.all(color: dark.withValues(alpha: 0.85), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: counted ? 0.30 : 0.18),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Align(
          alignment: const Alignment(-0.35, -0.55),
          child: FractionallySizedBox(
            widthFactor: 0.45,
            heightFactor: 0.22,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                color: Colors.white.withValues(alpha: 0.55),
              ),
            ),
          ),
        ),
      );
    });
  }
}
