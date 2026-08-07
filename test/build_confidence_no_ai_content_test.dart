import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shared_models/question_item.dart';
import 'package:unified_math_tutor/services/jsonl_pack_loader.dart';
import 'package:unified_math_tutor/services/pack_registry_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
      'Build Confidence is a dedicated pack, not exam questions filtered by difficulty',
      () async {
    final pack = await PackRegistryService.instance.forId('build_confidence');
    final rows = await JsonlPackLoader.instance.load(pack);
    final questions = rows.map(QuestionItem.fromJson).toList();

    expect(questions, hasLength(12));
    for (final question in questions) {
      expect(question.topic, 'Build Confidence');
    }
  });

  test('no punitive or AI-related language anywhere in the pack content',
      () async {
    final pack = await PackRegistryService.instance.forId('build_confidence');
    final rows = await JsonlPackLoader.instance.load(pack);
    final questions = rows.map(QuestionItem.fromJson).toList();

    const forbidden = [
      'wrong',
      'incorrect',
      'fail',
      ' ai ',
      'artificial intelligence'
    ];
    for (final question in questions) {
      final haystack =
          ' ${question.question} ${question.explanation} ${question.options.join(' ')} '
              .toLowerCase();
      for (final term in forbidden) {
        expect(haystack.contains(term), isFalse,
            reason: 'Found "$term" in ${question.id}');
      }
    }
  });

  test(
      'difficulty tiers represent gradual progression, not exam difficulty labels',
      () async {
    final pack = await PackRegistryService.instance.forId('build_confidence');
    final rows = await JsonlPackLoader.instance.load(pack);
    final questions = rows.map(QuestionItem.fromJson).toList();

    final tiers = questions.map((q) => q.difficulty).toSet();
    expect(tiers, {'step1', 'step2', 'step3', 'step4'});
    for (final tier in tiers) {
      expect(['easy', 'medium', 'hard'].contains(tier), isFalse);
    }
  });
}
