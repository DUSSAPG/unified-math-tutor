import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).upgradeEarlyAccessSnackbar),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1120),
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => popOrGo(context, '/profile'),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A1F00),
                        borderRadius: BorderRadius.circular(36),
                        border: Border.all(
                            color: const Color(0xFFFFBD00), width: 2),
                      ),
                      child: const Icon(Icons.star,
                          color: Color(0xFFFFBD00), size: 36),
                    ),
                  ),
                  const Text(
                    'Unlock Your Full\nPotential',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Get unlimited access to all features and content',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF8A9DC0), fontSize: 14),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF132040),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF1F3055)),
                    ),
                    child: const Column(
                      children: [
                        _FeatureRow('Unlimited practice questions'),
                        _FeatureRow('All topic categories'),
                        _FeatureRow('Oxford Track curriculum'),
                        _FeatureRow('GCSE exam simulator'),
                        _FeatureRow('AI tutor — unlimited sessions'),
                        _FeatureRow('Parental progress reports', last: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => _showComingSoon(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B8EFF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Subscribe — £4.99 / month',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Coming soon — payments aren\'t live yet, this won\'t charge you.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF4A6080), fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => _showComingSoon(context),
                    child: const Text(
                      'Restore Purchases',
                      style: TextStyle(color: Color(0xFF8A9DC0), fontSize: 13),
                    ),
                  ),
                  TextButton(
                    onPressed: () => popOrGo(context, '/profile'),
                    child: const Text(
                      'Maybe Later',
                      style: TextStyle(color: Color(0xFF4A6080), fontSize: 13),
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
}

class _FeatureRow extends StatelessWidget {
  final String text;
  final bool last;

  const _FeatureRow(this.text, {this.last = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF34C759), size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
