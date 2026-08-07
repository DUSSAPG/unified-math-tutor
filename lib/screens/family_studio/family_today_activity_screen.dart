import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/safe_navigation.dart';
import '../../l10n/app_localizations.dart';
import '../../models/family_activity.dart';
import '../../services/family_activity_catalog_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/allie_card.dart';

/// "Today's Family Activity" — the deterministic, date-seeded pick from the
/// existing Family Maths catalog ([FamilyActivityCatalogService.activityOfTheDay]).
/// Starting it opens the existing, already-gated activity detail screen —
/// no new activity content is authored here.
class FamilyTodayActivityScreen extends StatelessWidget {
  const FamilyTodayActivityScreen({super.key});

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
          onPressed: () => popOrGo(context, '/family-studio'),
        ),
        title: Text(l10n.familyStudioSectionTodaysActivityTitle,
            style: TextStyle(
                color: colors.primaryText, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: FutureBuilder<FamilyActivity>(
          future: FamilyActivityCatalogService.instance
              .activityOfTheDay(DateTime.now()),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final activity = snapshot.data!;
            final text = activity.textFor(Localizations.localeOf(context));
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text.title,
                      style: TextStyle(
                          color: colors.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Text(text.whatYourChildLearns,
                      style:
                          TextStyle(color: colors.secondaryText, height: 1.4)),
                  const SizedBox(height: 16),
                  AllieCard(message: text.alliePrompt),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => context.push(
                          '/help/parent-teacher-tools/family-maths/activity/${activity.id}'),
                      child: Text(l10n.familyStudioTodayStartButton),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
