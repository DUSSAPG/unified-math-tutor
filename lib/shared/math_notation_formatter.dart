/// Display-only, non-destructive normalization of the raw question-bank
/// notation to professional mathematical typography. Never mutates stored
/// question data — only the text actually rendered to a learner.
///
/// This is a narrow stopgap covering the two highest-confidence, highest-
/// volume patterns found in the question banks (bare exponents and bare
/// multiplication). Proper fraction typesetting, LaTeX-quality rendering,
/// and structured worked solutions are the job of a later, dedicated
/// mathematical-rendering pass — deliberately not attempted here.
class MathNotationFormatter {
  MathNotationFormatter._();

  static const Map<String, String> _superscriptDigits = {
    '0': '⁰',
    '1': '¹',
    '2': '²',
    '3': '³',
    '4': '⁴',
    '5': '⁵',
    '6': '⁶',
    '7': '⁷',
    '8': '⁸',
    '9': '⁹',
    '-': '⁻',
    '+': '⁺',
  };

  static final RegExp _exponentPattern = RegExp(r'\^(-?\d+)');

  /// Rewrites `x^2` → `x²`, `10^-3` → `10⁻³`, and bare `*` → `×`.
  static String format(String input) {
    if (input.isEmpty) return input;
    final withSuperscripts = input.replaceAllMapped(_exponentPattern, (match) {
      final exponent = match.group(1)!;
      return exponent
          .split('')
          .map((ch) => _superscriptDigits[ch] ?? ch)
          .join();
    });
    return withSuperscripts.replaceAll('*', '×');
  }
}
