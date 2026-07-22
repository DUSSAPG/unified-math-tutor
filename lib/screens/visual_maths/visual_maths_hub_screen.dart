import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../models/visual_maths_tool.dart';
import '../../shared/theme/app_spacing.dart';

/// Lists the 4 Visual Maths tools. Number Line is the RC1 polished
/// interactive; the other 3 are bounded static-example placeholders — the
/// hub reads only [VisualMathsToolMeta.hasInteractiveImplementation] to pick
/// the Interactive/Preview badge, so that distinction lives in one place.
class VisualMathsHubScreen extends StatelessWidget {
  const VisualMathsHubScreen({super.key});

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
          onPressed: () => popOrGo(context, '/math-studio'),
        ),
        title: Text(
          l10n.mathStudioVisualMathsTitle,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                for (final meta in VisualMathsToolMeta.registry.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _ToolCard(meta: meta),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final VisualMathsToolMeta meta;
  const _ToolCard({required this.meta});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (title, subtitle) = switch (meta.id) {
      VisualMathsToolId.numberLine => (
          l10n.visualMathsNumberLineTitle,
          l10n.visualMathsNumberLineSubtitle,
        ),
      VisualMathsToolId.fractionBars => (
          l10n.visualMathsFractionBarsTitle,
          l10n.visualMathsFractionBarsSubtitle,
        ),
      VisualMathsToolId.abacus => (l10n.visualMathsAbacusTitle, l10n.visualMathsAbacusSubtitle),
      VisualMathsToolId.placeValueExplorer => (
          l10n.visualMathsPlaceValueTitle,
          l10n.visualMathsPlaceValueSubtitle,
        ),
    };
    final badge = meta.hasInteractiveImplementation
        ? l10n.visualMathsInteractiveBadge
        : l10n.visualMathsPreviewBadge;
    final badgeColor =
        meta.hasInteractiveImplementation ? const Color(0xFF34C759) : const Color(0xFFFF9500);

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: Icon(meta.icon, color: const Color(0xFF7C5FFF), size: 28),
        title: Row(
          children: [
            Expanded(
              child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(20)),
              child: Text(
                badge,
                style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/math-studio/visual-maths/${meta.routeSuffix}'),
      ),
    );
  }
}
