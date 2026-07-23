import 'package:flutter/material.dart';

import '../../models/discovery_card.dart';

/// Renders a card's illustration. RC1 ships no bundled per-card artwork yet
/// (see the ComfyUI-ready asset-interface deliverable for the future
/// pipeline), so every [illustrationAssetId] currently resolves to this
/// accessible, deterministic, category-based placeholder rather than a
/// missing-image glyph.
///
/// [headerImageAssetPath] is the prepared slot for that future mid-century
/// ComfyUI artwork: no Discovery Card sets it today (no unapproved artwork
/// has been generated or installed), so every call site currently falls
/// straight through to the icon placeholder below. Once an approved image
/// is installed for a card, passing its asset path here is the only change
/// needed — the icon rendering remains as the permanent fallback if the
/// asset is ever missing.
class DiscoveryIllustration extends StatelessWidget {
  const DiscoveryIllustration({
    super.key,
    required this.card,
    required this.semanticLabel,
    this.size = 96,
    this.headerImageAssetPath,
  });

  final DiscoveryCard card;
  final String semanticLabel;
  final double size;
  final String? headerImageAssetPath;

  static const _categoryIcons = <DiscoveryCategory, IconData>{
    DiscoveryCategory.everydayLife: Icons.home_outlined,
    DiscoveryCategory.shopping: Icons.shopping_bag_outlined,
    DiscoveryCategory.cooking: Icons.restaurant_outlined,
    DiscoveryCategory.sports: Icons.sports_outlined,
    DiscoveryCategory.aviation: Icons.flight_outlined,
    DiscoveryCategory.truckingLogistics: Icons.local_shipping_outlined,
    DiscoveryCategory.healthcare: Icons.medical_services_outlined,
    DiscoveryCategory.engineeringConstruction: Icons.engineering_outlined,
    DiscoveryCategory.artDesign: Icons.palette_outlined,
    DiscoveryCategory.gaming: Icons.sports_esports_outlined,
    DiscoveryCategory.businessFinance: Icons.trending_up_outlined,
  };

  static const _sportIcons = <SportType, IconData>{
    SportType.cricket: Icons.sports_cricket_outlined,
    SportType.football: Icons.sports_soccer_outlined,
    SportType.basketball: Icons.sports_basketball_outlined,
    SportType.americanFootball: Icons.sports_football_outlined,
    SportType.baseball: Icons.sports_baseball_outlined,
    SportType.tennis: Icons.sports_tennis_outlined,
  };

  static const _categoryColors = <DiscoveryCategory, Color>{
    DiscoveryCategory.everydayLife: Color(0xFF5B8EFF),
    DiscoveryCategory.shopping: Color(0xFF34C759),
    DiscoveryCategory.cooking: Color(0xFFFF9500),
    DiscoveryCategory.sports: Color(0xFF00BCD4),
    DiscoveryCategory.aviation: Color(0xFF7C5FFF),
    DiscoveryCategory.truckingLogistics: Color(0xFFFFBD00),
    DiscoveryCategory.healthcare: Color(0xFFFF6B6B),
    DiscoveryCategory.engineeringConstruction: Color(0xFF8A9DC0),
    DiscoveryCategory.artDesign: Color(0xFFE056FD),
    DiscoveryCategory.gaming: Color(0xFF3D7EFF),
    DiscoveryCategory.businessFinance: Color(0xFF00BCD4),
  };

  Widget _iconFallback(Color color, IconData icon) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(size * 0.18),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Icon(icon, color: color, size: size * 0.48),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sport = card.sport;
    final icon = sport != null ? _sportIcons[sport]! : _categoryIcons[card.category]!;
    final color = _categoryColors[card.category]!;
    final imagePath = headerImageAssetPath;

    return Semantics(
      label: semanticLabel,
      image: true,
      child: ExcludeSemantics(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size * 0.18),
          child: imagePath == null
              ? _iconFallback(color, icon)
              : Image.asset(
                  imagePath,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _iconFallback(color, icon),
                ),
        ),
      ),
    );
  }
}
