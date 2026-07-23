import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MentalMathTrick {
  const MentalMathTrick({
    required this.id,
    required this.title,
    required this.explanation,
    required this.workedPrompt,
    required this.workedSteps,
    required this.workedAnswer,
    required this.practicePrompt,
    required this.practiceAnswer,
  });

  final String id;
  final String title;
  final String explanation;
  final String workedPrompt;
  final List<String> workedSteps;
  final String workedAnswer;
  final String practicePrompt;
  final String practiceAnswer;

  factory MentalMathTrick.fromJson(Map<String, dynamic> json) {
    final worked = json['workedExample'] as Map<String, dynamic>;
    final practice = json['practiceExample'] as Map<String, dynamic>;
    return MentalMathTrick(
      id: json['id'] as String,
      title: json['title'] as String,
      explanation: json['explanation'] as String,
      workedPrompt: worked['prompt'] as String,
      workedSteps: List<String>.from(worked['steps'] as List),
      workedAnswer: worked['answer'] as String,
      practicePrompt: practice['prompt'] as String,
      practiceAnswer: practice['answer'] as String,
    );
  }
}

class DailyBrainTeaser {
  const DailyBrainTeaser({
    required this.id,
    required this.question,
    required this.answer,
    required this.difficulty,
    required this.tags,
  });

  final String id;
  final String question;
  final String answer;
  final String difficulty;
  final List<String> tags;

  String get teaser => question;

  factory DailyBrainTeaser.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final question = json['question'];
    final answer = json['answer'];
    final difficulty = json['difficulty'];
    final tags = json['tags'];
    if (id is! String ||
        !RegExp(r'^t\d{3}$').hasMatch(id) ||
        question is! String ||
        question.trim().isEmpty ||
        answer is! String ||
        answer.trim().isEmpty ||
        difficulty is! String ||
        !const {'easy', 'medium', 'hard'}.contains(difficulty) ||
        tags is! List ||
        tags.any((tag) => tag is! String || tag.trim().isEmpty)) {
      throw const FormatException('Invalid daily brain teaser entry.');
    }
    return DailyBrainTeaser(
      id: id,
      question: question,
      answer: answer,
      difficulty: difficulty,
      tags: List<String>.unmodifiable(tags.cast<String>()),
    );
  }
}

class MentalMathVaultService {
  MentalMathVaultService({AssetBundle? bundle})
      : _bundle = bundle ?? rootBundle;

  static const tricksAssetPath = 'assets/config/mental_math_tricks.json';
  static const teasersAssetPath = 'assets/config/daily_brain_teasers.json';
  static final DateTime _dailyTeaserEpoch = DateTime.utc(2020, 1, 1);
  static final MentalMathVaultService instance = MentalMathVaultService();

  final AssetBundle _bundle;
  List<MentalMathTrick>? _tricks;
  final Map<String, List<DailyBrainTeaser>> _teasersByLocale = {};

  Future<List<MentalMathTrick>> getTricks() async {
    if (_tricks != null) return _tricks!;
    final decoded = jsonDecode(await _bundle.loadString(tricksAssetPath));
    final values = (decoded as Map<String, dynamic>)['tricks'] as List;
    _tricks = List.unmodifiable(
      values.map((value) => MentalMathTrick.fromJson(
            value as Map<String, dynamic>,
          )),
    );
    return _tricks!;
  }

  Future<MentalMathTrick?> getTrick(String id) async {
    for (final trick in await getTricks()) {
      if (trick.id == id) return trick;
    }
    return null;
  }

  Future<List<DailyBrainTeaser>> getTeasers([Locale? locale]) async {
    final resolvedLocale = locale ?? const Locale('en');
    final localeTag = _localeTag(resolvedLocale);
    final cached = _teasersByLocale[localeTag];
    if (cached != null) return cached;

    // English has no per-region teaser file (e.g. no "en.json" or
    // "en-GB.json") — only the base teasersAssetPath. Gating on languageCode
    // rather than the full tag means en-GB/en-US etc. go straight to the
    // base file instead of first probing two asset paths that can never
    // exist, which previously logged spurious 404s on every English launch.
    final languageCode = resolvedLocale.languageCode;
    final paths = <String>[
      if (languageCode != 'en' && localeTag != languageCode)
        'assets/config/daily_brain_teasers.$localeTag.json',
      if (languageCode != 'en')
        'assets/config/daily_brain_teasers.$languageCode.json',
      teasersAssetPath,
    ];

    Object? lastLoadError;
    for (final path in paths.toSet()) {
      String source;
      try {
        source = await _bundle.loadString(path);
      } catch (error) {
        lastLoadError = error;
        continue;
      }
      try {
        final decoded = jsonDecode(source);
        if (decoded is! List) {
          throw const FormatException('Top-level value must be an array.');
        }
        final teasers = decoded.map((value) {
          if (value is! Map<String, dynamic>) {
            throw const FormatException('Every entry must be an object.');
          }
          return DailyBrainTeaser.fromJson(value);
        }).toList()
          ..sort((left, right) => left.id.compareTo(right.id));
        final result = List<DailyBrainTeaser>.unmodifiable(teasers);
        _teasersByLocale[localeTag] = result;
        return result;
      } catch (error, stackTrace) {
        Error.throwWithStackTrace(
          StateError('Failed to parse daily teasers from "$path": $error'),
          stackTrace,
        );
      }
    }
    throw StateError(
      'Unable to load daily brain teasers for "$localeTag". '
      'Tried ${paths.toSet().join(', ')}. Last error: $lastLoadError',
    );
  }

  Future<DailyBrainTeaser> getDailyTeaser(
    DateTime date, [
    Locale? locale,
  ]) async {
    final teasers = await getTeasers(locale);
    if (teasers.isEmpty) {
      throw StateError(
        'No daily brain teasers found for "${_localeTag(locale ?? const Locale('en'))}".',
      );
    }

    final utcDay = DateTime.utc(date.year, date.month, date.day);
    final dayOffset = utcDay.difference(_dailyTeaserEpoch).inDays;
    final index = dayOffset % teasers.length;
    return teasers[index];
  }

  static String _localeTag(Locale locale) {
    final countryCode = locale.countryCode;
    return countryCode == null || countryCode.isEmpty
        ? locale.languageCode
        : '${locale.languageCode}-$countryCode';
  }
}
