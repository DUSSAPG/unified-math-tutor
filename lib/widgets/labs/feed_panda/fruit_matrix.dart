import 'package:flutter/material.dart';

import 'fruit_tile.dart';
import 'garden_basket.dart';

/// The source basket of apples a learner picks from. Purely responsive —
/// no fixed screen coordinates anywhere. Uses [LayoutBuilder] to size
/// tiles from the available width so the same widget works from a compact
/// phone up to a wide desktop/web viewport, wrapping to fewer tiles per
/// row rather than shrinking below a tappable minimum.
///
/// Accepted fruit are simply omitted — "leaves the source basket" per the
/// brief — rather than shown crossed-out, keeping the remaining choice set
/// visually uncluttered for a young learner. Panda Garden V1 draws the
/// apples inside a [GardenBasket] tray.
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
    this.basketSemanticLabel = '',
    this.reduceMotion = false,
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

  /// e.g. "4 apples in the basket." — supplied by the caller (localised).
  final String basketSemanticLabel;

  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final visibleIds = [
      for (final id in allFruitIds)
        if (!acceptedFruitIds.contains(id)) id,
    ];

    return LayoutBuilder(
      key: const Key('feedPandaFruitMatrix'),
      builder: (context, constraints) {
        // Sized from available width (less the basket's own padding),
        // clamped to a comfortable tappable range (48-96 logical px)
        // rather than any fixed coordinate — narrower viewports simply
        // wrap to fewer tiles per row.
        final inner = constraints.maxWidth - 36;
        final ideal = inner / allFruitIds.length - 20;
        final tileSize = ideal.clamp(48.0, 96.0);

        // The basket keeps the height it needs for the full round's apples
        // (tile + 4px padding and 2.5px border each side), so Panda never
        // shifts upward mid-round as apples leave and rows empty.
        const spacing = 12.0;
        final tileOuter = tileSize + 13;
        final perRow = ((inner + spacing) / (tileOuter + spacing))
            .floor()
            .clamp(1, allFruitIds.length);
        final rows = (allFruitIds.length / perRow).ceil();
        final fullHeight = rows * tileOuter + (rows - 1) * spacing;

        return GardenBasket(
          semanticLabel: basketSemanticLabel,
          child: ConstrainedBox(
            key: const Key('feedPandaBasketContents'),
            constraints: BoxConstraints(minHeight: fullHeight),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final id in visibleIds)
                  FruitTile(
                    key: ValueKey('fruit_$id'),
                    fruitId: id,
                    size: tileSize,
                    selected: selectedFruitId == id,
                    locked: locked,
                    reduceMotion: reduceMotion,
                    onSelect: () => onSelect(id),
                    onDragReturned: () => onDragReturned(id),
                    semanticLabel: semanticLabelFor(
                      id,
                      allFruitIds.indexOf(id) + 1,
                      allFruitIds.length,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
