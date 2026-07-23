import 'package:flutter/material.dart';
import '../../app/safe_navigation.dart';
import '../../services/local_preferences_service.dart';

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  static const List<double> _textScales = [0.9, 1.0, 1.15];

  late int _textSize = _textScaleIndex(
      LocalPreferencesService.instance.textScale.value); // 0=Small 1=Default 2=Large
  bool _reduceMotion = LocalPreferencesService.instance.reduceMotion.value;
  bool _quietStudyMode = LocalPreferencesService.instance.quietStudyMode.value;
  bool _soundEnabled = LocalPreferencesService.instance.soundEnabled.value;

  static int _textScaleIndex(double scale) {
    var closest = 0;
    var closestDiff = double.infinity;
    for (var i = 0; i < _textScales.length; i++) {
      final diff = (scale - _textScales[i]).abs();
      if (diff < closestDiff) {
        closestDiff = diff;
        closest = i;
      }
    }
    return closest;
  }

  Future<void> _selectTextSize(int index) async {
    setState(() => _textSize = index);
    await LocalPreferencesService.instance.setTextScale(_textScales[index]);
  }

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
              'Accessibility',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              'Adjust for comfort and readability',
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
                  // Reading Size
                  _sectionCard(
                    title: 'Reading Size',
                    subtitle: 'Choose a comfortable reading size',
                    child: Row(
                      children: [
                        _SizeOption(
                          label: 'Small',
                          fontSize: 12,
                          selected: _textSize == 0,
                          onTap: () => _selectTextSize(0),
                        ),
                        const SizedBox(width: 10),
                        _SizeOption(
                          label: 'Default',
                          fontSize: 14,
                          selected: _textSize == 1,
                          onTap: () => _selectTextSize(1),
                        ),
                        const SizedBox(width: 10),
                        _SizeOption(
                          label: 'Large',
                          fontSize: 18,
                          selected: _textSize == 2,
                          onTap: () => _selectTextSize(2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Reduce Motion
                  _ToggleCard(
                    icon: Icons.animation,
                    iconColor: const Color(0xFF00BCD4),
                    iconBg: const Color(0xFF003040),
                    title: 'Reduce Motion',
                    subtitle: 'Minimise animations and transitions',
                    value: _reduceMotion,
                    onChanged: (v) async {
                      await LocalPreferencesService.instance.setReduceMotion(v);
                      if (mounted) setState(() => _reduceMotion = v);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Quiet Study Mode
                  _ToggleCard(
                    icon: Icons.self_improvement,
                    iconColor: const Color(0xFF34C759),
                    iconBg: const Color(0xFF0F2E1A),
                    title: 'Quiet Study Mode',
                    subtitle:
                        'Inspired by Nyepi, a Balinese tradition of reflection, stillness and focus — reduces Captain Math and sound cues',
                    value: _quietStudyMode,
                    onChanged: (v) async {
                      await LocalPreferencesService.instance.setQuietStudyMode(v);
                      if (mounted) setState(() => _quietStudyMode = v);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Sound Cues
                  _ToggleCard(
                    icon: Icons.volume_up_outlined,
                    iconColor: const Color(0xFFFFBD00),
                    iconBg: const Color(0xFF2E2500),
                    title: 'Sound Cues',
                    subtitle: 'Short, optional sounds for Interactive Labs actions',
                    value: _soundEnabled,
                    onChanged: (v) async {
                      await LocalPreferencesService.instance.setSoundEnabled(v);
                      if (mounted) setState(() => _soundEnabled = v);
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

// ─── Size Option ──────────────────────────────────────────────────────────────

class _SizeOption extends StatelessWidget {
  final String label;
  final double fontSize;
  final bool selected;
  final VoidCallback onTap;

  const _SizeOption({
    required this.label,
    required this.fontSize,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1525),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  selected ? const Color(0xFF5B8EFF) : const Color(0xFF1F3055),
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                'Aa',
                style: TextStyle(
                  color: selected
                      ? const Color(0xFF5B8EFF)
                      : const Color(0xFF8A9DC0),
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected
                      ? const Color(0xFF5B8EFF)
                      : const Color(0xFF8A9DC0),
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Toggle Card ─────────────────────────────────────────────────────────────

class _ToggleCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF132040),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1F3055)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        color: Color(0xFF8A9DC0), fontSize: 13)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF5B8EFF),
          ),
        ],
      ),
    );
  }
}
