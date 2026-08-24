import 'package:flutter_shared_models/question_item.dart';

/// Maps one raw JSONL pack record (as decoded by [JsonlPackLoader]) into a
/// [QuestionItem]. Extracted from `practice_screen.dart`'s private
/// `_questionFromPackJson` so `ContinueLearningDestinationResolver` can
/// reconstruct the exact same [QuestionItem]s from a checkpoint's persisted
/// question ids without duplicating — and risking drifting from — the
/// mapping practice sessions already use.
QuestionItem questionFromPackJson(Map<String, dynamic> json) {
  return QuestionItem(
    id: json['id'] as String? ?? '',
    question: (json['question'] ?? json['stem'] ?? '') as String,
    options: List<String>.from(json['options'] as List<dynamic>? ?? []),
    correctIndex: (json['correct_index'] ?? json['answer_index'] ?? 0) as int,
    explanation: (json['explanation'] ?? json['rationale'] ?? '') as String,
    topic: (json['topic'] ?? json['skill'] ?? json['strand'] ?? '') as String,
    difficulty: (json['difficulty'] ?? '').toString(),
  );
}
