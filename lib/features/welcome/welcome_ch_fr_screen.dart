// lib/features/welcome/welcome_ch_fr_screen.dart
import 'package:flutter/material.dart';
import 'welcome_screen.dart';

class WelcomeCHFrScreen extends StatelessWidget {
  const WelcomeCHFrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WelcomeScreen(
      title: 'Bienvenue',
      subtitle: 'Coach de maths pour la Suisse (Français).',
      ctaText: 'Continuer',
      onContinue: () => Navigator.pushReplacementNamed(context, '/home'),
    );
  }
}
