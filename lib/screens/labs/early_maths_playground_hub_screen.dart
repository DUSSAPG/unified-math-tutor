import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../models/early_maths_lane.dart';
import '../../models/family_activity.dart';
import '../../services/early_maths_lane_preference_service.dart';
import '../../services/family_activity_catalog_service.dart';
import '../../services/local_preferences_service.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../shared/theme/app_spacing.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/shared/route_link_card.dart';
import '../../widgets/shared/section_label.dart';

/// Early Maths entry point — a calm, low-pressure area for younger learners,
/// reached the same way Spatial Cube Lab and Aircraft Landing Lab are: as an
/// Interactive Lab entry, not a new Math Studio pillar (the pillar hub stays
/// at its frozen six — see docs/RC1_FEATURE_FREEZE.md §8's changelog entry
/// for this addition).
///
/// Offers two suggested starting points — Early Maths Play (typical ages 4-5
/// / Reception) and KS1 Maths Foundations (typical ages 5-7 / Years 1-2) —
/// plus "I'm not sure". A starting point is a suggestion about which
/// existing activities to show first; it is never an ability label, never a
/// test result, and switching it changes no progress. Only activities that
/// genuinely exist and are reachable are shown (see [EarlyMathsLaneContent]);
/// planned activities are omitted rather than shown as "coming soon".
class EarlyMathsPlaygroundHubScreen extends StatefulWidget {
  const EarlyMathsPlaygroundHubScreen({super.key});

  @override
  State<EarlyMathsPlaygroundHubScreen> createState() =>
      _EarlyMathsPlaygroundHubScreenState();
}

class _EarlyMathsPlaygroundHubScreenState
    extends State<EarlyMathsPlaygroundHubScreen> {
  EarlyMathsLane? _lane;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadLane();
  }

  Future<void> _loadLane() async {
    EarlyMathsLane? stored;
    try {
      stored = await EarlyMathsLanePreferenceService.instance.read();
    } on Exception catch (error, stackTrace) {
      debugPrint('Could not load Early Maths lane preference: $error');
      debugPrintStack(stackTrace: stackTrace);
      stored = null;
    }
    if (!mounted) return;
    setState(() {
      _lane = stored;
      _loaded = true;
    });
  }

  Future<void> _selectLane(EarlyMathsLane lane) async {
    setState(() => _lane = lane);
    try {
      await EarlyMathsLanePreferenceService.instance.write(lane);
    } on Exception catch (error, stackTrace) {
      debugPrint('Could not save Early Maths lane preference: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _openParentLed() {
    final prefs = LocalPreferencesService.instance;
    final unlocked =
        prefs.parentToolsEnabled.value && prefs.parentAccessGranted;
    // Family Maths sits behind the parent PIN. Send an already-unlocked
    // parent straight in, and everyone else to the PIN screen, which has a
    // Family Maths button — never to a bare "enter your PIN" dead end.
    context.push(unlocked
        ? '/help/parent-teacher-tools/family-maths'
        : '/help/parent-teacher-tools');
  }

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
                    l10n.earlyMathsEntryIntro,
                    style: TextStyle(
                        color: colors.secondaryText, fontSize: 15, height: 1.4),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SectionLabel(text: l10n.earlyMathsLaneChooserLabel),
                  const SizedBox(height: AppSpacing.sm),
                  _LaneChooser(selected: _lane, onSelected: _selectLane),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.earlyMathsLaneSwitchNote,
                    style: TextStyle(
                        color: colors.tertiaryText, fontSize: 12, height: 1.3),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (_loaded)
                    _LaneContent(lane: _lane, onParentLed: _openParentLed),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LaneChooser extends StatelessWidget {
  const _LaneChooser({required this.selected, required this.onSelected});

  final EarlyMathsLane? selected;
  final ValueChanged<EarlyMathsLane> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tiles = <(EarlyMathsLane, String, String)>[
      (
        EarlyMathsLane.earlyMathsPlay,
        l10n.earlyMathsLanePlayTitle,
        l10n.earlyMathsLanePlayAges,
      ),
      (
        EarlyMathsLane.ks1MathsFoundations,
        l10n.earlyMathsLaneKs1Title,
        l10n.earlyMathsLaneKs1Ages,
      ),
      (
        EarlyMathsLane.notSure,
        l10n.earlyMathsLaneNotSureTitle,
        l10n.earlyMathsLaneNotSureSubtitle,
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        // Side by side once there is room (tablet, or a phone in landscape),
        // stacked on a portrait phone. Wrap + fixed tile widths, no fixed
        // heights, so large text just makes tiles taller.
        const gap = AppSpacing.sm;
        final sideBySide = constraints.maxWidth >= 600;
        final tileWidth = sideBySide
            ? (constraints.maxWidth - 2 * gap) / 3
            : constraints.maxWidth;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final (lane, title, subtitle) in tiles)
              SizedBox(
                width: tileWidth,
                child: _LaneTile(
                  key: Key('earlyMathsLaneTile-${lane.storageValue}'),
                  title: title,
                  subtitle: subtitle,
                  selected: selected == lane,
                  onTap: () => onSelected(lane),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _LaneTile extends StatelessWidget {
  const _LaneTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      color:
          selected ? colors.accent.withValues(alpha: 0.12) : colors.cardSurface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Semantics(
          button: true,
          selected: selected,
          excludeSemantics: true,
          label: '$title. $subtitle',
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? colors.accent : colors.divider,
                width: selected ? 2 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  selected ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: selected ? colors.accent : colors.tertiaryText,
                  size: 22,
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
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: colors.secondaryText,
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The activities for the current starting point. Everything here comes from
/// [EarlyMathsLaneContent], so an item that is not in that list cannot appear.
class _LaneContent extends StatelessWidget {
  const _LaneContent({required this.lane, required this.onParentLed});

  final EarlyMathsLane? lane;
  final VoidCallback onParentLed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final undecided = lane == null || lane == EarlyMathsLane.notSure;
    final children = <Widget>[
      SectionLabel(
        text: undecided
            ? l10n.earlyMathsNotSureHeading
            : l10n.earlyMathsActivitiesHeading,
      ),
      const SizedBox(height: AppSpacing.sm),
      if (undecided) ...[
        Text(
          l10n.earlyMathsNotSureBody,
          style:
              TextStyle(color: colors.secondaryText, fontSize: 14, height: 1.4),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    ];

    for (final activity in EarlyMathsLaneContent.childActivities(lane)) {
      children
        ..add(_activityCard(context, l10n, activity))
        ..add(const SizedBox(height: 10));
    }

    if (EarlyMathsLaneContent.showsParentLedSection(lane)) {
      children.add(_ParentLedSection(lane: lane, onOpen: onParentLed));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _activityCard(
    BuildContext context,
    AppLocalizations l10n,
    EarlyMathsChildActivity activity,
  ) {
    switch (activity) {
      case EarlyMathsChildActivity.feedThePanda:
        return RouteLinkCard(
          key: const Key('feedTheHungryPandaEntryCard'),
          icon: LucideIcons.apple,
          iconColor: const Color(0xFF34C759),
          title: l10n.feedTheHungryPandaTitle,
          subtitle: l10n.earlyMathsPandaScope,
          onTap: () => context.push(
              '/math-studio/interactive-labs/early-maths-playground/feed-the-hungry-panda'),
        );
      case EarlyMathsChildActivity.abacus:
        return RouteLinkCard(
          key: const Key('abacusEntryCard'),
          icon: LucideIcons.gripVertical,
          iconColor: const Color(0xFF7C5FFF),
          title: l10n.earlyMathsAbacusTitle,
          subtitle: l10n.earlyMathsAbacusScope,
          onTap: () => context.push('/math-studio/visual-maths/abacus'),
        );
    }
  }
}

/// Parent-led Family Maths activities that fit this starting point, read from
/// the real catalogue. Not child cards: one link that goes through the parent
/// PIN. Hidden entirely if the catalogue cannot load or nothing fits.
class _ParentLedSection extends StatefulWidget {
  const _ParentLedSection({required this.lane, required this.onOpen});

  final EarlyMathsLane? lane;
  final VoidCallback onOpen;

  @override
  State<_ParentLedSection> createState() => _ParentLedSectionState();
}

class _ParentLedSectionState extends State<_ParentLedSection> {
  late final Future<List<FamilyActivity>> _future =
      FamilyActivityCatalogService.instance.all();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FamilyActivity>>(
      future: _future,
      builder: (context, snapshot) {
        final all = snapshot.data;
        if (all == null) return const SizedBox.shrink();
        final fitting = [
          for (final activity in all)
            if (EarlyMathsLaneContent.parentLedActivityFits(
                widget.lane, activity))
              activity,
        ];
        if (fitting.isEmpty) return const SizedBox.shrink();
        final l10n = AppLocalizations.of(context);
        final colors = context.appColors;
        final locale = Localizations.localeOf(context);
        final titles = fitting.map((a) => a.textFor(locale).title).join(', ');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            SectionLabel(text: l10n.earlyMathsParentHeading),
            const SizedBox(height: AppSpacing.sm),
            RouteLinkCard(
              key: const Key('earlyMathsParentLedCard'),
              icon: LucideIcons.users,
              iconColor: const Color(0xFFFF9F5B),
              title: l10n.earlyMathsParentCardTitle,
              subtitle: l10n.earlyMathsParentCardSubtitle,
              onTap: widget.onOpen,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.earlyMathsParentTitlesLine(titles),
              key: const Key('earlyMathsParentLedTitles'),
              style: TextStyle(
                  color: colors.secondaryText, fontSize: 13, height: 1.35),
            ),
          ],
        );
      },
    );
  }
}
