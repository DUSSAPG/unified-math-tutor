import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../models/interactive_lab_id.dart';
import '../../services/curriculum_service.dart';
import '../../services/pack_registry_service.dart';
import '../../services/topic_capability_resolver.dart';
import '../../services/topic_catalog_service.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/shared/section_label.dart';

/// Gate for the Year 8 Ratio & Proportion "Ratio scaling foundations"
/// vertical slice's Hub card — true only for the exact topic/stage this
/// narrow slice was built for. Deliberately a plain function (not woven
/// into [TopicCapabilityResolver], which stays topic-agnostic) so this
/// one-off slice can never accidentally affect any other topic's
/// availability. See router.dart's nested 'ratio-foundations' route and
/// RatioFoundationsScreen's own doc comment.
bool showRatioFoundationsCard(
        {required String topicId, required String stage}) =>
    topicId == 'ratio_proportion' && stage == 'KS3';

/// Same title strings interactive_labs_hub_screen.dart's own catalog list
/// uses (footballPrecision/mazeDriver are hardcoded English there too — an
/// existing gap this pass doesn't touch, matched here rather than
/// "fixed" in one place and not the other).
String _labTitle(AppLocalizations l10n, InteractiveLabId labId) =>
    switch (labId) {
      InteractiveLabId.fractionBuilder => l10n.labsFractionBuilderTitle,
      InteractiveLabId.algebraBalance => l10n.labsAlgebraBalanceTitle,
      InteractiveLabId.numberLineExplorer => l10n.labsNumberLineExplorerTitle,
      InteractiveLabId.flightPathLab => l10n.labsFlightPathLabTitle,
      InteractiveLabId.footballPrecision => 'Football Precision',
      InteractiveLabId.mazeDriver => 'Maze Driver',
      InteractiveLabId.dataDetective => l10n.labsDataDetectiveTitle,
      InteractiveLabId.spatialCubeLab => l10n.labsSpatialCubeLabTitle,
      InteractiveLabId.aircraftLandingLab => l10n.labsAircraftLandingLabTitle,
      InteractiveLabId.earlyMathsPlayground =>
        l10n.labsEarlyMathsPlaygroundTitle,
    };

String _supportingActivityTitle(
  AppLocalizations l10n,
  SupportingActivityId id,
) =>
    switch (id) {
      SupportingActivityId.interactiveAbacus => l10n.topicHubSupportAbacusTitle,
      SupportingActivityId.cubeNets => l10n.topicHubSupportCubeNetsTitle,
      SupportingActivityId.shapePropertiesPuzzles =>
        l10n.topicHubSupportShapePropertiesTitle,
      SupportingActivityId.transformations =>
        l10n.topicHubSupportTransformationsTitle,
      SupportingActivityId.rotations => l10n.topicHubSupportRotationsTitle,
    };

IconData _supportingActivityIcon(SupportingActivityId id) => switch (id) {
      SupportingActivityId.interactiveAbacus => Icons.grid_on_outlined,
      SupportingActivityId.cubeNets => Icons.view_in_ar_outlined,
      SupportingActivityId.shapePropertiesPuzzles => Icons.category_outlined,
      SupportingActivityId.transformations => Icons.transform,
      SupportingActivityId.rotations => Icons.rotate_right,
    };

/// D3 — "what can a learner genuinely do with this topic?" Replaces the
/// old direct Topics -> Practice jump: tapping a topic now lands here
/// first, showing only activities [TopicCapabilityResolver] has actually
/// verified exist for the topic at the selected stage. This screen owns no
/// availability logic of its own — every card it renders, and every card
/// it declines to render, traces back to one [TopicActivityCapability] row.
class TopicLearningHubScreen extends StatefulWidget {
  const TopicLearningHubScreen({super.key, required this.topicId});

  final String topicId;

  @override
  State<TopicLearningHubScreen> createState() => _TopicLearningHubScreenState();
}

class _TopicLearningHubScreenState extends State<TopicLearningHubScreen> {
  late String _stage = CurriculumService.instance.stage;
  late Future<List<TopicActivityCapability>> _capabilitiesFuture =
      TopicCapabilityResolver.resolve(topicId: widget.topicId, stage: _stage);

  void _selectStage(String stage) {
    if (stage == _stage) return;
    setState(() {
      _stage = stage;
      _capabilitiesFuture = TopicCapabilityResolver.resolve(
        topicId: widget.topicId,
        stage: _stage,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final locale = Localizations.localeOf(context);
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom + 24;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          key: const ValueKey('topicHubBackButton'),
          // Explicit accessible label (not a tooltip, which would be
          // announced as a separate hint): screen readers announce
          // "Back to Topics, button".
          icon: Icon(
            Icons.arrow_back,
            color: colors.primaryText,
            semanticLabel: l10n.topicHubBackToTopics,
          ),
          onPressed: () => popOrGo(context, '/topics'),
        ),
        title: FutureBuilder<TopicDisplay>(
          future: TopicCatalogService.instance.byId(widget.topicId, locale),
          builder: (context, snapshot) {
            final title = snapshot.data?.title ?? widget.topicId;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colors.primaryText,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  l10n.topicHubSubtitle,
                  style: TextStyle(color: colors.secondaryText, fontSize: 12),
                ),
              ],
            );
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              key: const PageStorageKey<String>('topicLearningHub'),
              padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.topicHubStageLabel,
                    style: TextStyle(
                      color: colors.secondaryText,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _StagePicker(
                    stages: PackRegistryService.practiceStages,
                    selected: _stage,
                    onSelected: _selectStage,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FutureBuilder<List<TopicActivityCapability>>(
                    key: ValueKey('${widget.topicId}-$_stage'),
                    future: _capabilitiesFuture,
                    builder: (context, snapshot) {
                      final capabilities = snapshot.data;
                      if (capabilities == null) {
                        if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: Text(
                                l10n.topicHubLoadError,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: colors.secondaryText),
                              ),
                            ),
                          );
                        }
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 48),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return _CapabilitySections(
                        topicId: widget.topicId,
                        stage: _stage,
                        capabilities: capabilities,
                      );
                    },
                  ),
                  if (showRatioFoundationsCard(
                    topicId: widget.topicId,
                    stage: _stage,
                  )) ...[
                    const SizedBox(height: AppSpacing.md),
                    const _RatioFoundationsCard(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Stage picker ───────────────────────────────────────────────────────────

class _StagePicker extends StatelessWidget {
  const _StagePicker({
    required this.stages,
    required this.selected,
    required this.onSelected,
  });

  final List<String> stages;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    // Each chip keeps its compact pill look, but the tappable area around it
    // is a transparent box of at least kMinInteractiveDimension (48×48 dp),
    // so the vertical gap between wrapped rows now comes from that hit
    // area rather than runSpacing.
    return Wrap(
      spacing: 8,
      runSpacing: 0,
      children: stages.map((stage) {
        final sel = stage == selected;
        return Semantics(
          button: true,
          selected: sel,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              key: ValueKey('topicHubStage-$stage'),
              borderRadius: BorderRadius.circular(24),
              onTap: () => onSelected(stage),
              child: ConstrainedBox(
                key: ValueKey('topicHubStageHitArea-$stage'),
                constraints: const BoxConstraints(
                  minWidth: kMinInteractiveDimension,
                  minHeight: kMinInteractiveDimension,
                ),
                child: Center(
                  widthFactor: 1,
                  child: _stagePill(colors, stage, sel),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _stagePill(AppSemanticColors colors, String stage, bool sel) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: sel
              ? colors.primaryAction.withValues(alpha: 0.14)
              : colors.cardSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: sel ? colors.accent : colors.divider,
            width: sel ? 2 : 1,
          ),
        ),
        child: Text(
          stage,
          style: TextStyle(
            color: sel ? colors.accent : colors.secondaryText,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
}

// ─── Capability sections ─────────────────────────────────────────────────────

/// Renders only what [TopicCapabilityResolver] confirmed is genuinely
/// available — an unavailable row (including the always-unavailable
/// workbook row) contributes nothing to the tree, never a disabled card,
/// never a "coming soon" placeholder. An empty section is an absent
/// section: its [SectionLabel] only appears when it has at least one card.
class _CapabilitySections extends StatelessWidget {
  const _CapabilitySections({
    required this.topicId,
    required this.stage,
    required this.capabilities,
  });

  final String topicId;
  final String stage;
  final List<TopicActivityCapability> capabilities;

  Widget _cards(Iterable<TopicActivityCapability> rows) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final c in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ActivityCard(capability: c),
            ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final available = capabilities.where((c) => c.available).toList();
    final mcqAvailable = available.any((c) =>
        c.activityType == TopicActivityType.topicDrill ||
        c.activityType == TopicActivityType.quickStart);
    final status = TopicCapabilityResolver.stageStatus(
      topicId: topicId,
      stage: stage,
      mcqAvailable: mcqAvailable,
    );

    final bySections = <TopicActivitySection, List<TopicActivityCapability>>{
      for (final section in TopicActivitySection.values)
        section: [
          for (final c in available)
            if (c.section == section) c,
        ],
    };

    if (status != TopicStageStatus.mcqAvailable) {
      // Coverage Truth Repair V1: no topic-specific MCQs at this stage. The
      // stage status always comes first and is never hidden by supporting
      // learning; supporting learning (if this cell has stage evidence for
      // any) follows in its own clearly-labelled section. A verified
      // no-planned-activity (product scope) cell never shows supporting learning.
      final supporting = status == TopicStageStatus.contentGap
          ? [
              ...bySections[TopicActivitySection.learn]!,
              ...bySections[TopicActivitySection.explore]!,
            ]
          : const <TopicActivityCapability>[];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StageStatusPanel(status: status, stage: stage),
          if (supporting.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            SectionLabel(text: l10n.topicHubSectionSupporting),
            const SizedBox(height: 6),
            Text(
              l10n.topicHubSupportingDisclaimer,
              key: const ValueKey('topicHubSupportingDisclaimer'),
              style: TextStyle(color: colors.secondaryText, fontSize: 12),
            ),
            const SizedBox(height: 10),
            _cards(supporting),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (bySections[TopicActivitySection.practise]!.isNotEmpty) ...[
          SectionLabel(text: l10n.topicHubSectionPractise),
          const SizedBox(height: 10),
          _cards(bySections[TopicActivitySection.practise]!),
          const SizedBox(height: AppSpacing.md),
        ],
        if (bySections[TopicActivitySection.learn]!.isNotEmpty) ...[
          SectionLabel(text: l10n.topicHubSectionLearn),
          const SizedBox(height: 10),
          _cards(bySections[TopicActivitySection.learn]!),
          const SizedBox(height: AppSpacing.md),
        ],
        if (bySections[TopicActivitySection.explore]!.isNotEmpty) ...[
          SectionLabel(text: l10n.topicHubSectionExplore),
          const SizedBox(height: 10),
          _cards(bySections[TopicActivitySection.explore]!),
        ],
        // Workbook: intentionally never rendered — see
        // TopicCapabilityResolver's workbook row (always unavailable) and
        // the sprint report's explicit "no clickable Workbook card"
        // requirement.
      ],
    );
  }
}

/// The stage-status message for a stage without topic-specific MCQs:
/// either a genuine content gap or a cell outside current product scope.
/// Announced to assistive technology as one header + body, never promising
/// future content.
class _StageStatusPanel extends StatelessWidget {
  const _StageStatusPanel({required this.status, required this.stage});

  final TopicStageStatus status;
  final String stage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final noPlanned = status == TopicStageStatus.noPlannedActivity;
    final title = noPlanned
        ? l10n.topicHubStatusNoPlannedTitle
        : l10n.topicHubStatusNoQuestionsTitle;
    final body = noPlanned
        ? l10n.topicHubStatusNoPlannedBody(stage)
        : l10n.topicHubStatusNoQuestionsBody;
    return Semantics(
      key: ValueKey('topicHubStageStatus-${status.name}'),
      container: true,
      header: true,
      label: '$title. $body',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.cardSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.divider),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline,
              color: colors.secondaryText,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: colors.primaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: TextStyle(color: colors.secondaryText, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.capability});

  final TopicActivityCapability capability;

  (IconData, String) _iconAndTitle(AppLocalizations l10n) {
    switch (capability.activityType) {
      case TopicActivityType.topicDrill:
        return (LucideIcons.calculator, l10n.practiceModeTopicDrill);
      case TopicActivityType.quickStart:
        return (LucideIcons.target, l10n.practiceModeQuickStart);
      case TopicActivityType.formulaLibrary:
        return (Icons.functions, l10n.homeFormulaLibraryTitle);
      case TopicActivityType.recallCards:
        return (Icons.style_outlined, l10n.recallCardsHubTitle);
      case TopicActivityType.interactiveLab:
        return (
          Icons.science_outlined,
          _labTitle(l10n, InteractiveLabId.fromId(capability.supportingId!)),
        );
      case TopicActivityType.supportingActivity:
        final id = SupportingActivityId.values.byName(capability.supportingId!);
        return (
          _supportingActivityIcon(id),
          _supportingActivityTitle(l10n, id)
        );
      case TopicActivityType.workbook:
        return (Icons.menu_book_outlined, '');
    }
  }

  /// Learner-facing description: a supporting row's exact scope when it
  /// has one, otherwise the resolver's truthful reason (unchanged copy for
  /// rows that existed before Coverage Truth Repair V1).
  String _description(AppLocalizations l10n) {
    final scope = capability.scope;
    if (scope == null) return capability.reason;
    return switch (scope) {
      SupportingScope.numberLineExplorer =>
        l10n.topicHubScopeNumberLineExplorer,
      SupportingScope.interactiveAbacus => l10n.topicHubScopeAbacus,
      SupportingScope.cubeNets => l10n.topicHubScopeCubeNets,
      SupportingScope.shapePropertiesPuzzles =>
        l10n.topicHubScopeShapeProperties,
      SupportingScope.transformations => l10n.topicHubScopeTransformations,
      SupportingScope.rotations => l10n.topicHubScopeRotations,
      SupportingScope.dataDetective => l10n.topicHubScopeDataDetective,
      SupportingScope.aircraftLanding => l10n.topicHubScopeAircraftLanding,
    };
  }

  void _navigate(BuildContext context) {
    switch (capability.activityType) {
      case TopicActivityType.topicDrill:
      case TopicActivityType.quickStart:
        // This Hub screen is a normal Topics-branch screen (nested under
        // /topics inside the shell, no parentNavigatorKey override — see
        // router.dart) so go() to another shell-branch root like
        // '/practice' is safe here exactly as it is from every other
        // in-shell caller (home_shell.dart, entrance_exam_hub_screen.dart's
        // popOrGo, ...); see the navigator-key ownership model comment atop
        // router.dart for why push() would still be the wrong call from a
        // root-navigator-hosted screen.
        //
        // 'hubNavNonce' forces a brand-new PracticeScreen State on every
        // single tap, including two taps of the identical card in a row —
        // without it, an unkeyed PracticeScreen at the same widget-tree
        // position skips initState() on the second navigation (Flutter
        // reuses the State and calls didUpdateWidget instead — the same
        // mechanism PracticeScreen.resumeFrom's doc comment already warns
        // about) and silently shows whatever _screenState (setup, an
        // abandoned session, ...) the PREVIOUS visit left behind instead of
        // a clean setup screen. See router.dart's '/practice' builder for
        // where this folds into the widget's key.
        context.go(capability.route, extra: {
          ...capability.routeExtra,
          'hubNavNonce': DateTime.now().microsecondsSinceEpoch,
        });
      case TopicActivityType.formulaLibrary:
        // Exact per-stage formula ids (Coverage Truth Repair V1) — never
        // a whole category that would include other stages' formulas.
        final formulaIds =
            (capability.routeExtra['formulaIds'] as List).cast<String>();
        context.go(capability.route, extra: {'formulaIds': formulaIds});
      case TopicActivityType.recallCards:
        // '/math-studio/recall-cards/browse' is a plain top-level route
        // outside the shell entirely (not a branch root) — push() here
        // is the same safe, already-proven pattern LabRelatedLinks and
        // mental_maths_hub_screen.dart use for the same destination.
        context.push(capability.route, extra: capability.routeExtra);
      case TopicActivityType.interactiveLab:
      case TopicActivityType.supportingActivity:
        // Both live under the top-level /math-studio route, outside the
        // StatefulShellRoute — push() is the established safe pattern.
        context.push(capability.route);
      case TopicActivityType.workbook:
        break; // Never reachable — no card is ever built for this type.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final (icon, title) = _iconAndTitle(l10n);
    final description = _description(l10n);
    return Semantics(
      button: true,
      label: title,
      hint: description,
      excludeSemantics: true,
      onTap: () => _navigate(context),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: ValueKey(
            'topicHubActivity-${capability.activityType.name}-${capability.supportingId ?? ''}',
          ),
          borderRadius: BorderRadius.circular(14),
          onTap: () => _navigate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: colors.cardSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.divider),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.accent.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: colors.accent, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: colors.primaryText,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: TextStyle(
                            color: colors.secondaryText, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: colors.tertiaryText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The Year 8 Ratio & Proportion "Ratio scaling foundations" vertical
/// slice's Hub card. Deliberately separate from [_ActivityCard] and
/// [TopicCapabilityResolver] — this is a single, fixed, non-topic-
/// parameterised destination (see [showRatioFoundationsCard]), not a row
/// derived from the generic capability matrix. Its own title/subtitle
/// state plainly what it contains — never "full Year 8 Ratio" — and never
/// a question-pool total.
class _RatioFoundationsCard extends StatelessWidget {
  const _RatioFoundationsCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Semantics(
      button: true,
      label: l10n.ratioFoundationsHubCardTitle,
      hint: l10n.ratioFoundationsHubCardReason,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: const ValueKey('topicHubRatioFoundationsCard'),
          borderRadius: BorderRadius.circular(14),
          onTap: () => context.push('/topics/hub/ratio-foundations'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: colors.cardSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.divider),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.accent.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      Icon(Icons.trending_up, color: colors.accent, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.ratioFoundationsHubCardTitle,
                        style: TextStyle(
                          color: colors.primaryText,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.ratioFoundationsHubCardReason,
                        style: TextStyle(
                            color: colors.secondaryText, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: colors.tertiaryText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
