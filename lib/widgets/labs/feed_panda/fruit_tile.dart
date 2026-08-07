import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'apple_visual.dart';

/// One fruit in the source matrix. Supports two equivalent input paths —
/// drag-and-drop (`Draggable<String>`, data = fruit id) and tap-to-select
/// (a plain `onTap`, with keyboard activation via [FocusableActionDetector]
/// for web/desktop) — neither is required over the other; the parent
/// screen decides what a "drop on Panda" vs. "tap Panda while selected"
/// means. This widget only knows about a single fruit's own presentation
/// and input, never the round state.
class FruitTile extends StatelessWidget {
  const FruitTile({
    super.key,
    required this.fruitId,
    required this.semanticLabel,
    required this.selected,
    required this.locked,
    required this.onSelect,
    required this.onDragReturned,
    this.size = 56,
  });

  final String fruitId;
  final double size;

  /// e.g. "Apple 2 of 5. Double tap to select." — built by the caller,
  /// which knows the index/total across the whole matrix.
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

  @override
  Widget build(BuildContext context) {
    final apple = AppleVisual(size: size);

    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: FocusableActionDetector(
          enabled: !locked,
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                onSelect();
                return null;
              },
            ),
          },
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
            SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
          },
          child: Draggable<String>(
            data: fruitId,
            maxSimultaneousDrags: locked ? 0 : 1,
            feedback: Material(
              color: Colors.transparent,
              child: AppleVisual(size: size * 1.15),
            ),
            childWhenDragging: AppleVisual(size: size, faded: true),
            onDraggableCanceled: (_, __) => onDragReturned(),
            child: GestureDetector(
              onTap: locked ? null : onSelect,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color:
                        selected ? const Color(0xFF00BCD4) : Colors.transparent,
                    width: 2.5,
                  ),
                  color: selected
                      ? const Color(0xFF00BCD4).withValues(alpha: 0.12)
                      : Colors.transparent,
                ),
                child: apple,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
