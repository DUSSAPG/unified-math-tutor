import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/graph_question.dart';

void main() {
  test('parses graph_read metadata without affecting ordinary questions', () {
    expect(GraphQuestion.fromQuestionJson({'type': 'mcq'}), isNull);

    final graph = GraphQuestion.fromQuestionJson({
      'type': 'graph_read',
      'graph': {
        'points': [
          [0, 1],
          [2, 5],
        ],
        'latexCaption': r'y = 2x + 1',
      },
    });

    expect(graph?.points.length, 2);
    expect(graph?.points.last.y, 5);
    expect(graph?.latexCaption, r'y = 2x + 1');
  });

  test('rejects graph_read question without points', () {
    expect(
      () => GraphQuestion.fromQuestionJson({
        'type': 'graph_read',
        'graph': <String, dynamic>{},
      }),
      throwsFormatException,
    );
  });
}
