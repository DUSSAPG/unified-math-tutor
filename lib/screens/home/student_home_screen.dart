import 'package:flutter/material.dart';
import 'package:flutter_shared_ui/flutter_shared_ui.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Student Home Screen',
      child: const Center(
        child: Text('Student Home Screen'),
      ),
    );
  }
}
