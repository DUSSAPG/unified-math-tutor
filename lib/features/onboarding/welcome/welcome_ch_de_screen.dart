import 'package:flutter/material.dart';

class WelcomeCHDeScreen extends StatelessWidget {
  const WelcomeCHDeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace copy/layout to match Figma WelcomeScreenDE.tsx exactly.
    return Scaffold(
      appBar: AppBar(title: const Text('Willkommen')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'CoachSuite Mathe',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            const Text(
              'Kurze tägliche Übungen, klare Erklärungen und Fortschritt, den Eltern sehen können.',
              style: TextStyle(fontSize: 16, height: 1.35),
            ),
            const SizedBox(height: 18),
            const _FeatureRow(
              icon: Icons.auto_graph,
              text: 'Fortschritt & Schwächen verfolgen',
            ),
            const SizedBox(height: 10),
            const _FeatureRow(
                icon: Icons.school, text: 'Übungspakete nach Niveau'),
            const SizedBox(height: 10),
            const _FeatureRow(
              icon: Icons.print,
              text: 'Arbeitsblätter als PDF exportieren',
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  // Next screen: your Home / Dashboard route
                  // Replace with your actual route.
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                child: const Text('Los geht’s'),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Sprache ändern'),
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}
