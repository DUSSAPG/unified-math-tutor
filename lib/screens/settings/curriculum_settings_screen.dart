import 'package:flutter/material.dart';

import '../../app/safe_navigation.dart';

class CurriculumSettingsScreen extends StatefulWidget {
  const CurriculumSettingsScreen({super.key});

  @override
  State<CurriculumSettingsScreen> createState() =>
      _CurriculumSettingsScreenState();
}

class _CurriculumSettingsScreenState extends State<CurriculumSettingsScreen> {
  String _selectedStage = 'KS2';
  String _selectedMode = 'School Support';

  static const List<String> _stages = ['KS2', 'KS3', 'KS4', 'KS5'];
  static const List<(String, String)> _modes = [
    ('School Support', 'Follow your school curriculum'),
    ('Exam Prep', 'Focus on exam-style questions'),
    ('Self-Directed', 'Explore topics at your own pace'),
  ];

  @override
  Widget build(BuildContext context) {
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
          onPressed: () => popOrGo(context, '/profile'),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Curriculum Settings',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              'Tailor content to your learning level',
              style: TextStyle(color: Color(0xFF8A9DC0), fontSize: 12),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionCard(
                    title: 'Key Stage',
                    subtitle: 'Select your current school stage',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _stages.map((stage) {
                        final selected = _selectedStage == stage;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedStage = stage),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFF0D1F40)
                                  : const Color(0xFF0D1525),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF5B8EFF)
                                    : const Color(0xFF1F3055),
                                width: selected ? 2 : 1,
                              ),
                            ),
                            child: Text(
                              stage,
                              style: TextStyle(
                                color: selected
                                    ? const Color(0xFF5B8EFF)
                                    : const Color(0xFF8A9DC0),
                                fontSize: 14,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _sectionCard(
                    title: 'Learning Mode',
                    subtitle: 'How would you like to learn?',
                    child: Column(
                      children: _modes.map(((String, String) m) {
                        final selected = _selectedMode == m.$1;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => setState(() => _selectedMode = m.$1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: selected
                                    ? const Color(0xFF0D1F40)
                                    : const Color(0xFF0D1525),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selected
                                      ? const Color(0xFF5B8EFF)
                                      : const Color(0xFF1F3055),
                                  width: selected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          m.$1,
                                          style: TextStyle(
                                            color: selected
                                                ? const Color(0xFF5B8EFF)
                                                : Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          m.$2,
                                          style: const TextStyle(
                                            color: Color(0xFF8A9DC0),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (selected)
                                    const Icon(Icons.check_circle,
                                        color: Color(0xFF5B8EFF), size: 18),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionCard(
      {required String title,
      required String subtitle,
      required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF132040),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1F3055)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: const TextStyle(color: Color(0xFF8A9DC0), fontSize: 13)),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
