import 'package:flutter/material.dart';

import '../../app/safe_navigation.dart';
import '../../l10n/app_localizations.dart';
import '../../services/family_activity_catalog_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/allie_card.dart';

/// Sources every question straight from existing
/// [FamilyActivity.questionsToAsk] entries rather than authoring new
/// content — "questions to ask" is already a required field on every
/// Family Maths activity.
class ConversationStartersScreen extends StatelessWidget {
  const ConversationStartersScreen({super.key});

  Future<List<String>> _questions(Locale locale) async {
    final activities = await FamilyActivityCatalogService.instance.all();
    final questions = <String>{};
    for (final activity in activities) {
      questions.addAll(activity.textFor(locale).questionsToAsk);
      if (questions.length >= 12) break;
    }
    return questions.take(12).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
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
        title: Text(l10n.familyStudioSectionConversationStartersTitle,
            style: TextStyle(
                color: colors.primaryText, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: FutureBuilder<List<String>>(
          future: _questions(locale),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AllieCard(message: l10n.familyStudioConversationAllieMessage),
                const SizedBox(height: 16),
                for (final question in snapshot.data!)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: colors.cardSurface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: colors.divider),
                      ),
                      child: Text(question,
                          style: TextStyle(
                              color: colors.primaryText, height: 1.4)),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
