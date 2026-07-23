import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../services/topic_catalog_service.dart';
import '../../shared/theme/app_spacing.dart';
import '../../widgets/shared/fade_in.dart';

// ─── Filter ───────────────────────────────────────────────────────────────────

enum _Filter { all, practice, recommended, oxfordTrack, gcse, more }

// ─── Topic model ─────────────────────────────────────────────────────────────

class _Topic {
  final String id;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final double progress;
  final bool inPractice;
  final bool inRecommended;
  final bool inOxfordTrack;
  final bool inGcse;
  final bool premium;
  final String? nextUp;
  final String? textIcon;

  const _Topic({
    required this.id,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    this.progress = 0.0,
    this.inPractice = false,
    this.inRecommended = false,
    this.inOxfordTrack = false,
    this.inGcse = false,
    this.premium = false,
    this.nextUp,
    this.textIcon,
  });

  bool matches(_Filter filter) => switch (filter) {
        _Filter.all || _Filter.more => true,
        _Filter.practice => inPractice,
        _Filter.recommended => inRecommended,
        _Filter.oxfordTrack => inOxfordTrack,
        _Filter.gcse => inGcse,
      };
}

// ─── Root ─────────────────────────────────────────────────────────────────────

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({super.key});

  @override
  Widget build(BuildContext context) => const _TopicsContent();
}

// ─── Content ──────────────────────────────────────────────────────────────────

class _TopicsContent extends StatefulWidget {
  const _TopicsContent();

  @override
  State<_TopicsContent> createState() => _TopicsContentState();
}

class _TopicsContentState extends State<_TopicsContent> {
  static const List<_Topic> _topics = [
    _Topic(
      id: 'number_place_value',
      icon: Icons.grid_3x3,
      iconColor: Color(0xFF5B8EFF),
      iconBg: Color(0xFF0D1F40),
      progress: 0.6,
      inPractice: true,
      inRecommended: true,
    ),
    _Topic(
      id: 'fractions',
      icon: Icons.pie_chart,
      iconColor: Color(0xFF00BCD4),
      iconBg: Color(0xFF003040),
      progress: 0.45,
      inPractice: true,
      inRecommended: true,
    ),
    _Topic(
      id: 'decimals',
      icon: Icons.format_list_numbered,
      iconColor: Color(0xFF34C759),
      iconBg: Color(0xFF0A2015),
      progress: 0.3,
      inPractice: true,
    ),
    _Topic(
      id: 'percentages',
      icon: Icons.percent,
      iconColor: Color(0xFFFF9500),
      iconBg: Color(0xFF2A1A00),
      progress: 0.2,
      inPractice: true,
    ),
    _Topic(
      id: 'ratio_proportion',
      icon: Icons.balance,
      iconColor: Color(0xFFFF6B35),
      iconBg: Color(0xFF2A1008),
      progress: 0.1,
      inPractice: true,
    ),
    _Topic(
      id: 'algebra',
      icon: Icons.functions,
      iconColor: Color(0xFF7B3FFF),
      iconBg: Color(0xFF130A30),
      progress: 0.5,
      inPractice: true,
      inRecommended: true,
      inOxfordTrack: true,
      inGcse: true,
      nextUp: 'Equations',
      textIcon: 'Σ',
    ),
    _Topic(
      id: 'geometry_measures',
      icon: Icons.explore,
      iconColor: Color(0xFFFF6B35),
      iconBg: Color(0xFF2A1008),
      progress: 0.05,
      inPractice: true,
      inGcse: true,
    ),
    _Topic(
      id: 'statistics_probability',
      icon: Icons.bar_chart,
      iconColor: Color(0xFF00BCD4),
      iconBg: Color(0xFF003040),
      inPractice: true,
      inOxfordTrack: true,
      inGcse: true,
    ),
    _Topic(
      id: 'calculus',
      icon: Icons.show_chart,
      iconColor: Color(0xFF34C759),
      iconBg: Color(0xFF0A2015),
      inOxfordTrack: true,
      inGcse: true,
      premium: true,
    ),
    _Topic(
      id: 'trigonometry',
      icon: Icons.change_history,
      iconColor: Color(0xFFFF9500),
      iconBg: Color(0xFF2A1A00),
      inOxfordTrack: true,
      inGcse: true,
      premium: true,
    ),
  ];

  _Filter _selectedFilter = _Filter.all;
  Future<Map<String, TopicDisplay>>? _displaysFuture;
  Locale? _displaysLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    if (_displaysLocale != locale) {
      _displaysLocale = locale;
      _displaysFuture = _loadDisplays(locale);
    }
  }

  Future<Map<String, TopicDisplay>> _loadDisplays(Locale locale) async {
    final resolved = await Future.wait(
      _topics.map((topic) => TopicCatalogService.instance.byId(topic.id, locale)),
    );
    return {for (final display in resolved) display.id: display};
  }

  // "More" itself is never a persisted selection any more (choosing a
  // secondary filter from its sheet sets the real filter directly), so only
  // Oxford Track needs to reveal the track panel.
  bool get _showTrackPanel => _selectedFilter == _Filter.oxfordTrack;

  List<_Topic> get _filteredTopics =>
      _topics.where((t) => t.matches(_selectedFilter)).toList();

  void _onPremiumTap(String name) {
    context.go('/upgrade');
  }

  void _onStandardTap() {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.topicsStandardSelected),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onTopicTap(_Topic topic, TopicDisplay display) {
    debugPrint('Topic tapped: ${topic.id}');
    context.push('/practice', extra: {
      'topicId': topic.id,
      'topic': display.title,
    }).then((_) {
      if (mounted) setState(() => _selectedFilter = _Filter.all);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom +
        kBottomNavigationBarHeight +
        AppSpacing.xl;
    final topics = _filteredTopics;

    return FutureBuilder<Map<String, TopicDisplay>>(
      future: _displaysFuture,
      builder: (context, snapshot) {
        final displaysById = snapshot.data;

        return FadeIn(
          child: SingleChildScrollView(
            key: const PageStorageKey<String>('topics'),
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SearchBar(),
                const SizedBox(height: 14),
                _FilterRow(
                  selected: _selectedFilter,
                  onSelected: (f) => setState(() => _selectedFilter = f),
                ),
                if (_showTrackPanel) ...[
                  const SizedBox(height: 16),
                  _TrackPanel(
                    onStandardTap: _onStandardTap,
                    onPremiumTap: _onPremiumTap,
                    onClose: () =>
                        setState(() => _selectedFilter = _Filter.all),
                  ),
                ],
                const SizedBox(height: 20),
                if (topics.isEmpty)
                  _NoResultsCard(
                    onClear: () =>
                        setState(() => _selectedFilter = _Filter.all),
                  )
                else if (displaysById == null)
                  const Center(child: CircularProgressIndicator())
                else
                  ...List.generate(topics.length, (i) {
                    final topic = topics[i];
                    final display = displaysById[topic.id] ??
                        TopicDisplay(id: topic.id, title: topic.id, subtitle: '');
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: i < topics.length - 1 ? 10 : 0),
                      child: _TopicCard(
                        topic: topic,
                        display: display,
                        onTap: topic.premium
                            ? () => _onPremiumTap(display.title)
                            : () => _onTopicTap(topic, display),
                      ),
                    );
                  }),
                const SizedBox(height: 20),
                const _ExamPacksCta(),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Search Bar ───────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 44),
      decoration: BoxDecoration(
        color: const Color(0xFF132040),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1F3055)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search, color: Color(0xFF8A9DC0), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              AppLocalizations.of(context).topicsSearchHint,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF4A6080), fontSize: 14),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

// ─── Filter Row ───────────────────────────────────────────────────────────────

class _FilterRow extends StatefulWidget {
  final _Filter selected;
  final ValueChanged<_Filter> onSelected;

  const _FilterRow({required this.selected, required this.onSelected});

  @override
  State<_FilterRow> createState() => _FilterRowState();
}

class _FilterRowState extends State<_FilterRow> {
  final _scrollController = ScrollController();

  _Filter get selected => widget.selected;
  ValueChanged<_Filter> get onSelected => widget.onSelected;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // "All", "Practice" and "Recommended" always stay on-screen; curriculum
  // filters (and any future ones added here) live behind "More" so the
  // primary row never crowds out on narrow phones.
  static const _primaryFilters = [_Filter.all, _Filter.practice, _Filter.recommended];
  static const _secondaryFilters = [_Filter.oxfordTrack, _Filter.gcse];

  static String _labelFor(AppLocalizations l10n, _Filter filter) => switch (filter) {
        _Filter.all => l10n.topicsFilterAll,
        _Filter.practice => l10n.topicsFilterPractice,
        _Filter.recommended => l10n.topicsFilterRecommended,
        _Filter.oxfordTrack => l10n.topicsFilterOxfordTrack,
        _Filter.gcse => l10n.topicsFilterGcse,
        _Filter.more => l10n.topicsFilterMore,
      };

  Future<void> _openMoreSheet(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final chosen = await showModalBottomSheet<_Filter>(
      context: context,
      backgroundColor: const Color(0xFF0D1525),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // Bounded and scrollable so a growing list of future curriculum/formula
      // filters can never overflow off the bottom of a short phone screen.
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: Text(
                  l10n.topicsFilterMore,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final filter in _secondaryFilters)
                      Semantics(
                        button: true,
                        selected: selected == filter,
                        label: _labelFor(l10n, filter),
                        child: ListTile(
                          minVerticalPadding: 16,
                          title: Text(
                            _labelFor(l10n, filter),
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          trailing: selected == filter
                              ? const Icon(Icons.check, color: Color(0xFF5B8EFF))
                              : null,
                          onTap: () => Navigator.of(sheetContext).pop(filter),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (chosen != null) onSelected(chosen);
  }

  Widget _chip(
    BuildContext context,
    AppLocalizations l10n,
    _Filter filter,
    String label, {
    bool isMoreChip = false,
    bool? selectedOverride,
    VoidCallback? onTapOverride,
  }) {
    final isSel = selectedOverride ?? (selected == filter);
    return Semantics(
      button: true,
      selected: isSel,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTapOverride ?? () => onSelected(filter),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isSel ? const Color(0xFF3D7EFF) : const Color(0xFF132040),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSel ? const Color(0xFF3D7EFF) : const Color(0xFF1F3055),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: isSel ? Colors.white : const Color(0xFF8A9DC0),
                      fontSize: 13,
                      fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  if (isMoreChip) ...[
                    const SizedBox(width: 2),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 14,
                      color: isSel ? Colors.white : const Color(0xFF8A9DC0),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isSecondarySelected = _secondaryFilters.contains(selected);
    // The More chip shows the active secondary filter's own name once one is
    // chosen, so the selection stays visible without needing to reopen the
    // sheet — this is how "preserve selected state" reads on-screen.
    final moreLabel = isSecondarySelected ? _labelFor(l10n, selected) : l10n.topicsFilterMore;

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final filter in _primaryFilters) ...[
              _chip(context, l10n, filter, _labelFor(l10n, filter)),
              const SizedBox(width: 8),
            ],
            _chip(
              context,
              l10n,
              _Filter.more,
              moreLabel,
              isMoreChip: true,
              selectedOverride: isSecondarySelected,
              onTapOverride: () => _openMoreSheet(context),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Track Panel ──────────────────────────────────────────────────────────────

class _TrackPanel extends StatelessWidget {
  final VoidCallback onStandardTap;
  final void Function(String) onPremiumTap;
  final VoidCallback onClose;

  const _TrackPanel({
    required this.onStandardTap,
    required this.onPremiumTap,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1525),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1F3055)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.topicsSelectTrack,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: const Icon(
                  Icons.close,
                  color: Color(0xFF8A9DC0),
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _TrackCard(
            title: l10n.topicsTrackStandard,
            subtitle: l10n.topicsTrackStandardSub,
            premium: false,
            onTap: onStandardTap,
          ),
          const SizedBox(height: 8),
          _TrackCard(
            title: l10n.topicsTrackGcseFoundation,
            subtitle: l10n.topicsTrackGcseFoundationSub,
            premium: true,
            onTap: () => onPremiumTap(l10n.topicsTrackGcseFoundation),
          ),
          const SizedBox(height: 8),
          _TrackCard(
            title: l10n.topicsTrackGcseHigher,
            subtitle: l10n.topicsTrackGcseHigherSub,
            premium: true,
            onTap: () => onPremiumTap(l10n.topicsTrackGcseHigher),
          ),
          const SizedBox(height: 8),
          _TrackCard(
            title: l10n.topicsTrackOxford,
            subtitle: l10n.topicsTrackOxfordSub,
            premium: true,
            onTap: () => onPremiumTap(l10n.topicsTrackOxford),
          ),
        ],
      ),
    );
  }
}

class _TrackCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool premium;
  final VoidCallback onTap;

  const _TrackCard({
    required this.title,
    required this.subtitle,
    required this.premium,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF132040),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  premium ? const Color(0xFF2A2010) : const Color(0xFF1F3055),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                          color: Color(0xFF8A9DC0), fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (premium)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A1A00),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFFF9500)),
                  ),
                  child: Text(
                    AppLocalizations.of(context).topicsPremiumLabel,
                    style: const TextStyle(
                      color: Color(0xFFFF9500),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                )
              else
                const Icon(Icons.chevron_right, color: Color(0xFF4A6080)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Topic Card ───────────────────────────────────────────────────────────────

class _TopicCard extends StatelessWidget {
  final _Topic topic;
  final TopicDisplay display;
  final VoidCallback? onTap;

  const _TopicCard({
    required this.topic,
    required this.display,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF132040),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: topic.premium
                  ? const Color(0xFF2A2010)
                  : const Color(0xFF1F3055),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon container
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          topic.iconBg,
                          Color.lerp(topic.iconBg, topic.iconColor, 0.18)!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: topic.iconColor.withValues(alpha: 0.22),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: topic.textIcon != null
                        ? Center(
                            child: Text(
                              topic.textIcon!,
                              style: TextStyle(
                                color: topic.iconColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        : Icon(topic.icon, color: topic.iconColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  // Title, subtitle, nextUp
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          display.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          display.subtitle,
                          style: const TextStyle(
                              color: Color(0xFF8A9DC0), fontSize: 13),
                        ),
                        if (topic.nextUp != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.play_circle_outline,
                                size: 12,
                                color: Color(0xFF5B8EFF),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)
                                      .nextUp(topic.nextUp!),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFF5B8EFF),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Status icon
                  if (topic.premium)
                    const Icon(Icons.lock, color: Color(0xFFFF9500), size: 18)
                  else
                    const Icon(Icons.chevron_right, color: Color(0xFF4A6080)),
                ],
              ),
              // Progress bar (only when progress > 0)
              if (topic.progress > 0) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: topic.progress,
                    minHeight: 3,
                    backgroundColor: const Color(0xFF1F3055),
                    valueColor: AlwaysStoppedAnimation<Color>(topic.iconColor),
                  ),
                ),
              ],
              // Premium badge
              if (topic.premium) ...[
                const SizedBox(height: 8),
                Wrap(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A1A00),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFFF9500)),
                      ),
                      child: Text(
                        AppLocalizations.of(context).topicsPremiumLabel,
                        style: const TextStyle(
                          color: Color(0xFFFF9500),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── No Results ───────────────────────────────────────────────────────────────

class _NoResultsCard extends StatelessWidget {
  final VoidCallback onClear;
  const _NoResultsCard({required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF132040),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1F3055)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context).topicsNoResults,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onClear,
            child: Text(
              AppLocalizations.of(context).topicsClearFilters,
              style: const TextStyle(
                color: Color(0xFF5B8EFF),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Exam Packs CTA ───────────────────────────────────────────────────────────

class _ExamPacksCta extends StatelessWidget {
  const _ExamPacksCta();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.push('/packs'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF132040),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF1F3055)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeSectionExamPacks,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.examPacksCtaSubtitle,
                      style: const TextStyle(
                        color: Color(0xFF8A9DC0),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D1F40),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF3D7EFF)),
                      ),
                      child: Text(
                        l10n.homeViewExamPacks,
                        style: const TextStyle(
                          color: Color(0xFF5B8EFF),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF4A6080),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
