import 'package:flutter/material.dart';

import '../../app/safe_navigation.dart';
import '../../services/formula_library_service.dart';

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

    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1120),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => popOrGo(context, '/home'),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Formula Library',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              'Quick reference for key maths formulas',
              style: TextStyle(color: Color(0xFF8A9DC0), fontSize: 12),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<FormulaEntry>>(
          future: FormulaLibraryService.instance.load(),
          builder: (context, snapshot) {
            final all = snapshot.data;
            if (all == null) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Could not load the formula library.',
                    style: TextStyle(color: Color(0xFF8A9DC0)),
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            }

            final categories = all.map((e) => e.category).toSet().toList();
            final filtered = all
                .where((e) =>
                    (_selectedCategory == null || e.category == _selectedCategory) &&
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
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _CategoryChip(
                        label: 'All',
                        selected: _selectedCategory == null,
                        onTap: () => setState(() => _selectedCategory = null),
                      ),
                      const SizedBox(width: 8),
                      for (final category in categories) ...[
                        _CategoryChip(
                          label: category,
                          selected: _selectedCategory == category,
                          onTap: () =>
                              setState(() => _selectedCategory = category),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: filtered.isEmpty
                      ? const Center(
                          child: Text(
                            'No formulas match your search.',
                            style: TextStyle(color: Color(0xFF8A9DC0)),
                          ),
                        )
                      : ListView.separated(
                          padding:
                              EdgeInsets.fromLTRB(16, 0, 16, bottomPadding),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
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
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF132040),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1F3055)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 14),
          prefixIcon: Icon(Icons.search, color: Color(0xFF8A9DC0), size: 20),
          hintText: 'Search formulas…',
          hintStyle: TextStyle(color: Color(0xFF4A6080), fontSize: 14),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF3D7EFF) : const Color(0xFF132040),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? const Color(0xFF3D7EFF) : const Color(0xFF1F3055),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF8A9DC0),
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF132040),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF1F3055)),
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.formula,
                          style: const TextStyle(
                            color: Color(0xFF5B8EFF),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    color: const Color(0xFF8A9DC0),
                  ),
                ],
              ),
              if (expanded) ...[
                const SizedBox(height: 12),
                const Divider(color: Color(0xFF1F3055), height: 1),
                const SizedBox(height: 12),
                if (entry.meaning.isNotEmpty) ...[
                  Text(
                    entry.meaning,
                    style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                ],
                if (entry.variables.isNotEmpty) ...[
                  const Text(
                    'VARIABLES',
                    style: TextStyle(
                      color: Color(0xFF8A9DC0),
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
                              style: const TextStyle(
                                color: Color(0xFF5B8EFF),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: v.meaning,
                              style: const TextStyle(color: Color(0xFF8A9DC0)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                if (entry.explanation.isNotEmpty) ...[
                  const Text(
                    'HOW IT WORKS',
                    style: TextStyle(
                      color: Color(0xFF8A9DC0),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    entry.explanation,
                    style: const TextStyle(
                      color: Colors.white,
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
                      color: const Color(0xFF0A1525),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF1F3055)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb_outline,
                            color: Color(0xFF34C759), size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.example,
                            style: const TextStyle(
                              color: Color(0xFF8A9DC0),
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
