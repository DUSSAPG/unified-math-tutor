import 'package:flutter/material.dart';
import 'package:flutter_shared_ui/flutter_shared_ui.dart';

class AdminConsoleScreen extends StatelessWidget {
  const AdminConsoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Admin Console Screen',
      child: const Center(
        child: Text('Admin Console Screen'),
      ),
    );
  }
}
