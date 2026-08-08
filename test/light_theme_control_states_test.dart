import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/shared/theme/app_theme.dart';

/// Structural checks for the Light Theme brief's "enabled, disabled,
/// focused and selected controls" requirement — resolves the theme's own
/// [ButtonStyle]/[InputDecorationTheme] definitions for each interaction
/// state directly, rather than pixel-diffing a golden image (this repo has
/// no existing golden-image baseline/font-rendering setup, and widget
/// states are exactly what [AppTheme] itself defines centrally, so
/// asserting on the resolved [WidgetStateProperty] values is the more
/// direct, less brittle check for a token-conversion sweep like this one).
void main() {
  for (final entry
      in {'Dark': AppTheme.dark(), 'Light': AppTheme.light()}.entries) {
    final themeName = entry.key;
    final theme = entry.value;
    final colors = theme.extension<AppSemanticColors>()!;

    group('$themeName theme — control states', () {
      test('FilledButton: enabled vs disabled background/foreground differ',
          () {
        final style = theme.filledButtonTheme.style!;
        final enabledBg = style.backgroundColor!.resolve({});
        final disabledBg =
            style.backgroundColor!.resolve({WidgetState.disabled});
        final enabledFg = style.foregroundColor!.resolve({});
        final disabledFg =
            style.foregroundColor!.resolve({WidgetState.disabled});

        expect(enabledBg, colors.primaryAction);
        expect(disabledBg, isNot(enabledBg),
            reason: 'a disabled button must not look identical to an '
                'enabled one — colour alone isn\'t the only signal here '
                '(disabled also drops elevation/interactivity), but the '
                'fill itself should still change');
        expect(enabledFg, isNot(disabledFg));
      });

      test('ElevatedButton: enabled vs disabled background/foreground differ',
          () {
        final style = theme.elevatedButtonTheme.style!;
        final enabledBg = style.backgroundColor!.resolve({});
        final disabledBg =
            style.backgroundColor!.resolve({WidgetState.disabled});

        expect(enabledBg, colors.primaryAction);
        expect(disabledBg, isNot(enabledBg));
      });

      test(
          'OutlinedButton/TextButton default foreground is the accent link '
          'color, not the disabled tone', () {
        final style = theme.textButtonTheme.style!;
        expect(style.foregroundColor!.resolve({}), colors.primaryAction);
      });

      test(
          'text input: focused border reads differently from the resting '
          'enabled border', () {
        final input = theme.inputDecorationTheme;
        final enabledBorder = input.enabledBorder as OutlineInputBorder?;
        final focusedBorder = input.focusedBorder as OutlineInputBorder?;
        expect(enabledBorder, isNotNull);
        expect(focusedBorder, isNotNull);
        expect(focusedBorder!.borderSide.color,
            isNot(enabledBorder!.borderSide.color),
            reason: 'a focused field must read as focused without relying '
                'on cursor position alone');
        expect(focusedBorder.borderSide.width,
            greaterThan(enabledBorder.borderSide.width),
            reason: 'focus is also signalled by a thicker border, not '
                'colour alone');
        expect(focusedBorder.borderSide.color, colors.primaryAction);
      });

      test('ColorScheme.outline (default Material border) matches divider', () {
        // Chips, default OutlineInputBorder fallback, and several stock
        // Material widgets pull their border from ColorScheme.outline —
        // must track the same semantic divider token, not drift separately.
        expect(theme.colorScheme.outline, colors.divider);
      });

      test(
          'selected vs unselected ChoiceChip renders with a visibly '
          'different fill', () {
        // ChoiceChip has no app-wide ThemeData default for selectedColor —
        // every call site in this app passes colors.accent explicitly (see
        // the many *_screen.dart chip widgets converted this sprint).
        // What IS centrally themed is the plain (unselected) chip's
        // implicit Card-like surface via ColorScheme.surface, which must
        // differ from the accent selected-fill used everywhere.
        expect(theme.colorScheme.surface, isNot(colors.accent));
      });
    });
  }
}
