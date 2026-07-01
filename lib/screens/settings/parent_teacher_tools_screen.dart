import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../services/local_preferences_service.dart';

class ParentTeacherToolsScreen extends StatefulWidget {
  const ParentTeacherToolsScreen({super.key});

  @override
  State<ParentTeacherToolsScreen> createState() =>
      _ParentTeacherToolsScreenState();
}

class _ParentTeacherToolsScreenState extends State<ParentTeacherToolsScreen> {
  final _pinController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final prefs = LocalPreferencesService.instance;
    final pin = _pinController.text;
    final l10n = AppLocalizations.of(context);
    if (!prefs.hasParentPin) {
      if (!await prefs.setParentPin(pin)) {
        if (mounted) setState(() => _error = l10n.pinMustBeFourDigits);
        return;
      }
      prefs.grantParentToolsAfterPinCreation();
    } else if (!prefs.unlockParentTools(pin)) {
      setState(() => _error = l10n.pinIncorrect);
      return;
    }
    if (mounted) context.push('/help/parent-teacher-tools/cheat-sheet');
  }

  Future<void> _resetPin() async {
    final current = TextEditingController();
    final replacement = TextEditingController();
    final reset = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(l10n.resetParentPin),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: current,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.currentPin),
              ),
              TextField(
                controller: replacement,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.fourDigitPin),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => context.pop(false),
                child: Text(MaterialLocalizations.of(context).cancelButtonLabel)),
            FilledButton(
                onPressed: () => context.pop(true),
                child: Text(l10n.resetLabel)),
          ],
        );
      },
    );
    if (reset != true) return;
    final changed = await LocalPreferencesService.instance
        .resetParentPin(current.text, replacement.text);
    if (!mounted) return;
    setState(() => _error = changed ? null : AppLocalizations.of(context).pinResetFailed);
  }

  @override
  Widget build(BuildContext context) {
    final prefs = LocalPreferencesService.instance;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => popOrGo(context, '/profile/settings'),
        ),
        title: Text(l10n.parentTeacherTools),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder<bool>(
          valueListenable: prefs.parentToolsEnabled,
          builder: (context, enabled, _) {
            if (!enabled) {
              return _InfoCard(
                title: l10n.unlockParentTools,
                body: '${l10n.enableParentTools} · ${l10n.settingsTitle}',
              );
            }
            return ListView(
              children: [
                _InfoCard(
                  title: prefs.hasParentPin
                      ? l10n.enterParentPin
                      : l10n.createParentPin,
                  body: l10n.parentPinStorageNotice,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: l10n.fourDigitPin,
                    errorText: _error,
                  ),
                ),
                FilledButton(
                  onPressed: _submit,
                  child: Text(l10n.openCheatSheet),
                ),
                if (prefs.hasParentPin)
                  TextButton(
                    onPressed: _resetPin,
                    child: Text(l10n.resetParentPin),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Container(
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
                    color: Colors.white, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(body,
                style: const TextStyle(color: Color(0xFF8A9DC0), height: 1.4)),
          ],
        ),
      );
}
