import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../models/recall_card.dart';

/// Renders a Recall Card's visual. Mirrors [DiscoveryIllustration]: RC1 ships
/// no bundled per-card artwork (see the deferred ComfyUI recall-asset
/// pipeline work), so every card — whether or not it declares a
/// [RecallCard.frontVisualAssetId] — resolves to this accessible,
/// deterministic, card-type-based placeholder. Swapping in real art later
/// only means adding an asset lookup here.
class RecallIllustration extends StatelessWidget {
  const RecallIllustration({
    super.key,
    required this.card,
    required this.semanticLabel,
    this.size = 96,
  });

  final RecallCard card;
  final String semanticLabel;
  final double size;

  static const _typeIcons = <RecallCardType, IconData>{
    RecallCardType.formula: Icons.functions,
    RecallCardType.meaning: Icons.lightbulb_outline,
    // Was Icons.tag — a generic price-tag glyph with no mathematical
    // meaning. Sigma is a real, recognisable mathematical symbol, and
    // reads distinctly from Formula's f(x) glyph rather than overlapping
    // with it.
    RecallCardType.symbol: LucideIcons.sigma,
    RecallCardType.vocabulary: Icons.menu_book_outlined,
    RecallCardType.strategy: Icons.route_outlined,
    RecallCardType.misconception: Icons.report_gmailerrorred_outlined,
    RecallCardType.visual: Icons.visibility_outlined,
    RecallCardType.realWorldConnection: Icons.public,
  };

  static const _typeColors = <RecallCardType, Color>{
    RecallCardType.formula: Color(0xFF5B8EFF),
    RecallCardType.meaning: Color(0xFFFFBD00),
    RecallCardType.symbol: Color(0xFF7C5FFF),
    RecallCardType.vocabulary: Color(0xFF34C759),
    RecallCardType.strategy: Color(0xFF00BCD4),
    RecallCardType.misconception: Color(0xFFFF6B6B),
    RecallCardType.visual: Color(0xFFE056FD),
    RecallCardType.realWorldConnection: Color(0xFFFF9500),
  };

  @override
  Widget build(BuildContext context) {
    final icon = _typeIcons[card.cardType]!;
    final color = _typeColors[card.cardType]!;

    return Semantics(
      label: semanticLabel,
      image: true,
      child: ExcludeSemantics(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(size * 0.18),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Icon(icon, color: color, size: size * 0.48),
        ),
      ),
    );
  }
}
