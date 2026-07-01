import 'package:flutter/material.dart';
import 'package:flutter_shared_ui/flutter_shared_ui.dart';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Skills Screen',
      child: const Center(
        child: Text('Skills Screen'),
      ),
    );
  }
}
