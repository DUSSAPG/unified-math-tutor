import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../models/abacus_state.dart';

/// Wording for the abacus and its Number Board, built from localised parts so
/// each language controls its own plurals and joining.
class AbacusText {
  const AbacusText._();

  /// The non-zero place-value parts, most significant first, e.g.
  /// `['3 tens', '4 ones']`.
  static List<String> parts(AppLocalizations l10n, AbacusState s) => [
        if (s.hundreds > 0) l10n.abacusPlayPartHundreds(s.hundreds),
        if (s.tens > 0) l10n.abacusPlayPartTens(s.tens),
        if (s.ones > 0) l10n.abacusPlayPartOnes(s.ones),
      ];

  /// Visible line: `34 = 3 tens + 4 ones`.
  static String equation(AppLocalizations l10n, AbacusState s) {
    final p = parts(l10n, s);
    switch (p.length) {
      case 0:
        return l10n.abacusBoardZero;
      case 1:
        return l10n.abacusBoardEquationOne(s.value, p[0]);
      case 2:
        return l10n.abacusBoardEquationTwo(s.value, p[0], p[1]);
      default:
        return l10n.abacusBoardEquationThree(s.value, p[0], p[1], p[2]);
    }
  }

  /// Spoken / screen-reader equivalent: `34 is 3 tens and 4 ones`.
  static String spoken(AppLocalizations l10n, AbacusState s) {
    final p = parts(l10n, s);
    switch (p.length) {
      case 0:
        return l10n.abacusSpokenZero;
      case 1:
        return l10n.abacusSpokenOne(s.value, p[0]);
      case 2:
        return l10n.abacusSpokenTwo(s.value, p[0], p[1]);
      default:
        return l10n.abacusSpokenThree(s.value, p[0], p[1], p[2]);
    }
  }

  static String? exchangeNote(AppLocalizations l10n, AbacusExchangeNote note) {
    switch (note) {
      case AbacusExchangeNote.none:
        return null;
      case AbacusExchangeNote.tenOnesForTen:
        return l10n.abacusPlayNoteTenOnes;
      case AbacusExchangeNote.tenTensForHundred:
        return l10n.abacusPlayNoteTenTens;
      case AbacusExchangeNote.tenOnesAndTensCascade:
        return l10n.abacusPlayNoteTenOnesAndTens;
      case AbacusExchangeNote.tenForTenOnes:
        return l10n.abacusPlayNoteTenToOnes;
      case AbacusExchangeNote.hundredForTenTens:
        return l10n.abacusPlayNoteHundredToTens;
      case AbacusExchangeNote.hundredCascade:
        return l10n.abacusPlayNoteHundredCascade;
    }
  }

  static String rodName(AppLocalizations l10n, AbacusRod rod) {
    switch (rod) {
      case AbacusRod.hundreds:
        return l10n.abacusColumnHundreds;
      case AbacusRod.tens:
        return l10n.abacusColumnTens;
      case AbacusRod.ones:
        return l10n.abacusColumnOnes;
    }
  }
}
