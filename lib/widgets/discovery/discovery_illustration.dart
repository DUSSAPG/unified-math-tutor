import 'package:flutter/material.dart';

import '../../models/discovery_card.dart';

/// Illustration ids with an approved, promoted PNG under
/// `assets/discovery_illustrations/`. The generation/approval record for
/// each — prompt, seed, checkpoint, reviewer timestamp — lives in
/// `content/pipelines/discovery_illustrations/manifest.json`; nothing here
/// is added except through that reviewed, approved pipeline.
const _approvedIllustrationIds = <String>{
  'shopping_percentage_discount',
  'shopping_comparing_offers',
  'cooking_fraction_conversion',
  'everyday_household_budgeting',
  'cricket_batting_average',
  'football_pass_accuracy',
  'football_goal_conversion',
  'basketball_shooting_percentage',
  'basketball_points_per_shot',
  'baseball_batting_average',
  'baseball_field_geometry',
  'tennis_first_serve_percentage',
  'aviation_speed_distance_time',
  'trucking_fuel_economy',
  'trucking_delivery_scheduling',
  'healthcare_nurse_metric_conversion',
  'healthcare_temperature_conversion',
  'aviation_fuel_endurance',
  'americanfootball_completion_percentage',
  'everyday_split_a_bill',
  'americanfootball_yards_per_play',
  'cooking_scale_a_recipe',
  'cricket_required_run_rate',
  'tennis_court_dimensions',
};

/// Renders a card's illustration: an approved, generated PNG where one
/// exists for [DiscoveryCard.illustrationAssetId], otherwise the
/// accessible, deterministic, category-based icon placeholder below — never
/// a missing-image glyph.
///
/// [headerImageAssetPath] is an explicit override for a specific asset path
/// (rarely needed — the approved-id lookup above covers normal cases); the
/// icon fallback remains the permanent fallback if a referenced asset is
/// ever missing.
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
    final imagePath = headerImageAssetPath ??
        (_approvedIllustrationIds.contains(card.illustrationAssetId)
            ? 'assets/discovery_illustrations/${card.illustrationAssetId}.png'
            : null);

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
