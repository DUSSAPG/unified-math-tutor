import 'package:flutter/material.dart';
import 'package:flutter_shared_ui/flutter_shared_ui.dart';

class SubscriptionSuccessScreen extends StatelessWidget {
  const SubscriptionSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Subscription Success Screen',
      child: const Center(
        child: Text('Subscription Success Screen'),
      ),
    );
  }
}
