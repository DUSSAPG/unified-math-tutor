import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Fractions of a Set: the trays, the collection and the painted counters.
///
/// Hit targets are the trays, the collection and the tray control row only.
/// Counters are 24 dp, drawn in four plain shapes with no text, and are
/// never targets.

/// Counter side.
const fosCounterSize = 24.0;

/// Gap between trays.
const fosTrayGap = 6.0;

/// Tray box without a control row (W and E items).
const fosTrayBoxHeight = 112.0;

/// The control row under a U or N tray (errata I-2).
const fosTrayControlHeight = 48.0;

/// Narrowest tray: two counters side by side plus padding.
const fosTrayMinWidth = 60.0;

/// Tray grid columns (contract §9.3).
int fosPreferredColumns(int d) => switch (d) {
      6 => 3,
      8 => 4,
      10 => 5,
      _ => d,
    };

/// Columns that fit [width]: the preferred grid, or fewer columns when the
/// trays would otherwise fall below [fosTrayMinWidth].
int fosColumnsFor(int d, double width) {
  final fit = ((width + fosTrayGap) / (fosTrayMinWidth + fosTrayGap)).floor();
  return math.max(1, math.min(fosPreferredColumns(d), fit));
}

/// Colours used for counters. Shapes vary as well, so colour never carries
/// meaning.
const _counterColours = [
  Color(0xFFE69F00),
  Color(0xFF56B4E9),
  Color(0xFF009E73),
  Color(0xFF0072B2),
  Color(0xFFD55E00),
  Color(0xFFCC79A7),
  Color(0xFFF0E442),
];

/// Draws [count] counters in rows of [perRow], each 24 dp with [gap]
/// between. [variety] offsets the shape and colour sequence. Counters
/// whose position is in [marked] get a thick ring and a check.
class FosCountersPainter extends CustomPainter {
  FosCountersPainter({
    required this.count,
    required this.perRow,
    required this.gap,
    required this.ink,
    required this.markInk,
    this.variety = 0,
    this.marked = const {},
    this.highContrast = false,
  });

  final int count;
  final int perRow;
  final double gap;
  final Color ink;
  final Color markInk;
  final int variety;
  final Set<int> marked;
  final bool highContrast;

  /// Top-left of counter [k].
  Offset origin(int k) => Offset((k % perRow) * (fosCounterSize + gap),
      (k ~/ perRow) * (fosCounterSize + gap));

  static void paintCounter(Canvas canvas, Offset o, int style, Color ink,
      {bool highContrast = false}) {
    const s = fosCounterSize;
    final fill = Paint()
      ..color = _counterColours[style % _counterColours.length];
    final edge = Paint()
      ..color = ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = highContrast ? 2 : 1.2;
    final r = Rect.fromLTWH(o.dx + 2, o.dy + 2, s - 4, s - 4);
    final Path path;
    switch (style % 4) {
      case 0:
        path = Path()..addOval(r);
      case 1:
        path = Path()..addRect(r.deflate(1));
      case 2:
        path = Path()
          ..moveTo(r.center.dx, r.top)
          ..lineTo(r.right, r.bottom)
          ..lineTo(r.left, r.bottom)
          ..close();
      default:
        path = Path()
          ..moveTo(r.center.dx, r.top)
          ..lineTo(r.right, r.center.dy)
          ..lineTo(r.center.dx, r.bottom)
          ..lineTo(r.left, r.center.dy)
          ..close();
    }
    canvas
      ..drawPath(path, fill)
      ..drawPath(path, edge);
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var k = 0; k < count; k++) {
      final o = origin(k);
      paintCounter(canvas, o, k + variety, ink, highContrast: highContrast);
      if (marked.contains(k)) {
        final ring = Paint()
          ..color = markInk
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
        canvas.drawCircle(o + const Offset(12, 12), 13, ring);
        final tick = Paint()
          ..color = markInk
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round;
        canvas.drawPath(
            Path()
              ..moveTo(o.dx + 7, o.dy + 12)
              ..lineTo(o.dx + 11, o.dy + 16)
              ..lineTo(o.dx + 18, o.dy + 8),
            tick);
      }
    }
  }

  @override
  bool shouldRepaint(FosCountersPainter old) =>
      old.count != count ||
      old.perRow != perRow ||
      old.gap != gap ||
      old.ink != ink ||
      old.markInk != markInk ||
      old.variety != variety ||
      old.highContrast != highContrast ||
      !_sameSet(old.marked, marked);

  static bool _sameSet(Set<int> a, Set<int> b) =>
      a.length == b.length && a.containsAll(b);
}

/// The collection: up to 30 counters in rows. Its height is fixed by
/// [capacity] so the trays below never move while counters leave it.
class FosCollection extends StatelessWidget {
  const FosCollection({
    super.key,
    required this.count,
    required this.capacity,
    required this.semanticsLabel,
    required this.onActivate,
    this.marked = const {},
  });

  final int count;
  final int capacity;

  /// Null keeps the collection out of the semantics tree: the prompt
  /// already states what it holds.
  final String? semanticsLabel;

  /// Deal one round; null when the collection is not a target.
  final VoidCallback? onActivate;
  final Set<int> marked;

  static const gap = 8.0;

  static int perRowFor(double width) => math.max(
      1, ((width - 8 + gap) / (fosCounterSize + gap)).floor().clamp(1, 10));

  static double heightFor(int capacity, double width) {
    final rows = (capacity / perRowFor(width)).ceil();
    return math.max(48, rows * fosCounterSize + (rows - 1) * gap + 8);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final hc = MediaQuery.highContrastOf(context);
    final ink = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF1F2937);
    return LayoutBuilder(builder: (context, c) {
      final perRow = perRowFor(c.maxWidth);
      final box = Container(
        key: const Key('fractionsOfASetCollectionBox'),
        height: heightFor(capacity, c.maxWidth),
        width: double.infinity,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: colors.outline.withValues(alpha: hc ? 1 : .5),
              width: hc ? 2 : 1),
        ),
        child: CustomPaint(
          key: const Key('fractionsOfASetCollectionPaint'),
          painter: FosCountersPainter(
            count: count,
            perRow: perRow,
            gap: gap,
            ink: ink,
            markInk: colors.primary,
            marked: marked,
            highContrast: hc,
          ),
        ),
      );
      final visual = onActivate == null
          ? box
          : Material(
              type: MaterialType.transparency,
              child: InkWell(
                key: const Key('fractionsOfASetCollection'),
                borderRadius: BorderRadius.circular(12),
                onTap: onActivate,
                child: box,
              ),
            );
      if (semanticsLabel == null) return ExcludeSemantics(child: visual);
      return Semantics(
        key: const Key('fractionsOfASetCollectionSemantics'),
        container: true,
        button: onActivate != null,
        label: semanticsLabel,
        onTap: onActivate,
        excludeSemantics: true,
        child: visual,
      );
    });
  }
}

/// What the control row under a tray shows (errata I-1, I-2).
enum FosTrayControl { none, takeOneOut, chosenBadge }

/// Visual state of one tray.
class FosTrayState {
  const FosTrayState({
    required this.count,
    this.chosen = false,
    this.differs = false,
    this.equalMark = false,
    this.canTakeOneOut = false,
  });

  final int count;
  final bool chosen;
  final bool differs;

  /// E equal reveal: every tray outlined as equal.
  final bool equalMark;
  final bool canTakeOneOut;
}

/// The tray grid. Labels are built by the screen from ARB copy.
class FosTrayGrid extends StatelessWidget {
  const FosTrayGrid({
    super.key,
    required this.trays,
    required this.control,
    required this.labelFor,
    required this.takeOneOutLabelFor,
    required this.chosenLabel,
    required this.differentLabel,
    required this.onActivate,
    required this.onTakeOneOut,
    this.showSelected = false,
  });

  final List<FosTrayState> trays;
  final FosTrayControl control;

  /// The full semantics label for tray [i] (0-based).
  final String Function(int i) labelFor;

  /// Accessible name of tray [i]'s take-one-out button and action.
  final String Function(int i) takeOneOutLabelFor;
  final String chosenLabel;
  final String differentLabel;

  /// Tray activate, or null when the tray is not a target in this phase.
  final void Function(int i)? onActivate;
  final void Function(int i)? onTakeOneOut;

  /// Expose the selected state (take phase and U/N reveal).
  final bool showSelected;

  /// Height of the grid for [d] trays at [width].
  static double heightFor(int d, double width, FosTrayControl control,
      {bool statusRow = false}) {
    final cols = fosColumnsFor(d, width);
    final rows = (d / cols).ceil();
    final one = fosTrayBoxHeight +
        (control == FosTrayControl.none ? 0 : fosTrayControlHeight) +
        (statusRow ? 20 : 0);
    return rows * one + (rows - 1) * fosTrayGap;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final d = trays.length;
      final cols = fosColumnsFor(d, c.maxWidth);
      final w = (c.maxWidth - (cols - 1) * fosTrayGap) / cols;
      final statusRow = trays.any((t) => t.differs);
      return Wrap(
        key: const Key('fractionsOfASetTrayGrid'),
        spacing: fosTrayGap,
        runSpacing: fosTrayGap,
        children: [
          for (var i = 0; i < d; i++)
            SizedBox(
              width: w,
              child: _Tray(
                index: i,
                state: trays[i],
                control: control,
                statusRow: statusRow,
                label: labelFor(i),
                takeOneOutLabel: takeOneOutLabelFor(i),
                chosenLabel: chosenLabel,
                differentLabel: differentLabel,
                onActivate: onActivate == null ? null : () => onActivate!(i),
                onTakeOneOut: onTakeOneOut == null || !trays[i].canTakeOneOut
                    ? null
                    : () => onTakeOneOut!(i),
                showSelected: showSelected,
              ),
            ),
        ],
      );
    });
  }
}

class _Tray extends StatelessWidget {
  const _Tray({
    required this.index,
    required this.state,
    required this.control,
    required this.statusRow,
    required this.label,
    required this.takeOneOutLabel,
    required this.chosenLabel,
    required this.differentLabel,
    required this.onActivate,
    required this.onTakeOneOut,
    required this.showSelected,
  });

  final int index;
  final FosTrayState state;
  final FosTrayControl control;
  final bool statusRow;
  final String label;
  final String takeOneOutLabel;
  final String chosenLabel;
  final String differentLabel;
  final VoidCallback? onActivate;
  final VoidCallback? onTakeOneOut;
  final bool showSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hc = MediaQuery.highContrastOf(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ink = dark ? Colors.white : const Color(0xFF1F2937);
    final warn = dark ? const Color(0xFFFFB74D) : const Color(0xFFB45309);
    final good = dark ? const Color(0xFF6EE7B7) : const Color(0xFF047857);
    final marked = state.chosen || state.differs || state.equalMark;
    final borderColour = state.differs
        ? warn
        : state.chosen
            ? scheme.primary
            : state.equalMark
                ? good
                : scheme.outline.withValues(alpha: hc ? 1 : .6);
    final borderWidth = marked ? (hc ? 4.0 : 3.0) : (hc ? 2.0 : 1.0);
    final statusIcon = state.differs
        ? Icons.error_outline
        : state.chosen
            ? Icons.check_circle
            : state.equalMark
                ? Icons.check
                : null;

    final box = Container(
      key: Key('fractionsOfASetTrayBox-${index + 1}'),
      height: fosTrayBoxHeight,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      // Drawn over the box so a thick state outline never narrows the
      // counter area.
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColour, width: borderWidth),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${state.count}',
                      key: Key('fractionsOfASetTrayCount-${index + 1}'),
                      style: TextStyle(
                          color: ink,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                if (statusIcon != null)
                  Icon(statusIcon, size: 16, color: borderColour),
              ],
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 2 * fosCounterSize + 4,
            height: 3 * fosCounterSize + 2 * 4,
            child: CustomPaint(
              painter: _TrayCountersPainter(
                count: state.count,
                variety: index * 3,
                ink: ink,
                badgeFill: scheme.secondaryContainer,
                badgeInk: scheme.onSecondaryContainer,
                highContrast: hc,
                textScaler: MediaQuery.textScalerOf(context),
              ),
            ),
          ),
        ],
      ),
    );

    final tappable = onActivate == null
        ? box
        : _TrayFocusFrame(
            index: index,
            onTap: onActivate!,
            child: box,
          );

    final trayNode = Semantics(
      key: Key('fractionsOfASetTraySemantics-${index + 1}'),
      container: true,
      button: onActivate != null,
      selected: showSelected ? state.chosen : null,
      label: label,
      onTap: onActivate,
      customSemanticsActions: onTakeOneOut == null
          ? null
          : {CustomSemanticsAction(label: takeOneOutLabel): onTakeOneOut!},
      excludeSemantics: true,
      child: tappable,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        trayNode,
        if (control == FosTrayControl.takeOneOut)
          SizedBox(
            height: fosTrayControlHeight,
            child: Center(
              child: IconButton(
                key: Key('fractionsOfASetTakeOneOut-${index + 1}'),
                tooltip: takeOneOutLabel,
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                padding: EdgeInsets.zero,
                onPressed: onTakeOneOut,
                icon: const Icon(Icons.remove_circle_outline),
              ),
            ),
          ),
        if (control == FosTrayControl.chosenBadge)
          SizedBox(
            height: fosTrayControlHeight,
            child: state.chosen
                ? ExcludeSemantics(
                    child: Row(
                      key: Key('fractionsOfASetChosenBadge-${index + 1}'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle,
                            size: 18, color: scheme.primary),
                        const SizedBox(width: 2),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(chosenLabel,
                                style: TextStyle(
                                    color: scheme.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  )
                : null,
          ),
        if (statusRow)
          SizedBox(
            height: 20,
            child: state.differs
                ? ExcludeSemantics(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        differentLabel,
                        key: Key('fractionsOfASetDifferentLabel-${index + 1}'),
                        style: TextStyle(
                            color: warn,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                : null,
          ),
      ],
    );
  }
}

/// Counters two per row, three rows. Above six: five counters and a "+k"
/// badge; the numeral and semantics always give the exact count.
class _TrayCountersPainter extends CustomPainter {
  _TrayCountersPainter({
    required this.count,
    required this.variety,
    required this.ink,
    required this.badgeFill,
    required this.badgeInk,
    required this.highContrast,
    required this.textScaler,
  });

  final int count;
  final int variety;
  final Color ink;
  final Color badgeFill;
  final Color badgeInk;
  final bool highContrast;
  final TextScaler textScaler;

  @override
  void paint(Canvas canvas, Size size) {
    final drawn = count > 6 ? 5 : count;
    Offset at(int k) =>
        Offset((k % 2) * (fosCounterSize + 4), (k ~/ 2) * (fosCounterSize + 4));
    for (var k = 0; k < drawn; k++) {
      FosCountersPainter.paintCounter(canvas, at(k), k + variety, ink,
          highContrast: highContrast);
    }
    if (count > 6) {
      final o = at(5);
      final r = RRect.fromRectAndRadius(
          Rect.fromLTWH(o.dx, o.dy, fosCounterSize, fosCounterSize),
          const Radius.circular(6));
      canvas.drawRRect(r, Paint()..color = badgeFill);
      final tp = TextPainter(
        text: TextSpan(
          text: '+${count - 5}',
          style: TextStyle(
              color: badgeInk, fontSize: 11, fontWeight: FontWeight.w700),
        ),
        textDirection: TextDirection.ltr,
        textScaler: TextScaler.noScaling,
      )..layout(maxWidth: fosCounterSize);
      tp.paint(
          canvas,
          o +
              Offset((fosCounterSize - tp.width) / 2,
                  (fosCounterSize - tp.height) / 2));
    }
  }

  @override
  bool shouldRepaint(_TrayCountersPainter old) =>
      old.count != count ||
      old.variety != variety ||
      old.ink != ink ||
      old.badgeFill != badgeFill ||
      old.badgeInk != badgeInk ||
      old.highContrast != highContrast ||
      old.textScaler != textScaler;
}

/// Keyboard focus ring colour: near-black on light, white on dark. Neither
/// is used by any tray state (selected = primary, different = amber,
/// equal = green, idle = outline).
Color fosFocusRingColour(bool dark) =>
    dark ? Colors.white : const Color(0xFF111827);

/// Contrasting halo between the ring and the tray, so the ring reads on any
/// tray or page background.
Color fosFocusHaloColour(bool dark) => dark ? Colors.black : Colors.white;

/// Ring width: 3 dp, or 4 dp in high contrast.
double fosFocusRingWidth(bool highContrast) => highContrast ? 4 : 3;

/// Halo width between ring and tray.
const double fosFocusHaloWidth = 2;

/// A tray target that shows an unmistakable ring outside the tray while it
/// has keyboard focus. The ring sits outside the tray (within the tray gap),
/// above everything the tray paints, so it never hides the tray's own state
/// outline and is never hidden by the tray background.
class _TrayFocusFrame extends StatefulWidget {
  const _TrayFocusFrame({
    required this.index,
    required this.onTap,
    required this.child,
  });

  final int index;
  final VoidCallback onTap;
  final Widget child;

  @override
  State<_TrayFocusFrame> createState() => _TrayFocusFrameState();
}

class _TrayFocusFrameState extends State<_TrayFocusFrame> {
  bool _focused = false;

  bool get _keyboard =>
      FocusManager.instance.highlightMode == FocusHighlightMode.traditional;

  @override
  void initState() {
    super.initState();
    FocusManager.instance.addHighlightModeListener(_onHighlightMode);
  }

  @override
  void dispose() {
    FocusManager.instance.removeHighlightModeListener(_onHighlightMode);
    super.dispose();
  }

  void _onHighlightMode(FocusHighlightMode _) {
    if (mounted && _focused) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final hc = MediaQuery.highContrastOf(context);
    final ring = fosFocusRingWidth(hc);
    final outset = ring + fosFocusHaloWidth;
    final n = widget.index + 1;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            key: Key('fractionsOfASetTray-$n'),
            borderRadius: BorderRadius.circular(10),
            onTap: widget.onTap,
            onFocusChange: (f) => setState(() => _focused = f),
            child: widget.child,
          ),
        ),
        if (_focused && _keyboard)
          Positioned(
            left: -outset,
            top: -outset,
            right: -outset,
            bottom: -outset,
            child: IgnorePointer(
              child: DecoratedBox(
                key: Key('fractionsOfASetTrayFocusRing-$n'),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10 + outset),
                  border:
                      Border.all(color: fosFocusRingColour(dark), width: ring),
                ),
                child: Padding(
                  padding: EdgeInsets.all(ring),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(10 + fosFocusHaloWidth),
                      border: Border.all(
                          color: fosFocusHaloColour(dark),
                          width: fosFocusHaloWidth),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
