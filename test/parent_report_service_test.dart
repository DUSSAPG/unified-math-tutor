import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/services/local_preferences_service.dart';
import 'package:unified_math_tutor/services/parent_report_service.dart';
import 'package:unified_math_tutor/services/session_history_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const incorrect = SessionQuestionResult(
    question: 'Find x',
    options: ['1', '2'],
    correctIndex: 1,
    selectedIndex: 0,
    topic: 'Algebra',
  );
  const correct = SessionQuestionResult(
    question: 'Find y',
    options: ['1', '2'],
    correctIndex: 0,
    selectedIndex: 0,
    topic: 'Geometry',
  );
  final sessions = [
    PracticeSessionResult(
      stage: 'KS3',
      completedAt: DateTime(2026, 5, 31),
      questions: const [incorrect, correct],
    ),
  ];

  test('generates drill suggestions and a real PDF', () async {
    const reports = ParentReportService();
    expect(reports.drillSuggestions(sessions), {'Algebra': 1});
    final bytes = await reports.buildPdf(sessions);
    expect(bytes.take(4), [37, 80, 68, 70]);
  });

  test('resets parent PIN only with the current PIN', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = LocalPreferencesService.instance;
    await prefs.init();
    expect(await prefs.setParentPin('1234'), isTrue);
    expect(await prefs.resetParentPin('9999', '5678'), isFalse);
    expect(await prefs.resetParentPin('1234', '5678'), isTrue);
    expect(prefs.verifyParentPin('5678'), isTrue);
  });
}
