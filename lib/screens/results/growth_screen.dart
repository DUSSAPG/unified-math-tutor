import 'package:flutter/material.dart';
import 'package:flutter_shared_ui/flutter_shared_ui.dart';

class GrowthScreen extends StatelessWidget {
  const GrowthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Growth Screen',
      child: const Center(
        child: Text('Growth Screen'),
      ),
    );
  }
}
