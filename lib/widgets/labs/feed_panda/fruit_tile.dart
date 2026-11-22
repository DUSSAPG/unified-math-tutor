import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'apple_visual.dart';

/// One apple in the garden basket. Supports two equivalent input paths —
/// drag-and-drop (`Draggable<String>`, data = fruit id) and tap-to-select
/// (a plain tap, a screen-reader activation, or Enter/Space via
/// [FocusableActionDetector]) — neither is required over the other; the
/// parent screen decides what a "drop on Panda" vs. "activate Panda while
/// selected" means. This widget only knows about a single apple's own
/// presentation and input, never the round state.
///
/// Panda Garden V1: selection is shown by three cues that do not depend on
/// colour — the apple lifts off its shadow, a ring appears, and a check
/// badge appears — and keyboard focus draws its own separate focus ring.
class FruitTile extends StatefulWidget {
  const FruitTile({
    super.key,
    required this.fruitId,
    required this.semanticLabel,
    required this.selected,
    required this.locked,
    required this.onSelect,
    required this.onDragReturned,
    this.size = 56,
    this.reduceMotion = false,
  });

  final String fruitId;
  final double size;

  /// e.g. "Apple 2 of 5. Double tap to select." — built by the caller,
  /// which knows the index/total across the whole basket.
  final String semanticLabel;

  final bool selected;

  /// True during the chew-transition lock — input must be ignored, safely
  /// (no dangling drag, no tap accepted).
  final bool locked;

  final VoidCallback onSelect;

  /// Called when a drag ends without being accepted by Panda's drop
  /// target — the apple already visually returns to its source position
  /// (Draggable's own default behaviour when nothing accepts it); this is
  /// purely for event logging.
  final VoidCallback onDragReturned;

  /// Under Reduce Motion the selection ring/lift change is applied
  /// instantly instead of easing in.
  final bool reduceMotion;

  static const Color selectionColor = Color(0xFF00ACC1);

  /// The tile frame around the apple. Shared by the normal tile and the
  /// faded drag placeholder so both occupy an identical footprint.
  static const double framePadding = 4;
  static const double frameBorderWidth = 2.5;

  @override
  State<FruitTile> createState() => _FruitTileState();
}

class _FruitTileState extends State<FruitTile> {
  bool _focusHighlighted = false;

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final selected = widget.selected;
    final focusColor = Theme.of(context).colorScheme.primary;

    return Semantics(
      button: true,
      selected: selected,
      enabled: !widget.locked,
      label: widget.semanticLabel,
      onTap: widget.locked ? null : widget.onSelect,
      child: ExcludeSemantics(
        child: FocusableActionDetector(
          enabled: !widget.locked,
          onShowFocusHighlight: (value) =>
              setState(() => _focusHighlighted = value),
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                widget.onSelect();
                return null;
              },
            ),
          },
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
            SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
          },
          child: Draggable<String>(
            data: widget.fruitId,
            maxSimultaneousDrags: widget.locked ? 0 : 1,
            // The dragged apple is shown in its lifted pose — higher above
            // a smaller, softer shadow — at a slightly larger size.
            feedback: Material(
              color: Colors.transparent,
              child: AppleVisual(
                key: const Key('feedPandaDragFeedbackApple'),
                size: size * 1.15,
                lifted: true,
              ),
            ),
            // The faded placeholder keeps the tile's exact footprint (same
            // padding, border width and radius as the normal tile below), so
            // the remaining apples never reflow between rows mid-drag.
            childWhenDragging: Container(
              key: const Key('feedPandaDragPlaceholder'),
              padding: const EdgeInsets.all(FruitTile.framePadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.transparent,
                  width: FruitTile.frameBorderWidth,
                ),
              ),
              child: AppleVisual(size: size, faded: true),
            ),
            onDraggableCanceled: (_, __) => widget.onDragReturned(),
            child: GestureDetector(
              onTap: widget.locked ? null : widget.onSelect,
              child: AnimatedContainer(
                duration: widget.reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 150),
                padding: const EdgeInsets.all(FruitTile.framePadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _focusHighlighted
                        ? focusColor
                        : selected
                            ? FruitTile.selectionColor
                            : Colors.transparent,
                    width: _focusHighlighted ? 3 : FruitTile.frameBorderWidth,
                  ),
                  color: selected
                      ? FruitTile.selectionColor.withValues(alpha: 0.14)
                      : Colors.transparent,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AppleVisual(
                      key: ValueKey('feedPandaApple_${widget.fruitId}'),
                      size: size,
                      lifted: selected,
                    ),
                    if (selected)
                      Positioned(
                        key: const Key('feedPandaSelectedBadge'),
                        right: -2,
                        top: -2,
                        child: Container(
                          width: size * 0.36,
                          height: size * 0.36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: FruitTile.selectionColor,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: size * 0.24,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
