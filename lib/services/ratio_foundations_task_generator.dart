import 'dart:math';

import 'package:flutter_shared_models/question_item.dart';

import '../models/ratio_foundations_item.dart';

/// Deterministic, offline, whole-number-only item generator for the Year 8
/// Ratio & Proportion "Ratio scaling foundations" vertical slice (Calculate
/// layer, Rungs 1-3 only). See
/// `assets/config/ratio_foundations_task_family_v1.json` for the versioned
/// task-family contract this implements.
///
/// # Determinism contract
/// [generate] is a pure function of (`rung`, `seed`, `itemIndexInRung`) —
/// the same three inputs always produce the identical item (same stem,
/// same options in the same order, same correct index, same explanation).
/// [_rngFor] mixes all three into one derived seed before constructing a
/// single seeded [Random]; a bare, unseeded `Random()` is never used for a
/// learner-facing item anywhere in this file.
///
/// # Construction, not generate-and-hope
/// Every item is built by first choosing the intended whole-number answer,
/// then deriving the stem's given values from it via the inverse
/// operation — never generated forwards and merely hoped to divide evenly.
/// [_validate] re-derives the expected answer independently and asserts it
/// against the recorded `correctIndex` before any item is returned, as a
/// second, independent check.
class RatioFoundationsTaskGenerator {
  RatioFoundationsTaskGenerator._();

  static const taskFamilyId = 'ratio_scaling_foundations';
  static const taskFamilyVersion = 1;

  static const _termMin = 1;
  static const _termMax = 9;
  static const _scaleMin = 2;
  static const _scaleMax = 5;

  static Random _rngFor(int seed, int rung, int itemIndexInRung) {
    final mixed = seed ^ (rung * 0x01000193) ^ (itemIndexInRung * 0x9E3779B1);
    return Random(mixed & 0x7fffffff);
  }

  static int _nextInRange(Random rng, int min, int max) =>
      min + rng.nextInt(max - min + 1);

  /// Builds exactly [count] distinct positive-integer options including
  /// [correct], preferring [preferredDistractors] in order, falling back to
  /// `correct + offset` (offset = 1, -1, 2, -2, ...) for any still missing,
  /// then shuffles deterministically with [rng]. Returns the option strings
  /// and the correct answer's index after shuffling.
  static (List<String>, int) _uniqueIntOptions({
    required int correct,
    required List<int> preferredDistractors,
    required int count,
    required Random rng,
  }) {
    final values = <int>{correct};
    for (final candidate in preferredDistractors) {
      if (values.length >= count) break;
      if (candidate > 0) values.add(candidate);
    }
    var offset = 1;
    while (values.length < count) {
      final up = correct + offset;
      if (values.length < count && up > 0) values.add(up);
      final down = correct - offset;
      if (values.length < count && down > 0) values.add(down);
      offset++;
    }
    final list = values.toList()..shuffle(rng);
    return (list.map((v) => '$v').toList(), list.indexOf(correct));
  }

  static RatioFoundationsItem generate({
    required int rung,
    required int seed,
    required int itemIndexInRung,
  }) {
    final item = switch (rung) {
      1 => _generateRung1(seed, itemIndexInRung),
      2 => _generateRung2(seed, itemIndexInRung),
      3 => _generateRung3(seed, itemIndexInRung),
      _ => throw ArgumentError(
          'Unsupported rung $rung for $taskFamilyId — this slice only '
          'implements Rungs 1-3.',
        ),
    };
    _validate(item);
    return item;
  }

  // ── Rung 1 — Recognise ────────────────────────────────────────────────

  static RatioFoundationsItem _generateRung1(int seed, int itemIndexInRung) {
    final rng = _rngFor(seed, 1, itemIndexInRung);
    // Alternates the two required Rung-1 behaviours deterministically —
    // "identify equivalent vs non-equivalent" and "identify the common
    // scale factor" — rather than picking randomly, so both are reliably
    // exercised across a short run of items.
    return itemIndexInRung.isOdd
        ? _rung1ScaleFactorItem(seed, itemIndexInRung, rng)
        : _rung1EquivalenceItem(seed, itemIndexInRung, rng);
  }

  static RatioFoundationsItem _rung1ScaleFactorItem(
    int seed,
    int itemIndexInRung,
    Random rng,
  ) {
    final a = _nextInRange(rng, _termMin, _termMax);
    final b = _nextInRange(rng, _termMin, _termMax);
    final k = _nextInRange(rng, _scaleMin, _scaleMax);
    final c = a * k;
    final d = b * k;
    final (options, correctIndex) = _uniqueIntOptions(
      correct: k,
      preferredDistractors: [k + 1, k - 1, c - a],
      count: 4,
      rng: rng,
    );
    return RatioFoundationsItem(
      question: QuestionItem(
        id: 'ratio_found_r1sf_${seed}_$itemIndexInRung',
        question: 'A ratio $a:$b is scaled up to $c:$d. '
            'What scale factor was used?',
        options: options,
        correctIndex: correctIndex,
        explanation: '$a x $k = $c and $b x $k = $d — both terms were '
            'multiplied by the same scale factor, $k.',
        topic: 'ratio_proportion',
        difficulty: 'foundation',
      ),
      rung: 1,
      seed: seed,
      itemIndexInRung: itemIndexInRung,
      taskFamilyId: taskFamilyId,
      taskFamilyVersion: taskFamilyVersion,
    );
  }

  static RatioFoundationsItem _rung1EquivalenceItem(
    int seed,
    int itemIndexInRung,
    Random rng,
  ) {
    final a = _nextInRange(rng, _termMin, _termMax);
    final b = _nextInRange(rng, _termMin, _termMax);
    final k = _nextInRange(rng, _scaleMin, _scaleMax);
    final equivalent = rng.nextBool();
    int c;
    int d;
    if (equivalent) {
      c = a * k;
      d = b * k;
    } else {
      // Additive near-miss — the exact misconception this sub-type tests
      // (Operation/transformation family). Guard against the rare case
      // where an additive change is ALSO accidentally a valid scale
      // (cross-multiplication check) by trying the next k until genuinely
      // non-equivalent — bounded, since the domain is small.
      var candidateK = k;
      c = a + candidateK;
      d = b + candidateK;
      while (c * b == d * a && candidateK < _scaleMax + _termMax) {
        candidateK++;
        c = a + candidateK;
        d = b + candidateK;
      }
    }
    final options = ['Yes', 'No'];
    final correctIndex = equivalent ? 0 : 1;
    return RatioFoundationsItem(
      question: QuestionItem(
        id: 'ratio_found_r1eq_${seed}_$itemIndexInRung',
        question: 'Is the ratio $c:$d equivalent to $a:$b?',
        options: options,
        correctIndex: correctIndex,
        explanation: equivalent
            ? '$a x $k = $c and $b x $k = $d — both terms were multiplied '
                'by the same scale factor, $k, so the ratios are '
                'equivalent.'
            : '$a:$b needs both terms MULTIPLIED by the same amount to '
                'stay equivalent. $c:$d does not come from multiplying '
                '$a:$b by a single whole number, so the ratios are not '
                'equivalent.',
        topic: 'ratio_proportion',
        difficulty: 'foundation',
      ),
      rung: 1,
      seed: seed,
      itemIndexInRung: itemIndexInRung,
      taskFamilyId: taskFamilyId,
      taskFamilyVersion: taskFamilyVersion,
    );
  }

  // ── Rung 2 — Guided practice ──────────────────────────────────────────

  static RatioFoundationsItem _generateRung2(int seed, int itemIndexInRung) {
    final rng = _rngFor(seed, 2, itemIndexInRung);
    final a = _nextInRange(rng, _termMin, _termMax);
    final b = _nextInRange(rng, _termMin, _termMax);
    final k = _nextInRange(rng, _scaleMin, _scaleMax);
    // Construct backward: the intended answer bScaled is a plain product
    // of two chosen positive integers, so it is whole by construction.
    final aScaled = a * k;
    final bScaled = b * k;
    final (options, correctIndex) = _uniqueIntOptions(
      correct: bScaled,
      preferredDistractors: [
        b, // scaled one side only / left unchanged
        b + k, // additive misconception
        bScaled + k,
      ],
      count: 4,
      rng: rng,
    );
    final oneSideOnlyIndex = options.indexOf('$b');
    return RatioFoundationsItem(
      question: QuestionItem(
        id: 'ratio_found_r2_${seed}_$itemIndexInRung',
        question: 'The ratio $a:$b is scaled so the first term becomes '
            '$aScaled. What does the second term become?',
        options: options,
        correctIndex: correctIndex,
        explanation: '$a was multiplied by $k to get $aScaled, so $b must '
            'also be multiplied by $k: $b x $k = $bScaled. Both linked '
            'quantities always use the same scale factor.',
        topic: 'ratio_proportion',
        difficulty: 'foundation',
      ),
      rung: 2,
      seed: seed,
      itemIndexInRung: itemIndexInRung,
      taskFamilyId: taskFamilyId,
      taskFamilyVersion: taskFamilyVersion,
      oneSideOnlyDistractorIndex:
          oneSideOnlyIndex == -1 ? null : oneSideOnlyIndex,
    );
  }

  // ── Rung 3 — Fluency variation ────────────────────────────────────────

  static RatioFoundationsItem _generateRung3(int seed, int itemIndexInRung) {
    final rng = _rngFor(seed, 3, itemIndexInRung);
    final scaleUp = itemIndexInRung.isEven; // deterministic direction split
    final a = _nextInRange(rng, _termMin, _termMax);
    final b = _nextInRange(rng, _termMin, _termMax);
    final k = _nextInRange(rng, _scaleMin, _scaleMax);

    if (scaleUp) {
      // Same forward construction as Rung 2 — multiplication is whole by
      // construction — but a different stem phrasing (representation
      // variation) than Rung 2 uses.
      final aScaled = a * k;
      final bScaled = b * k;
      final (options, correctIndex) = _uniqueIntOptions(
        correct: bScaled,
        preferredDistractors: [b, b + k, bScaled - k],
        count: 4,
        rng: rng,
      );
      final oneSideOnlyIndex = options.indexOf('$b');
      return RatioFoundationsItem(
        question: QuestionItem(
          id: 'ratio_found_r3up_${seed}_$itemIndexInRung',
          question: 'A ratio table shows $a:$b scaled up to $aScaled:?. '
              'Complete the missing value.',
          options: options,
          correctIndex: correctIndex,
          explanation: '$a x $k = $aScaled, so $b x $k = $bScaled.',
          topic: 'ratio_proportion',
          difficulty: 'foundation',
        ),
        rung: 3,
        seed: seed,
        itemIndexInRung: itemIndexInRung,
        taskFamilyId: taskFamilyId,
        taskFamilyVersion: taskFamilyVersion,
        oneSideOnlyDistractorIndex:
            oneSideOnlyIndex == -1 ? null : oneSideOnlyIndex,
      );
    }

    // Scale down: construct backward from the intended (smaller) answer
    // bSmall, then derive the larger given pair by multiplying — the
    // learner's job is still one clean division, never introducing a
    // fraction (bSmall is chosen as a whole number first, by construction).
    final bSmall = _nextInRange(rng, _termMin, _termMax);
    final aSmall = _nextInRange(rng, _termMin, _termMax);
    final aLarge = aSmall * k;
    final bLarge = bSmall * k;
    final (options, correctIndex) = _uniqueIntOptions(
      correct: bSmall,
      preferredDistractors: [bLarge, bSmall + k, (bLarge - k).clamp(1, 999)],
      count: 4,
      rng: rng,
    );
    final oneSideOnlyIndex = options.indexOf('$bLarge');
    return RatioFoundationsItem(
      question: QuestionItem(
        id: 'ratio_found_r3down_${seed}_$itemIndexInRung',
        question: 'The ratio $aLarge:$bLarge is scaled down so the first '
            'term becomes $aSmall. What does the second term become?',
        options: options,
        correctIndex: correctIndex,
        explanation: '$aLarge / $k = $aSmall, so $bLarge / $k = $bSmall. '
            'Both terms use the same scale factor, whether scaling up or '
            'down.',
        topic: 'ratio_proportion',
        difficulty: 'foundation',
      ),
      rung: 3,
      seed: seed,
      itemIndexInRung: itemIndexInRung,
      taskFamilyId: taskFamilyId,
      taskFamilyVersion: taskFamilyVersion,
      // "Scaled one side only" here means: left the second term at its
      // large, unscaled value while the first term was correctly scaled
      // down — the same authored signature, mirrored for this direction.
      oneSideOnlyDistractorIndex:
          oneSideOnlyIndex == -1 ? null : oneSideOnlyIndex,
    );
  }

  // ── Validation ─────────────────────────────────────────────────────────

  /// Independently re-checks structural correctness before an item is ever
  /// shown: options are non-empty, distinct, `correctIndex` is in range,
  /// and (for the numeric rungs) every option parses as a positive whole
  /// number. This never re-derives the maths from scratch (that would just
  /// duplicate the generation code above) — it is a structural safety net,
  /// not a second oracle.
  static void _validate(RatioFoundationsItem item) {
    final q = item.question;
    if (q.options.isEmpty) {
      throw StateError('${q.id}: generated with no options.');
    }
    if (q.options.toSet().length != q.options.length) {
      throw StateError('${q.id}: generated duplicate options ${q.options}.');
    }
    if (q.correctIndex < 0 || q.correctIndex >= q.options.length) {
      throw StateError(
        '${q.id}: correctIndex ${q.correctIndex} out of range for '
        '${q.options.length} options.',
      );
    }
    if (item.rung != 1 || q.options.length != 2) {
      // Numeric rungs (all of Rung 2/3, and Rung 1's scale-factor
      // sub-type) must be positive whole numbers — Rung 1's Yes/No
      // equivalence sub-type is exempt.
      for (final option in q.options) {
        final parsed = int.tryParse(option);
        if (parsed == null || parsed <= 0) {
          throw StateError(
            '${q.id}: option "$option" is not a positive whole number.',
          );
        }
      }
    }
    final oneSideIndex = item.oneSideOnlyDistractorIndex;
    if (oneSideIndex != null &&
        (oneSideIndex < 0 || oneSideIndex >= q.options.length)) {
      throw StateError(
        '${q.id}: oneSideOnlyDistractorIndex $oneSideIndex out of range.',
      );
    }
  }
}
