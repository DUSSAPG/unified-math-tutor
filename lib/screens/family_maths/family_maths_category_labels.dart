import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/family_activity.dart';

/// Centralised category display-name lookup, shared by the library grid and
/// the activity detail screen so labels never drift apart. Mirrors
/// [discoveryCategoryLabel].
String familyMathsCategoryLabel(
    AppLocalizations l10n, FamilyMathsCategory category) {
  return switch (category) {
    FamilyMathsCategory.numberSense => l10n.familyMathsCategoryNumberSense,
    FamilyMathsCategory.addition => l10n.familyMathsCategoryAddition,
    FamilyMathsCategory.subtraction => l10n.familyMathsCategorySubtraction,
    FamilyMathsCategory.multiplication =>
      l10n.familyMathsCategoryMultiplication,
    FamilyMathsCategory.division => l10n.familyMathsCategoryDivision,
    FamilyMathsCategory.fractions => l10n.familyMathsCategoryFractions,
    FamilyMathsCategory.decimals => l10n.familyMathsCategoryDecimals,
    FamilyMathsCategory.ratio => l10n.familyMathsCategoryRatio,
    FamilyMathsCategory.percentages => l10n.familyMathsCategoryPercentages,
    FamilyMathsCategory.geometry => l10n.familyMathsCategoryGeometry,
    FamilyMathsCategory.measurement => l10n.familyMathsCategoryMeasurement,
    FamilyMathsCategory.algebra => l10n.familyMathsCategoryAlgebra,
    FamilyMathsCategory.patterns => l10n.familyMathsCategoryPatterns,
    FamilyMathsCategory.logic => l10n.familyMathsCategoryLogic,
    // Same concept, same phrase as the Mental Maths pillar — reuse its key
    // rather than authoring a near-duplicate.
    FamilyMathsCategory.mentalMaths => l10n.mathStudioMentalMathsTitle,
    FamilyMathsCategory.spatialReasoning =>
      l10n.familyMathsCategorySpatialReasoning,
  };
}
