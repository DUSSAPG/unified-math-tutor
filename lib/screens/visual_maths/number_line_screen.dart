import 'package:flutter/material.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';

import '../../app/safe_navigation.dart';
import '../../models/number_line_example.dart';
import '../../services/nav_visibility_service.dart';
import '../../services/number_line_examples_service.dart';
import '../../shared/theme/app_spacing.dart';
import '../../widgets/visual_maths/number_line_widget.dart';

String _captionFor(AppLocalizations l10n, String exampleId) => switch (exampleId) {
      'basic-whole-number' => l10n.numberLineExampleBasicWholeNumber,
      'negative-number' => l10n.numberLineExampleNegativeNumber,
      'simple-fraction' => l10n.numberLineExampleSimpleFraction,
      'decimal' => l10n.numberLineExampleDecimal,
      _ => exampleId,
    };

class NumberLineScreen extends StatefulWidget {
  const NumberLineScreen({super.key});

  @override
  State<NumberLineScreen> createState() => _NumberLineScreenState();
}

class _NumberLineScreenState extends State<NumberLineScreen> {
  late final Future<List<NumberLineExample>> _examplesFuture;
  int _exampleIndex = 0;
  num? _value;

  @override
  void initState() {
    super.initState();
    _examplesFuture = NumberLineExamplesService.instance.all();
    NavVisibilityService.instance.hide();
  }

  @override
  void dispose() {
    NavVisibilityService.instance.show();
    super.dispose();
  }

  void _nextExample(List<NumberLineExample> examples) {
    setState(() {
      _exampleIndex = (_exampleIndex + 1) % examples.length;
      _value = examples[_exampleIndex].target;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1120),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => popOrGo(context, '/math-studio/visual-maths'),
        ),
        title: Text(
          l10n.visualMathsNumberLineTitle,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<NumberLineExample>>(
          future: _examplesFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Icon(Icons.error_outline, color: Color(0xFF8A9DC0), size: 32),
              );
            }
            final examples = snapshot.data;
            if (examples == null) {
              return const Center(child: CircularProgressIndicator());
            }
            final example = examples[_exampleIndex];
            final value = _value ?? example.target;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _captionFor(l10n, example.id),
                        style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.4),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      NumberLineWidget(
                        min: example.min,
                        max: example.max,
                        step: example.step,
                        value: value,
                        semanticLabel: _captionFor(l10n, example.id),
                        onChanged: (next) => setState(() => _value = next),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      OutlinedButton(
                        onPressed: () => _nextExample(examples),
                        child: Text(l10n.visualMathsTryAnotherExample),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
