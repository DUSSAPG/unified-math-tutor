import 'package:flutter/material.dart';

import '../../services/formula_library_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../widgets/visual_assets/visual_asset_view.dart';

class FormulaLibraryScreen extends StatefulWidget {
  const FormulaLibraryScreen({super.key});

  @override
  State<FormulaLibraryScreen> createState() => _FormulaLibraryScreenState();
}

class _FormulaLibraryScreenState extends State<FormulaLibraryScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String? _selectedCategory;
  String? _expandedId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom + 16;
    final colors = context.appColors;

    // No own AppBar/Scaffold: this is a bottom-nav tab, so AppShell already
    // provides the outer Scaffold and title bar (matching Topics/Tutor/Help).
    return SafeArea(
        top: false,
        child: FutureBuilder<List<FormulaEntry>>(
          future: FormulaLibraryService.instance.load(),
          builder: (context, snapshot) {
            final all = snapshot.data;
            if (all == null) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Could not load the formula library.',
                    style: TextStyle(color: colors.secondaryText),
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            }

            final categories = all.map((e) => e.category).toSet().toList();
            final filtered = all
                .where((e) =>
                    (_selectedCategory == null ||
                        e.category == _selectedCategory) &&
                    e.matches(_query))
                .toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: _SearchField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                  ),
                ),
                const SizedBox(height: 12),
                _CategoryFilterRow(
                  categories: categories,
                  selectedCategory: _selectedCategory,
                  onSelected: (category) =>
                      setState(() => _selectedCategory = category),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Text(
                            'No formulas match your search.',
                            style: TextStyle(color: colors.secondaryText),
                          ),
                        )
                      : ListView.separated(
                          padding:
                              EdgeInsets.fromLTRB(16, 0, 16, bottomPadding),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final entry = filtered[index];
                            return _FormulaCard(
                              entry: entry,
                              expanded: _expandedId == entry.id,
                              onTap: () => setState(() {
                                _expandedId =
                                    _expandedId == entry.id ? null : entry.id;
                              }),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ));
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: colors.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.divider),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(color: colors.primaryText, fontSize: 14),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          prefixIcon: Icon(Icons.search, color: colors.secondaryText, size: 20),
          hintText: 'Search formulas…',
          hintStyle: TextStyle(color: colors.tertiaryText, fontSize: 14),
        ),
      ),
    );
  }
}

/// "All" plus the first few categories stay directly on-screen; the rest
/// live behind "More" (a bottom sheet) so a growing category list never
/// crowds a narrow phone. A `Scrollbar` gives a visible affordance for the
/// row that does still scroll.
class _CategoryFilterRow extends StatefulWidget {
  const _CategoryFilterRow({
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onSelected;

  @override
  State<_CategoryFilterRow> createState() => _CategoryFilterRowState();
}

class _CategoryFilterRowState extends State<_CategoryFilterRow> {
  final _scrollController = ScrollController();

  List<String> get categories => widget.categories;
  String? get selectedCategory => widget.selectedCategory;
  ValueChanged<String?> get onSelected => widget.onSelected;

  static const _inlineCategoryCount = 3;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openMoreSheet(
      BuildContext context, List<String> overflow) async {
    final colors = context.appColors;
    final chosen = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: colors.elevatedSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // A growing category list must scroll within a bounded sheet height
      // rather than overflow off the bottom of a short phone screen.
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
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
                  'More categories',
                  style: TextStyle(
                      color: colors.primaryText,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final category in overflow)
                      Semantics(
                        button: true,
                        selected: selectedCategory == category,
                        label: category,
                        child: ListTile(
                          minVerticalPadding: 16,
                          title: Text(category,
                              style: TextStyle(
                                  color: colors.primaryText, fontSize: 15)),
                          trailing: selectedCategory == category
                              ? Icon(Icons.check, color: colors.accent)
                              : null,
                          onTap: () => Navigator.of(sheetContext).pop(category),
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
    String label, {
    required bool selected,
    bool isMoreChip = false,
    required VoidCallback onTap,
  }) {
    final colors = context.appColors;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? colors.primaryAction : colors.cardSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected ? colors.primaryAction : colors.divider,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: selected
                          ? colors.onPrimaryAction
                          : colors.secondaryText,
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  if (isMoreChip) ...[
                    const SizedBox(width: 2),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 14,
                      color: selected
                          ? colors.onPrimaryAction
                          : colors.secondaryText,
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
    final inline = categories.take(_inlineCategoryCount).toList();
    final overflow = categories.skip(_inlineCategoryCount).toList();
    final isOverflowSelected =
        selectedCategory != null && overflow.contains(selectedCategory);

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _chip(context, 'All',
                selected: selectedCategory == null,
                onTap: () => onSelected(null)),
            const SizedBox(width: 8),
            for (final category in inline) ...[
              _chip(
                context,
                category,
                selected: selectedCategory == category,
                onTap: () => onSelected(category),
              ),
              const SizedBox(width: 8),
            ],
            if (overflow.isNotEmpty)
              _chip(
                context,
                isOverflowSelected ? selectedCategory! : 'More',
                selected: isOverflowSelected,
                isMoreChip: true,
                onTap: () => _openMoreSheet(context, overflow),
              ),
          ],
        ),
      ),
    );
  }
}

class _FormulaCard extends StatelessWidget {
  const _FormulaCard({
    required this.entry,
    required this.expanded,
    required this.onTap,
  });

  final FormulaEntry entry;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.cardSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.title,
                          style: TextStyle(
                            color: colors.primaryText,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.formula,
                          style: TextStyle(
                            color: colors.accent,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    color: colors.secondaryText,
                  ),
                ],
              ),
              if (expanded) ...[
                const SizedBox(height: 12),
                Divider(color: colors.divider, height: 1),
                const SizedBox(height: 12),
                if (entry.diagramAssetId != null) ...[
                  VisualAssetView(assetId: entry.diagramAssetId!),
                  const SizedBox(height: 10),
                ],
                if (entry.meaning.isNotEmpty) ...[
                  Text(
                    entry.meaning,
                    style: TextStyle(color: colors.secondaryText, fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                ],
                if (entry.variables.isNotEmpty) ...[
                  Text(
                    'VARIABLES',
                    style: TextStyle(
                      color: colors.secondaryText,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...entry.variables.map(
                    (v) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 13),
                          children: [
                            TextSpan(
                              text: '${v.symbol}  ',
                              style: TextStyle(
                                color: colors.accent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: v.meaning,
                              style: TextStyle(color: colors.secondaryText),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                if (entry.explanation.isNotEmpty) ...[
                  Text(
                    'HOW IT WORKS',
                    style: TextStyle(
                      color: colors.secondaryText,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    entry.explanation,
                    style: TextStyle(
                      color: colors.primaryText,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                if (entry.example.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colors.divider),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lightbulb_outline,
                            color: colors.success, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.example,
                            style: TextStyle(
                              color: colors.secondaryText,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
