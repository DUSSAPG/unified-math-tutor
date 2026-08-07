import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// One short free-text note per learner, for Tutor Tools. Deliberately the
/// simplest possible store — no history, no rich text, no sync — matching
/// the brief's "keep tutor functionality lightweight".
class TutorNotesService {
  TutorNotesService._();
  static final instance = TutorNotesService._();

  static const _key = 'tutor_notes_by_learner';

  late SharedPreferences _prefs;
  final ValueNotifier<Map<String, String>> notes = ValueNotifier(const {});

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs.getString(_key);
    if (raw != null) {
      notes.value = Map<String, String>.from(jsonDecode(raw) as Map);
    }
  }

  String noteFor(String learnerId) => notes.value[learnerId] ?? '';

  Future<void> setNote(String learnerId, String note) async {
    final updated = Map<String, String>.from(notes.value);
    if (note.trim().isEmpty) {
      updated.remove(learnerId);
    } else {
      updated[learnerId] = note.trim();
    }
    notes.value = updated;
    await _prefs.setString(_key, jsonEncode(updated));
  }
}
