import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../models/family_activity.dart';
import '../../services/family_activity_catalog_service.dart';
import '../../shared/responsive/app_breakpoints.dart';
import '../../shared/theme/app_spacing.dart';
import '../../widgets/settings/parent_gate.dart';
import 'family_maths_category_labels.dart';
import 'family_maths_reassurance.dart';

/// Grid of Family Maths activities, filterable by topic. Mirrors
/// [DiscoveryLibraryScreen]'s structure.
class FamilyMathsLibraryScreen extends StatefulWidget {
  const FamilyMathsLibraryScreen({super.key, this.initialCategory});

  /// Pre-selects one category chip on open — e.g. Family Studio's
  /// "Fractions and Ratio" section links here already filtered, rather
  /// than duplicating this screen. Defaults to showing everything, same as
  /// today.
  final FamilyMathsCategory? initialCategory;

  @override
  State<FamilyMathsLibraryScreen> createState() =>
      _FamilyMathsLibraryScreenState();
}

class _FamilyMathsLibraryScreenState extends State<FamilyMathsLibraryScreen> {
  late FamilyMathsCategory? _filter = widget.initialCategory;
  late final Future<List<FamilyActivity>> _activitiesFuture;
  final _categoryScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _activitiesFuture = FamilyActivityCatalogService.instance.all();
  }

  @override
  void dispose() {
    _categoryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ParentGate(
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return Scaffold(
          backgroundColor: const Color(0xFF0B1120),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0B1120),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () =>
                  popOrGo(context, '/help/parent-teacher-tools/family-maths'),
            ),
            title: Text(
              l10n.familyMathsLibraryTitle,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          body: SafeArea(
            child: FutureBuilder<List<FamilyActivity>>(
              future: _activitiesFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Icon(Icons.error_outline,
                        color: Color(0xFF8A9DC0), size: 32),
                  );
                }
                final activities = snapshot.data;
                if (activities == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                final visible = _filter == null
                    ? activities
                    : activities
                        .where((activity) => activity.category == _filter)
                        .toList();
                final presentCategories = <FamilyMathsCategory>{
                  for (final activity in activities) activity.category,
                }.toList()
                  ..sort((a, b) => a.index.compareTo(b.index));

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: AppResponsive.contentMaxWidth(context)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                              AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              familyMathsReassuranceOfTheDay(
                                  l10n, DateTime.now()),
                              style: const TextStyle(
                                color: Color(0xFF8A9DC0),
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 52,
                          child: Scrollbar(
                            controller: _categoryScrollController,
                            thumbVisibility: true,
                            child: ListView(
                              key: const Key('familyMathsCategoryChipRow'),
                              controller: _categoryScrollController,
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                              children: [
                                _FilterChip(
                                  label: l10n.mathStudioCategoryAll,
                                  selected: _filter == null,
                                  onTap: () => setState(() => _filter = null),
                                ),
                                for (final category in presentCategories)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: _FilterChip(
                                      label: familyMathsCategoryLabel(
                                          l10n, category),
                                      selected: _filter == category,
                                      onTap: () =>
                                          setState(() => _filter = category),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: visible.isEmpty
                              ? _EmptyCategoryState(
                                  message: l10n.familyMathsEmptyCategory)
                              : GridView.builder(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 260,
                                    // Taller than Discovery's equivalent
                                    // tile (216): this tile wraps 3 badges
                                    // (category + age + time) instead of 2,
                                    // which needs a second badge row more
                                    // often at narrow tile widths.
                                    mainAxisExtent: 220 *
                                        MediaQuery.textScalerOf(context)
                                            .scale(1.0)
                                            .clamp(1.0, 1.6),
                                    crossAxisSpacing: AppSpacing.sm,
                                    mainAxisSpacing: AppSpacing.sm,
                                  ),
                                  itemCount: visible.length,
                                  itemBuilder: (context, index) {
                                    final activity = visible[index];
                                    final text = activity.textFor(
                                        Localizations.localeOf(context));
                                    return _ActivityTile(
                                      title: text.title,
                                      categoryLabel: familyMathsCategoryLabel(
                                          l10n, activity.category),
                                      ageLabel: l10n.familyActivityAgeRange(
                                          activity.minAgeYears,
                                          activity.maxAgeYears),
                                      timeLabel: l10n.familyActivityTimeRange(
                                          activity.minMinutes,
                                          activity.maxMinutes),
                                      onTap: () => context.push(
                                          '/help/parent-teacher-tools/family-maths/activity/${activity.id}'),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _EmptyCategoryState extends StatelessWidget {
  const _EmptyCategoryState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Color(0xFF8A9DC0), fontSize: 14, height: 1.4),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: const Color(0xFF5B8EFF),
      backgroundColor: const Color(0xFF132040),
      labelStyle: TextStyle(
        color: selected ? Colors.white : const Color(0xFF8A9DC0),
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
      ),
      side: BorderSide(
          color: selected ? const Color(0xFF5B8EFF) : const Color(0xFF1F3055)),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final String title;
  final String categoryLabel;
  final String ageLabel;
  final String timeLabel;
  final VoidCallback onTap;

  const _ActivityTile({
    required this.title,
    required this.categoryLabel,
    required this.ageLabel,
    required this.timeLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF132040),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF1F3055)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.diversity_3, color: Color(0xFFFF9F5B), size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  _Badge(text: categoryLabel, color: const Color(0xFF5B8EFF)),
                  _Badge(text: ageLabel, color: const Color(0xFF8A9DC0)),
                  _Badge(text: timeLabel, color: const Color(0xFF8A9DC0)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        text,
        style:
            TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}
