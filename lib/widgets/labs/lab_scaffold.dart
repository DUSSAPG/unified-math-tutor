import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../models/interactive_lab_id.dart';
import '../../services/interactive_labs_progress_service.dart';
import '../../shared/theme/app_spacing.dart';
import 'lab_first_use_overlay.dart';
import 'lab_help_sheet.dart';
import 'lab_mission_panel.dart';
import 'lab_related_links.dart';

/// Shared shell for every Interactive Lab, implementing the common guided
/// flow (Mission → Try → Predict → Test → Notice → Explain → Try another):
/// a Mission panel, the lab's own interactive body ("Try"/"Predict"), an
/// optional immediate-feedback area ("Notice"/"Explain" — typically a
/// [LabResultBanner]), a Reset button (unlimited retries — "Try another"),
/// "Where you'll use this", the Connect-stage [LabRelatedLinks], a Help
/// button, and a one-time first-use walkthrough. Mirrors the visual
/// language and back-navigation convention already used across every Math
/// Studio screen, so a lab reads as part of the same product rather than a
/// bolted-on feature.
class LabScaffold extends StatefulWidget {
  const LabScaffold({
    super.key,
    required this.labId,
    required this.title,
    required this.missionText,
    required this.whereYoullUseThis,
    required this.body,
    required this.onReset,
    required this.relatedLinks,
    required this.helpContent,
    required this.firstUseSteps,
    this.feedback,
    this.progressIndicator,
    this.conceptText,
  });

  final InteractiveLabId labId;
  final String title;

  /// The "Mission" stage: a short, actionable statement of what to do.
  final String missionText;

  /// Optional supporting explanation shown beneath the mission, kept
  /// separate so the mission itself stays a single actionable sentence.
  final String? conceptText;

  final String whereYoullUseThis;
  final Widget body;
  final VoidCallback onReset;
  final Widget relatedLinks;
  final Widget? feedback;
  final Widget? progressIndicator;
  final LabHelpContent helpContent;

  /// Level-resolved first-use walkthrough steps, shown once per profile the
  /// first time this lab is opened.
  final List<String> firstUseSteps;

  @override
  State<LabScaffold> createState() => _LabScaffoldState();
}

class _LabScaffoldState extends State<LabScaffold> {
  final _resultFocusNode = FocusNode(debugLabel: 'lab-result-focus');
  bool _hadFeedback = false;

  @override
  void initState() {
    super.initState();
    _hadFeedback = widget.feedback != null;
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowFirstUse());
  }

  Future<void> _maybeShowFirstUse() async {
    if (!mounted) return;
    if (InteractiveLabsProgressService.instance.hasSeenFirstUse(widget.labId)) return;
    await showLabFirstUseWalkthrough(context, widget.firstUseSteps);
    await InteractiveLabsProgressService.instance.markFirstUseSeen(widget.labId);
  }

  @override
  void didUpdateWidget(covariant LabScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    final hasFeedbackNow = widget.feedback != null;
    // Focus moves to the result the moment it first appears after a
    // Test/Check/Reveal action, so screen-reader users land on it without
    // having to hunt for it — but not on every rebuild while it's showing.
    if (hasFeedbackNow && !_hadFeedback) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _resultFocusNode.requestFocus();
      });
    }
    _hadFeedback = hasFeedbackNow;
  }

  @override
  void dispose() {
    _resultFocusNode.dispose();
    super.dispose();
  }

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
          onPressed: () => popOrGo(context, '/math-studio/interactive-labs'),
        ),
        title: Text(widget.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        actions: [
          Semantics(
            button: true,
            label: l10n.labsHelpButton,
            child: IconButton(
              icon: const Icon(Icons.help_outline, color: Colors.white),
              tooltip: l10n.labsHelpButton,
              onPressed: () => showLabHelpSheet(context, widget.helpContent),
            ),
          ),
          Semantics(
            button: true,
            label: l10n.labsResetButton,
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              tooltip: l10n.labsResetButton,
              onPressed: widget.onReset,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.progressIndicator != null) ...[
                    widget.progressIndicator!,
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  LabMissionPanel(text: widget.missionText),
                  if (widget.conceptText != null && widget.conceptText!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      widget.conceptText!,
                      style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 13, height: 1.4),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  widget.body,
                  if (widget.feedback != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Focus(
                      focusNode: _resultFocusNode,
                      skipTraversal: true,
                      child: widget.feedback!,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  _SectionHeading(text: l10n.mathStudioWhereYoullUseThisLabel),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    widget.whereYoullUseThis,
                    style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  widget.relatedLinks,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String text;
  const _SectionHeading({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF5B8EFF),
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
      ),
    );
  }
}
