import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/tutor_usage_model.dart';
import 'guest_tip_counter.dart';

class TutorCreditService {
  TutorCreditService._();
  static final TutorCreditService instance = TutorCreditService._();

  static const _isPaidKey = 'tutor_is_paid';
  static const _creditsKey = 'tutor_credits';

  late SharedPreferences _prefs;
  late final ValueNotifier<TutorUsageModel> _notifier;

  ValueNotifier<TutorUsageModel> get notifier => _notifier;
  TutorUsageModel get state => _notifier.value;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _notifier = ValueNotifier(_load());
  }

  TutorUsageModel _load() => TutorUsageModel(
        isPaid: _prefs.getBool(_isPaidKey) ?? false,
        tipsUsed: GuestTipCounter.read(_prefs),
        credits: _prefs.getInt(_creditsKey) ?? 0,
      );

  /// Consumes one guest tip. Returns false if already exhausted.
  Future<bool> consumeGuestTip() async {
    if (state.tipsExhausted) return false;
    await GuestTipCounter.increment(_prefs);
    _notifier.value = _load();
    return true;
  }

  /// Consumes one credit. Returns false if no credits remain.
  Future<bool> consumeCredit() async {
    if (!state.hasCredits) return false;
    await _prefs.setInt(_creditsKey, state.credits - 1);
    _notifier.value = _load();
    return true;
  }

  Future<void> setPaid({required bool paid, int credits = 0}) async {
    await _prefs.setBool(_isPaidKey, paid);
    await _prefs.setInt(_creditsKey, credits);
    _notifier.value = _load();
  }

  /// Returns a local mock response for the given input. No network calls.
  String respond(String input) {
    final q = input.toLowerCase();
    if (_hasAny(q, ['explain', 'what is', 'why ', 'how does'])) {
      return _pick(_kExplain);
    }
    if (_hasAny(q, ['hint', 'clue', 'nudge', 'stuck'])) {
      return _pick(_kHint);
    }
    if (_hasAny(q, ['step', 'walk', 'show me'])) {
      return _pick(_kSteps);
    }
    if (_hasAny(q, ['mistake', 'wrong', 'check my', 'error'])) {
      return _pick(_kMistake);
    }
    if (_hasAny(q, ['deep', 'detail', 'analysis'])) {
      return _pick(_kDeep);
    }
    return _pick(_kGeneral);
  }

  static bool _hasAny(String q, List<String> keys) =>
      keys.any((k) => q.contains(k));

  static T _pick<T>(List<T> items) =>
      items[DateTime.now().microsecond % items.length];

  static const _kExplain = [
    'Think of it like a balance scale. Whatever you do to one side of an equation, you must do to the other to keep it equal — that single rule unlocks almost all of algebra.',
    'This concept is built on equivalence. Two expressions are equivalent when they produce the same result for every valid input. Recognising that lets you simplify complex problems.',
    'Start by identifying the type of operation involved. Once you label it (linear, proportional, quadratic), the rules for that type tell you exactly what to do next.',
  ];

  static const _kHint = [
    'Hint: try working backwards. If you know what the answer should look like, ask yourself — what single operation would produce that result from the numbers you have?',
    "Here's a nudge — look for a common factor. Simplifying before you calculate usually makes the arithmetic much easier.",
    "Think about a similar problem you've solved before. The same strategy very often applies here with only a small adjustment.",
  ];

  static const _kSteps = [
    'Step 1 — Write down what you know.\nStep 2 — Identify what you need to find.\nStep 3 — Choose the right operation (remember BODMAS for mixed expressions).\nStep 4 — Solve, then check your answer makes sense.',
    '① Simplify each side separately if possible.\n② Use the inverse operation to isolate the unknown.\n③ Check your answer by substituting it back into the original.',
    '1. Circle the key numbers and the question word.\n2. Decide: addition, subtraction, multiplication, or division?\n3. Set out your working clearly, one step per line.\n4. Verify with an estimate.',
  ];

  static const _kMistake = [
    "Common slip: forgetting that when you move a term across the equals sign, its sign flips. Positive becomes negative and vice versa. Check each step for that.",
    "The order of operations may be off. Remember BODMAS — Brackets first, then Orders, then Division and Multiplication (left to right), then Addition and Subtraction.",
    'Sign errors are the most frequent mistake at this stage. Go through each line and confirm the sign of every term before moving to the next step.',
  ];

  static const _kDeep = [
    'At a deeper level, this is the distributive property in action: a(b + c) = ab + ac. Once that pattern is clear, many algebraic manipulations become routine.',
    'This connects to inverse functions. Every operation has an inverse — addition has subtraction, multiplication has division — and using inverses is how we isolate unknowns.',
    'The underlying idea is mathematical equivalence: we rewrite expressions in different but equal forms until we reach the simplest one. This principle runs through all of pure mathematics.',
  ];

  static const _kGeneral = [
    'Break the problem into smaller pieces. Solve each piece on its own, then combine the results. Maths rewards organised, step-by-step thinking.',
    "Let's approach this systematically. First, identify what type of problem it is. Then apply the rules for that type, one step at a time.",
    'Write everything down, even the steps that feel obvious. This keeps your work clear, makes checking easier, and helps you spot exactly where any error crept in.',
  ];
}
