// lib/features/welcome/welcome_ch_de_screen.dart
import 'package:flutter/material.dart';
import 'welcome_screen.dart';

class WelcomeCHDeScreen extends StatelessWidget {
  const WelcomeCHDeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WelcomeScreen(
      title: 'Willkommen',
      subtitle: 'Mathe-Coach für die Schweiz (Deutsch).',
      ctaText: 'Weiter',
      onContinue: () => Navigator.pushReplacementNamed(context, '/home'),
    );
  }
}
