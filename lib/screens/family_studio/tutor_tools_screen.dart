import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/safe_navigation.dart';
import '../../l10n/app_localizations.dart';
import '../../models/interactive_lab_id.dart';
import '../../services/interactive_labs_progress_service.dart';
import '../../services/learner_profiles_service.dart';
import '../../services/tutor_notes_service.dart';
import '../../shared/theme/app_theme.dart';

/// Lightweight, single-tutor tooling only — choose a learner, assign a
/// topic (deep-links into existing Practice/Recall Cards, no new assignment
/// -tracking system), see existing completion counts, and a short note.
/// Explicitly not classroom management: no rosters, no multi-teacher
/// accounts, no grading.
class TutorToolsScreen extends StatefulWidget {
  const TutorToolsScreen({super.key});

  @override
  State<TutorToolsScreen> createState() => _TutorToolsScreenState();
}

class _TutorToolsScreenState extends State<TutorToolsScreen> {
  final _noteController = TextEditingController();
  String? _selectedLearnerId;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _selectLearner(String id) {
    setState(() {
      _selectedLearnerId = id;
      _noteController.text = TutorNotesService.instance.noteFor(id);
    });
    LearnerProfilesService.instance.setActiveLearner(id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final completedCount = InteractiveLabId.values
        .map((lab) => InteractiveLabsProgressService.instance.completedFor(lab))
        .fold<int>(0, (sum, count) => sum + count);

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
        title: Text(l10n.familyStudioSectionTutorToolsTitle,
            style: TextStyle(
                color: colors.primaryText, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<List<LearnerProfile>>(
          valueListenable: LearnerProfilesService.instance.profiles,
          builder: (context, learners, _) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(l10n.familyStudioTutorChooseLearnerLabel,
                    style: TextStyle(
                        color: colors.primaryText,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final learner in learners)
                      ChoiceChip(
                        label: Text(learner.name),
                        selected: _selectedLearnerId == learner.id,
                        onSelected: (_) => _selectLearner(learner.id),
                      ),
                  ],
                ),
                if (_selectedLearnerId != null) ...[
                  const SizedBox(height: 20),
                  Text(l10n.familyStudioTutorAssignLabel,
                      style: TextStyle(
                          color: colors.primaryText,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton(
                        onPressed: () => context.push('/topics'),
                        child: Text(l10n.familyStudioTutorAssignPractice),
                      ),
                      OutlinedButton(
                        onPressed: () =>
                            context.push('/math-studio/recall-cards/browse'),
                        child: Text(l10n.familyStudioTutorAssignRecallCards),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(l10n.familyStudioTutorCompletionLabel(completedCount),
                      style: TextStyle(color: colors.secondaryText)),
                  const SizedBox(height: 20),
                  Text(l10n.familyStudioTutorNotesLabel,
                      style: TextStyle(
                          color: colors.primaryText,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteController,
                    maxLines: 4,
                    onChanged: (value) => TutorNotesService.instance
                        .setNote(_selectedLearnerId!, value),
                    decoration: InputDecoration(
                      hintText: l10n.familyStudioTutorNotesHint,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
