import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../services/local_preferences_service.dart';
import '../../services/parent_report_service.dart';
import '../../services/session_history_service.dart';
import '../../shared/math_notation_formatter.dart';
import '../../shared/theme/app_theme.dart';

class ParentCheatSheetScreen extends StatefulWidget {
  const ParentCheatSheetScreen({super.key});

  @override
  State<ParentCheatSheetScreen> createState() => _ParentCheatSheetScreenState();
}

class _ParentCheatSheetScreenState extends State<ParentCheatSheetScreen> {
  bool _printMode = false;
  static const _reports = ParentReportService();

  @override
  Widget build(BuildContext context) {
    final prefs = LocalPreferencesService.instance;
    final colors = context.appColors;
    if (!prefs.parentToolsEnabled.value || !prefs.parentAccessGranted) {
      return Scaffold(
        backgroundColor: colors.background,
        appBar: _appBar(context),
        body: Center(
          child: Text(AppLocalizations.of(context).parentToolsPinPrompt),
        ),
      );
    }
    return Scaffold(
      backgroundColor: colors.background,
      appBar: _appBar(context),
      body: FutureBuilder<List<PracticeSessionResult>>(
        future: SessionHistoryService.instance.load(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final sessions = snapshot.data!;
          if (sessions.isEmpty) {
            return const Center(
                child: Text('No completed practice sessions yet.'));
          }
          return ListView(
            padding: EdgeInsets.all(_printMode ? 28 : 16),
            children: [
              Wrap(
                spacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _reports.exportPdf(sessions),
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label: const Text('Export PDF'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => setState(() => _printMode = !_printMode),
                    icon: const Icon(Icons.print_outlined),
                    label: Text(_printMode ? 'Exit print mode' : 'Print mode'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _DrillSuggestions(sessions: sessions),
              const SizedBox(height: 12),
              ...sessions.map((session) => _SessionCard(session: session)),
            ],
          );
        },
      ),
    );
  }

  AppBar _appBar(BuildContext context) => AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => popOrGo(context, '/help/parent-teacher-tools'),
        ),
        title: const Text('Parent Cheat Sheet'),
      );
}

class _DrillSuggestions extends StatelessWidget {
  const _DrillSuggestions({required this.sessions});
  final List<PracticeSessionResult> sessions;

  @override
  Widget build(BuildContext context) {
    final suggestions = const ParentReportService().drillSuggestions(sessions);
    final colors = context.appColors;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Suggested topic drills',
                style: TextStyle(
                    color: colors.primaryText, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            if (suggestions.isEmpty)
              const Text('No weak topics detected yet.')
            else
              ...suggestions.entries.take(5).map(
                    (entry) => Text(
                        '${entry.key}: ${entry.value} answer(s) to review'),
                  ),
          ],
        ),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.session});
  final PracticeSessionResult session;

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<SessionQuestionResult>>{};
    for (final question in session.questions) {
      grouped
          .putIfAbsent(
            question.topic.isEmpty ? 'Mixed Review' : question.topic,
            () => [],
          )
          .add(question);
    }
    return Card(
      child: ExpansionTile(
        title: Text('${session.stage} session',
            style: TextStyle(color: context.appColors.primaryText)),
        subtitle:
            Text(session.completedAt.toLocal().toString().split('.').first),
        children: grouped.entries
            .map((entry) => ExpansionTile(
                  title: Text(entry.key),
                  subtitle: Text('${entry.value.length} questions'),
                  children: entry.value
                      .map((question) => _QuestionResultTile(result: question))
                      .toList(),
                ))
            .toList(),
      ),
    );
  }
}

class _QuestionResultTile extends StatefulWidget {
  const _QuestionResultTile({required this.result});
  final SessionQuestionResult result;

  @override
  State<_QuestionResultTile> createState() => _QuestionResultTileState();
}

class _QuestionResultTileState extends State<_QuestionResultTile> {
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    return ListTile(
      title: Text(MathNotationFormatter.format(result.question),
          style: TextStyle(color: context.appColors.primaryText)),
      subtitle: _revealed
          ? Text(
              'Correct: ${MathNotationFormatter.format(result.options[result.correctIndex])}\n'
              'Selected: ${MathNotationFormatter.format(result.options[result.selectedIndex])}\n'
              'Explanation: ${result.explanation.isEmpty ? 'Not provided' : MathNotationFormatter.format(result.explanation)}',
            )
          : const Text('Answer hidden'),
      trailing: TextButton(
        onPressed: () => setState(() => _revealed = !_revealed),
        child: Text(_revealed ? 'Hide' : 'Reveal'),
      ),
    );
  }
}
