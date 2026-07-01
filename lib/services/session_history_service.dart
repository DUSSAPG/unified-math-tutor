import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SessionQuestionResult {
  final String question;
  final List<String> options;
  final int correctIndex;
  final int selectedIndex;
  final String topic;
  final String explanation;

  const SessionQuestionResult({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.selectedIndex,
    this.topic = '',
    this.explanation = '',
  });

  Map<String, dynamic> toJson() => {
        'question': question,
        'options': options,
        'correctIndex': correctIndex,
        'selectedIndex': selectedIndex,
        'topic': topic,
        'explanation': explanation,
      };

  factory SessionQuestionResult.fromJson(Map<String, dynamic> json) =>
      SessionQuestionResult(
        question: json['question'] as String,
        options: List<String>.from(json['options'] as List),
        correctIndex: json['correctIndex'] as int,
        selectedIndex: json['selectedIndex'] as int,
        topic: json['topic'] as String? ?? '',
        explanation: json['explanation'] as String? ?? '',
      );
}

class PracticeSessionResult {
  final String stage;
  final DateTime completedAt;
  final List<SessionQuestionResult> questions;

  const PracticeSessionResult({
    required this.stage,
    required this.completedAt,
    required this.questions,
  });

  Map<String, dynamic> toJson() => {
        'stage': stage,
        'completedAt': completedAt.toIso8601String(),
        'questions': questions.map((question) => question.toJson()).toList(),
      };

  factory PracticeSessionResult.fromJson(Map<String, dynamic> json) =>
      PracticeSessionResult(
        stage: json['stage'] as String,
        completedAt: DateTime.parse(json['completedAt'] as String),
        questions: (json['questions'] as List)
            .map((value) =>
                SessionQuestionResult.fromJson(value as Map<String, dynamic>))
            .toList(),
      );
}

class SessionHistoryService {
  SessionHistoryService._();
  static final instance = SessionHistoryService._();
  static const _key = 'practice_session_history';
  static const maxSessions = 20;

  Future<List<PracticeSessionResult>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((value) =>
            PracticeSessionResult.fromJson(value as Map<String, dynamic>))
        .toList();
  }

  Future<void> add(PracticeSessionResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await load();
    history.insert(0, result);
    if (history.length > maxSessions) {
      history.removeRange(maxSessions, history.length);
    }
    await prefs.setString(
        _key, jsonEncode(history.map((value) => value.toJson()).toList()));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
