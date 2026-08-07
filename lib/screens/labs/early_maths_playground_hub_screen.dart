import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/shared/route_link_card.dart';

/// Early Maths Playground landing page — a calm, low-pressure area for
/// younger learners, reached the same way Spatial Cube Lab and Aircraft
/// Landing Lab are: as an Interactive Lab entry, not a new Math Studio
/// pillar (the pillar hub stays at its frozen six — see
/// docs/RC1_FEATURE_FREEZE.md §8's changelog entry for this addition).
/// Currently lists one governed activity; more calm counting/number-sense
/// activities are expected to join it over time.
class EarlyMathsPlaygroundHubScreen extends StatelessWidget {
  const EarlyMathsPlaygroundHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.primaryText),
          onPressed: () => popOrGo(context, '/math-studio/interactive-labs'),
        ),
        title: Text(
          l10n.labsEarlyMathsPlaygroundTitle,
          style:
              TextStyle(color: colors.primaryText, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: AppResponsive.contentMaxWidth(context)),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.earlyMathsPlaygroundIntro,
                    style: TextStyle(
                        color: colors.secondaryText, fontSize: 15, height: 1.4),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  RouteLinkCard(
                    key: const Key('feedTheHungryPandaEntryCard'),
                    icon: LucideIcons.apple,
                    iconColor: const Color(0xFF34C759),
                    title: l10n.feedTheHungryPandaTitle,
                    subtitle: l10n.feedTheHungryPandaSubtitle,
                    onTap: () => context.push(
                        '/math-studio/interactive-labs/early-maths-playground/feed-the-hungry-panda'),
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
