import 'package:flutter/material.dart';

/// General-purpose semantic color tokens, resolved from the active
/// [ThemeData] rather than hardcoded per-widget — the antidote to this
/// app's historical pattern of `Color(0xFF...)` literals scattered through
/// every screen. [AppTheme.dark] is a direct, pixel-for-pixel port of the
/// values every screen already hardcodes; [AppTheme.light] is new.
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.background,
    required this.elevatedSurface,
    required this.cardSurface,
    required this.primaryText,
    required this.secondaryText,
    required this.tertiaryText,
    required this.divider,
    required this.primaryAction,
    required this.onPrimaryAction,
    required this.accent,
    required this.success,
    required this.warning,
    required this.error,
  });

  /// The page/scaffold background.
  final Color background;

  /// App bars, bottom nav / nav rail — sits structurally "above" the page.
  final Color elevatedSurface;

  /// Cards, panels, containers.
  final Color cardSurface;

  final Color primaryText;
  final Color secondaryText;

  /// De-emphasized text/icons — chevrons, footers, disabled-adjacent
  /// captions. Dimmer than [secondaryText].
  final Color tertiaryText;

  final Color divider;

  /// The app's brand blue — deliberately identical across both themes.
  final Color primaryAction;
  final Color onPrimaryAction;

  /// A lighter interactive blue used for icons, selected-state text, links
  /// and chip/segment accents — distinct from [primaryAction] (button
  /// fills). Both read as "brand blue" but this app has consistently used
  /// two shades for these two different roles since before this sprint.
  final Color accent;

  final Color success;
  final Color warning;
  final Color error;

  @override
  AppSemanticColors copyWith({
    Color? background,
    Color? elevatedSurface,
    Color? cardSurface,
    Color? primaryText,
    Color? secondaryText,
    Color? tertiaryText,
    Color? divider,
    Color? primaryAction,
    Color? onPrimaryAction,
    Color? accent,
    Color? success,
    Color? warning,
    Color? error,
  }) {
    return AppSemanticColors(
      background: background ?? this.background,
      elevatedSurface: elevatedSurface ?? this.elevatedSurface,
      cardSurface: cardSurface ?? this.cardSurface,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      tertiaryText: tertiaryText ?? this.tertiaryText,
      divider: divider ?? this.divider,
      primaryAction: primaryAction ?? this.primaryAction,
      onPrimaryAction: onPrimaryAction ?? this.onPrimaryAction,
      accent: accent ?? this.accent,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      background: Color.lerp(background, other.background, t)!,
      elevatedSurface: Color.lerp(elevatedSurface, other.elevatedSurface, t)!,
      cardSurface: Color.lerp(cardSurface, other.cardSurface, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      tertiaryText: Color.lerp(tertiaryText, other.tertiaryText, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      primaryAction: Color.lerp(primaryAction, other.primaryAction, t)!,
      onPrimaryAction: Color.lerp(onPrimaryAction, other.onPrimaryAction, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
    );
  }
}

/// Color tokens specific to the Interactive Labs' hand-drawn visuals
/// (football pitch, maze board, flight radar) — kept separate from
/// [AppSemanticColors] because these are simulated physical environments,
/// not UI chrome, and `CustomPainter`s can't call `Theme.of(context)`
/// themselves (the wrapping widget resolves this extension once and passes
/// plain [Color]s into the painter's constructor).
class AppLabColors extends ThemeExtension<AppLabColors> {
  const AppLabColors({
    required this.pitchSurface,
    required this.targetHighlight,
    required this.ballColor,
    required this.robotColor,
    required this.mazeRoad,
    required this.mazeWall,
    required this.mazeGrass,
    required this.radarGrid,
    required this.radarTarget,
    required this.radarLanding,
    required this.flightPath,
  });

  final Color pitchSurface;
  final Color targetHighlight;
  final Color ballColor;
  final Color robotColor;

  final Color mazeRoad;
  final Color mazeWall;
  final Color mazeGrass;

  final Color radarGrid;
  final Color radarTarget;
  final Color radarLanding;
  final Color flightPath;

  @override
  AppLabColors copyWith({
    Color? pitchSurface,
    Color? targetHighlight,
    Color? ballColor,
    Color? robotColor,
    Color? mazeRoad,
    Color? mazeWall,
    Color? mazeGrass,
    Color? radarGrid,
    Color? radarTarget,
    Color? radarLanding,
    Color? flightPath,
  }) {
    return AppLabColors(
      pitchSurface: pitchSurface ?? this.pitchSurface,
      targetHighlight: targetHighlight ?? this.targetHighlight,
      ballColor: ballColor ?? this.ballColor,
      robotColor: robotColor ?? this.robotColor,
      mazeRoad: mazeRoad ?? this.mazeRoad,
      mazeWall: mazeWall ?? this.mazeWall,
      mazeGrass: mazeGrass ?? this.mazeGrass,
      radarGrid: radarGrid ?? this.radarGrid,
      radarTarget: radarTarget ?? this.radarTarget,
      radarLanding: radarLanding ?? this.radarLanding,
      flightPath: flightPath ?? this.flightPath,
    );
  }

  @override
  AppLabColors lerp(ThemeExtension<AppLabColors>? other, double t) {
    if (other is! AppLabColors) return this;
    return AppLabColors(
      pitchSurface: Color.lerp(pitchSurface, other.pitchSurface, t)!,
      targetHighlight: Color.lerp(targetHighlight, other.targetHighlight, t)!,
      ballColor: Color.lerp(ballColor, other.ballColor, t)!,
      robotColor: Color.lerp(robotColor, other.robotColor, t)!,
      mazeRoad: Color.lerp(mazeRoad, other.mazeRoad, t)!,
      mazeWall: Color.lerp(mazeWall, other.mazeWall, t)!,
      mazeGrass: Color.lerp(mazeGrass, other.mazeGrass, t)!,
      radarGrid: Color.lerp(radarGrid, other.radarGrid, t)!,
      radarTarget: Color.lerp(radarTarget, other.radarTarget, t)!,
      radarLanding: Color.lerp(radarLanding, other.radarLanding, t)!,
      flightPath: Color.lerp(flightPath, other.flightPath, t)!,
    );
  }
}

extension AppThemeContext on BuildContext {
  /// Falls back to [AppTheme._darkSemanticColors] rather than force
  /// -unwrapping — any `MaterialApp` that doesn't set `theme`/`darkTheme`
  /// to [AppTheme.light]/[AppTheme.dark] (a bare `ThemeData()`, e.g. in a
  /// widget test that hasn't been updated) still renders these tokens as
  /// today's dark colors instead of crashing.
  AppSemanticColors get appColors =>
      Theme.of(this).extension<AppSemanticColors>() ??
      AppTheme._darkSemanticColors;
  AppLabColors get labColors =>
      Theme.of(this).extension<AppLabColors>() ?? AppTheme._darkLabColors;
}

class AppTheme {
  AppTheme._();

  // ── Dark — a direct port of every value every screen already hardcodes.
  // Zero visual change versus today.
  static const _darkBackground = Color(0xFF0B1120);
  static const _darkElevatedSurface = Color(0xFF0D1526);
  static const _darkCardSurface = Color(0xFF132040);
  static const _darkDivider = Color(0xFF1F3055);
  static const _darkSecondaryText = Color(0xFF8A9DC0);
  static const _darkDim = Color(0xFF4A6080);
  static const _brandBlue = Color(0xFF3D7EFF);
  static const _darkAccent = Color(0xFF5B8EFF);
  static const _darkSuccess = Color(0xFF34C759);
  static const _darkWarning = Color(0xFFFFBD00);
  static const _darkError = Color(0xFFE91E63);

  static const _darkSemanticColors = AppSemanticColors(
    background: _darkBackground,
    elevatedSurface: _darkElevatedSurface,
    cardSurface: _darkCardSurface,
    primaryText: Colors.white,
    secondaryText: _darkSecondaryText,
    tertiaryText: _darkDim,
    divider: _darkDivider,
    primaryAction: _brandBlue,
    onPrimaryAction: Colors.white,
    accent: _darkAccent,
    success: _darkSuccess,
    warning: _darkWarning,
    error: _darkError,
  );

  static const _darkLabColors = AppLabColors(
    pitchSurface: Color(0xFF0E3B28),
    targetHighlight: _darkWarning,
    ballColor: Colors.white,
    // Matches Football Precision's pre-existing hardcoded idle robot color
    // (0xFF5B8EFF) exactly — a pixel-exact port, not _brandBlue.
    robotColor: _darkAccent,
    mazeRoad: Color(0xFF39425C),
    mazeWall: Color(0xFF8A5A32),
    mazeGrass: Color(0xFF16381F),
    radarGrid: _darkDivider,
    radarTarget: _darkWarning,
    radarLanding: _brandBlue,
    flightPath: _darkSuccess,
  );

  // ── Light — pale blue-grey background, soft blue elevated surface,
  // blue-lilac cards, near-black/deep-charcoal text, dark-slate secondary
  // text, muted blue-grey dividers. Never harsh pure white.
  static const _lightBackground = Color(0xFFEDF1F8);
  static const _lightElevatedSurface = Color(0xFFDCE6F7);
  static const _lightCardSurface = Color(0xFFF3EFFC);
  static const _lightDivider = Color(0xFFC7D0E0);
  static const _lightPrimaryText = Color(0xFF171B24);
  static const _lightSecondaryText = Color(0xFF48536B);
  static const _lightDim = Color(0xFF7A879E);
  // Darker than the dark theme's 0xFF5B8EFF — that value's contrast against
  // a pale background is too low for text/icon use (contrast-tested).
  static const _lightAccent = Color(0xFF2A56C4);
  static const _lightSuccess = Color(0xFF1E8E3E);
  static const _lightWarning = Color(0xFFAD5700);
  static const _lightError = Color(0xFFC62828);

  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        semantic: _darkSemanticColors,
        lab: _darkLabColors,
      );

  static ThemeData light() => _build(
        brightness: Brightness.light,
        semantic: const AppSemanticColors(
          background: _lightBackground,
          elevatedSurface: _lightElevatedSurface,
          cardSurface: _lightCardSurface,
          primaryText: _lightPrimaryText,
          secondaryText: _lightSecondaryText,
          tertiaryText: _lightDim,
          divider: _lightDivider,
          primaryAction: _brandBlue,
          onPrimaryAction: Colors.white,
          accent: _lightAccent,
          success: _lightSuccess,
          warning: _lightWarning,
          error: _lightError,
        ),
        lab: const AppLabColors(
          // Pitch/maze/radar stay recognisable "physical environment"
          // colors rather than washing out to pale neutrals — a daylight
          // grass green, not a pastel one — while target/ball/robot keep
          // enough contrast against them either way.
          pitchSurface: Color(0xFF2E7D4F),
          targetHighlight: _darkWarning,
          ballColor: Colors.white,
          // Brand blue reads too close in luminance to this lighter grass
          // green (contrast-tested) — near-black charcoal keeps the robot
          // clearly readable against a daylight pitch.
          robotColor: _lightPrimaryText,
          mazeRoad: Color(0xFFCBD2E3),
          mazeWall: Color(0xFF7A4A28),
          mazeGrass: Color(0xFFBFE3C8),
          // The radar canvas sits directly on the light page background
          // (unlike the pitch/maze, which paint their own field), so its
          // target/landing markers need the darker, light-mode-safe
          // warning/action tokens instead of the brighter dark-mode ones.
          radarGrid: _lightDivider,
          radarTarget: _lightWarning,
          radarLanding: _brandBlue,
          flightPath: _lightSuccess,
        ),
      );

  static ThemeData _build({
    required Brightness brightness,
    required AppSemanticColors semantic,
    required AppLabColors lab,
  }) {
    final dim = semantic.tertiaryText;
    final disabledBg = semantic.divider;
    final isDark = brightness == Brightness.dark;
    final colorScheme = isDark
        ? ColorScheme.dark(
            primary: semantic.primaryAction,
            onPrimary: semantic.onPrimaryAction,
            secondary: semantic.secondaryText,
            onSecondary: semantic.onPrimaryAction,
            surface: semantic.cardSurface,
            onSurface: semantic.primaryText,
            error: semantic.error,
            onError: Colors.white,
            outline: semantic.divider,
          )
        : ColorScheme.light(
            primary: semantic.primaryAction,
            onPrimary: semantic.onPrimaryAction,
            secondary: semantic.secondaryText,
            onSecondary: Colors.white,
            surface: semantic.cardSurface,
            onSurface: semantic.primaryText,
            error: semantic.error,
            onError: Colors.white,
            outline: semantic.divider,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: semantic.background,
      colorScheme: colorScheme,
      extensions: [semantic, lab],
      appBarTheme: AppBarTheme(
        backgroundColor: semantic.background,
        foregroundColor: semantic.primaryText,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: semantic.primaryText,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: semantic.primaryText),
      ),
      cardTheme: CardThemeData(
        color: semantic.cardSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: semantic.divider),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: semantic.elevatedSurface,
        selectedItemColor: semantic.primaryAction,
        unselectedItemColor: dim,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: semantic.elevatedSurface,
        selectedIconTheme: IconThemeData(color: semantic.primaryAction),
        unselectedIconTheme: IconThemeData(color: dim),
        selectedLabelTextStyle: TextStyle(
          color: semantic.primaryAction,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelTextStyle: TextStyle(color: dim, fontSize: 12),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: semantic.primaryAction,
          foregroundColor: semantic.onPrimaryAction,
          disabledBackgroundColor: disabledBg,
          disabledForegroundColor: dim,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: semantic.primaryAction,
          foregroundColor: semantic.onPrimaryAction,
          disabledBackgroundColor: disabledBg,
          disabledForegroundColor: dim,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: semantic.primaryAction),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: semantic.cardSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: semantic.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: semantic.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: semantic.primaryAction, width: 2),
        ),
        hintStyle: TextStyle(color: dim),
        labelStyle: TextStyle(color: semantic.secondaryText),
      ),
      dividerTheme: DividerThemeData(color: semantic.divider),
      fontFamily: 'DMSans',
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'DMSerifDisplay',
          fontSize: 40,
          fontWeight: FontWeight.w400,
          color: semantic.primaryText,
          height: 1.2,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontFamily: 'DMSerifDisplay',
          fontSize: 32,
          fontWeight: FontWeight.w400,
          color: semantic.primaryText,
          height: 1.2,
          letterSpacing: -0.5,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: semantic.primaryText,
          height: 1.3,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: semantic.primaryText,
          height: 1.3,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: semantic.primaryText,
          height: 1.4,
        ),
        titleLarge: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: semantic.primaryText,
          height: 1.4,
        ),
        titleMedium: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: semantic.primaryText,
          height: 1.5,
        ),
        titleSmall: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: semantic.secondaryText,
          height: 1.4,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: semantic.secondaryText,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: semantic.secondaryText,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: dim,
          height: 1.3,
        ),
        labelLarge: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: semantic.primaryText,
          height: 1.3,
        ),
        labelMedium: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: semantic.secondaryText,
        ),
        labelSmall: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: dim,
        ),
      ),
    );
  }
}
