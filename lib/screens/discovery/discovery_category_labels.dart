import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/discovery_card.dart';

/// Centralised category/difficulty display-name lookup, shared by the
/// library grid and the card detail screen so labels never drift apart.
String discoveryCategoryLabel(
    AppLocalizations l10n, DiscoveryCategory category) {
  return switch (category) {
    DiscoveryCategory.everydayLife => l10n.mathStudioCategoryEverydayLife,
    DiscoveryCategory.shopping => l10n.mathStudioCategoryShopping,
    DiscoveryCategory.cooking => l10n.mathStudioCategoryCooking,
    DiscoveryCategory.sports => l10n.mathStudioCategorySports,
    DiscoveryCategory.aviation => l10n.mathStudioCategoryAviation,
    DiscoveryCategory.truckingLogistics =>
      l10n.mathStudioCategoryTruckingLogistics,
    DiscoveryCategory.healthcare => l10n.mathStudioCategoryHealthcare,
    DiscoveryCategory.engineeringConstruction =>
      l10n.mathStudioCategoryEngineeringConstruction,
    DiscoveryCategory.artDesign => l10n.mathStudioCategoryArtDesign,
    DiscoveryCategory.gaming => l10n.mathStudioCategoryGaming,
    DiscoveryCategory.businessFinance => l10n.mathStudioCategoryBusinessFinance,
    DiscoveryCategory.architectureConstruction =>
      l10n.mathStudioCategoryArchitectureConstruction,
    DiscoveryCategory.environmentClimate =>
      l10n.mathStudioCategoryEnvironmentClimate,
    DiscoveryCategory.computingCryptography =>
      l10n.mathStudioCategoryComputingCryptography,
  };
}

String discoveryDifficultyLabel(
    AppLocalizations l10n, CardDifficulty difficulty) {
  return switch (difficulty) {
    CardDifficulty.foundation => l10n.mathStudioDifficultyFoundation,
    CardDifficulty.intermediate => l10n.mathStudioDifficultyIntermediate,
    CardDifficulty.advanced => l10n.mathStudioDifficultyAdvanced,
  };
}
