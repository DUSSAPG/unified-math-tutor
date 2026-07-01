import 'package:flutter/material.dart';

/// Future standalone question screen.
///
/// Production practice sessions render and score questions inside
/// `PracticeScreen`; no production UI currently navigates to this stub.
class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Question Screen')),
    );
  }
}
