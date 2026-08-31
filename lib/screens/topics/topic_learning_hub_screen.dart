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
          icon: Icon(Icons.arrow_back, color: colors.primaryText),
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
                                l10n.topicHubNoActivities(_stage),
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
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: stages.map((stage) {
        final sel = stage == selected;
        return Semantics(
          button: true,
          selected: sel,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              key: ValueKey('topicHubStage-$stage'),
              borderRadius: BorderRadius.circular(20),
              onTap: () => onSelected(stage),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final available = capabilities.where((c) => c.available).toList();

    if (available.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            l10n.topicHubNoActivities(stage),
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.secondaryText),
          ),
        ),
      );
    }

    final bySections = <TopicActivitySection, List<TopicActivityCapability>>{
      for (final section in TopicActivitySection.values)
        section: [
          for (final c in available)
            if (c.section == section) c,
        ],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (bySections[TopicActivitySection.practise]!.isNotEmpty) ...[
          SectionLabel(text: l10n.topicHubSectionPractise),
          const SizedBox(height: 10),
          for (final c in bySections[TopicActivitySection.practise]!)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ActivityCard(capability: c),
            ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (bySections[TopicActivitySection.learn]!.isNotEmpty) ...[
          SectionLabel(text: l10n.topicHubSectionLearn),
          const SizedBox(height: 10),
          for (final c in bySections[TopicActivitySection.learn]!)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ActivityCard(capability: c),
            ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (bySections[TopicActivitySection.explore]!.isNotEmpty) ...[
          SectionLabel(text: l10n.topicHubSectionExplore),
          const SizedBox(height: 10),
          for (final c in bySections[TopicActivitySection.explore]!)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ActivityCard(capability: c),
            ),
        ],
        // Workbook: intentionally never rendered — see
        // TopicCapabilityResolver's workbook row (always unavailable,
        // "No workbook exists for this topic yet") and the sprint report's
        // explicit "no clickable Workbook card" requirement.
      ],
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
      case TopicActivityType.workbook:
        return (Icons.menu_book_outlined, '');
    }
  }

  void _navigate(BuildContext context) {
    switch (capability.activityType) {
      case TopicActivityType.topicDrill:
      case TopicActivityType.quickStart:
        context.push(capability.route, extra: capability.routeExtra);
      case TopicActivityType.formulaLibrary:
        final categories =
            (capability.routeExtra['categories'] as List).cast<String>();
        context.go(capability.route, extra: {'categories': categories});
      case TopicActivityType.recallCards:
        context.push(capability.route, extra: capability.routeExtra);
      case TopicActivityType.interactiveLab:
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
    return Material(
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
                      capability.reason,
                      style:
                          TextStyle(color: colors.secondaryText, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colors.tertiaryText),
            ],
          ),
        ),
      ),
    );
  }
}
