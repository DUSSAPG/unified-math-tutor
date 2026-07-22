import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/mental_maths_challenge.dart';

String mentalMathsCategoryLabel(AppLocalizations l10n, MentalMathsCategory category) {
  return switch (category) {
    MentalMathsCategory.numberBonds => l10n.mentalMathsCategoryNumberBonds,
    MentalMathsCategory.decomposition => l10n.mentalMathsCategoryDecomposition,
    MentalMathsCategory.compensation => l10n.mentalMathsCategoryCompensation,
    MentalMathsCategory.estimation => l10n.mentalMathsCategoryEstimation,
    MentalMathsCategory.multiplicationStrategies =>
      l10n.mentalMathsCategoryMultiplicationStrategies,
    MentalMathsCategory.divisionStrategies => l10n.mentalMathsCategoryDivisionStrategies,
    MentalMathsCategory.percentages => l10n.mentalMathsCategoryPercentages,
    MentalMathsCategory.fractions => l10n.mentalMathsCategoryFractions,
    MentalMathsCategory.placeValue => l10n.mentalMathsCategoryPlaceValue,
    MentalMathsCategory.patternRecognition => l10n.mentalMathsCategoryPatternRecognition,
  };
}
