// lib/features/welcome/welcome_ch_it_screen.dart
import 'package:flutter/material.dart';
import 'welcome_screen.dart';

class WelcomeCHItScreen extends StatelessWidget {
  const WelcomeCHItScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WelcomeScreen(
      title: 'Benvenuto',
      subtitle: 'Tutor di matematica per la Svizzera (Italiano).',
      ctaText: 'Continua',
      onContinue: () => Navigator.pushReplacementNamed(context, '/home'),
    );
  }
}
