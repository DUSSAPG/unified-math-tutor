/// Centralized publishing/branding identity for every printable, PDF, or
/// shared learning asset. Never hard-code these strings into individual
/// widgets/services — read them from here so the identity can change once.
class PublishingConfig {
  static const String publisher = 'QuantumLexFin';
  static const String productLine = 'Math Intelligence';
  static const String pillarName = 'Math Studio';
  static const String tagline = 'A QuantumLab Learning Experience';
  static const String copyrightHolder = 'QuantumLab Education Ltd.';

  static int get copyrightYear => DateTime.now().year;

  /// Disabled until a confirmed, live destination exists. Do not flip this on
  /// or hard-code a URL elsewhere — set [websiteUrl] and this flag together.
  static const bool websiteQrEnabled = false;
  static const String? websiteUrl = null;

  static String get publishingHierarchy =>
      '$publisher • $productLine • $pillarName';
}
