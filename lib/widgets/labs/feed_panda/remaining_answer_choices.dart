import 'package:flutter/material.dart';

/// Large, tappable number-choice buttons for "how many apples are left?" —
/// never a bare text field, per the brief. Responsive: wraps to fewer
/// columns on a narrow phone rather than shrinking below a comfortable tap
/// target.
class RemainingAnswerChoices extends StatelessWidget {
  const RemainingAnswerChoices({
    super.key,
    required this.choices,
    required this.onChosen,
    required this.enabled,
    required this.semanticLabelFor,
  });

  final List<int> choices;
  final ValueChanged<int> onChosen;
  final bool enabled;
  final String Function(int value) semanticLabelFor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      key: const Key('feedPandaRemainingAnswerChoices'),
      builder: (context, constraints) {
        final tileWidth =
            (constraints.maxWidth / choices.length - 12).clamp(64.0, 120.0);
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final value in choices)
              SizedBox(
                width: tileWidth,
                height: tileWidth,
                child: Semantics(
                  button: true,
                  label: semanticLabelFor(value),
                  child: ExcludeSemantics(
                    child: FilledButton(
                      key: ValueKey('feedPandaAnswerChoice_$value'),
                      onPressed: enabled ? () => onChosen(value) : null,
                      style: FilledButton.styleFrom(
                        shape: const CircleBorder(),
                        textStyle: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: Text('$value'),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
