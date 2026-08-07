import 'package:flutter/material.dart';

import 'fruit_tile.dart';

/// The source matrix of fruit a learner picks from. Purely responsive —
/// no fixed screen coordinates anywhere. Uses [LayoutBuilder] to size
/// tiles from the available width so the same widget works from a compact
/// phone up to a wide desktop/web viewport, wrapping to fewer tiles per
/// row rather than shrinking below a tappable minimum.
///
/// Accepted fruit are simply omitted — "leaves the source matrix" per the
/// brief — rather than shown crossed-out, keeping the remaining choice set
/// visually uncluttered for a young learner.
class FruitMatrix extends StatelessWidget {
  const FruitMatrix({
    super.key,
    required this.allFruitIds,
    required this.acceptedFruitIds,
    required this.selectedFruitId,
    required this.locked,
    required this.onSelect,
    required this.onDragReturned,
    required this.semanticLabelFor,
  });

  /// The full, stable set of ids for this round, in display order.
  final List<String> allFruitIds;
  final Set<String> acceptedFruitIds;
  final String? selectedFruitId;
  final bool locked;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onDragReturned;

  /// Builds the semantic label for a fruit id, e.g.
  /// "Apple 2 of 5. Double tap to select." — supplied by the caller so
  /// localisation lives at the screen level.
  final String Function(String fruitId, int position, int total)
      semanticLabelFor;

  @override
  Widget build(BuildContext context) {
    final visibleIds = [
      for (final id in allFruitIds)
        if (!acceptedFruitIds.contains(id)) id,
    ];

    return LayoutBuilder(
      key: const Key('feedPandaFruitMatrix'),
      builder: (context, constraints) {
        // Sized from available width, clamped to a comfortable tappable
        // range (48-96 logical px) rather than any fixed coordinate —
        // narrower viewports simply wrap to fewer tiles per row.
        final ideal = constraints.maxWidth / allFruitIds.length - 12;
        final tileSize = ideal.clamp(48.0, 96.0);

        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final id in visibleIds)
              FruitTile(
                key: ValueKey('fruit_$id'),
                fruitId: id,
                size: tileSize,
                selected: selectedFruitId == id,
                locked: locked,
                onSelect: () => onSelect(id),
                onDragReturned: () => onDragReturned(id),
                semanticLabel: semanticLabelFor(
                  id,
                  allFruitIds.indexOf(id) + 1,
                  allFruitIds.length,
                ),
              ),
          ],
        );
      },
    );
  }
}
