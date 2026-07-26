import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../shared/responsive/app_breakpoints.dart';
import '../../shared/theme/app_spacing.dart';

/// Shared shell for the 3 bounded Visual Maths placeholders (Fraction Bars,
/// Abacus, Place Value Explorer): a static example visual, a real caption,
/// a working "Try another example" control, and a visible (never hidden)
/// "coming in a future release" badge — never a dead/broken button.
class VisualMathsPlaceholderScaffold extends StatelessWidget {
  const VisualMathsPlaceholderScaffold({
    super.key,
    required this.title,
    required this.onBack,
    required this.caption,
    required this.onTryAnother,
    required this.child,
  });

  final String title;
  final VoidCallback onBack;
  final String caption;
  final VoidCallback onTryAnother;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1120),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: onBack,
        ),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: AppResponsive.contentMaxWidth(context)),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9500),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.visualMathsPreviewBadge,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.visualMathsComingSoonNote,
                    style: const TextStyle(
                      color: Color(0xFF5F7099),
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  child,
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    caption,
                    style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  OutlinedButton(
                    onPressed: onTryAnother,
                    child: Text(l10n.visualMathsTryAnotherExample),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
