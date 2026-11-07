import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/early_maths_lane.dart';
import 'package:unified_math_tutor/models/family_activity.dart';
import 'package:unified_math_tutor/models/visual_maths_tool.dart';
import 'package:unified_math_tutor/services/family_activity_catalog_service.dart';

/// Pure rules behind the Early Maths entry point: which activities each
/// starting point shows, and the honesty guards that keep that list truthful.
/// Superseded by earlyMathsEntryIntro and no longer referenced by any screen;
/// left in the ARBs so the existing translations are not deleted here.
const _retiredIntroKey = 'earlyMathsPlaygroundIntro';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EarlyMathsLane storage', () {
    test('round-trips every lane through its storage value', () {
      for (final lane in EarlyMathsLane.values) {
        expect(EarlyMathsLane.fromStorage(lane.storageValue), lane);
      }
    });

    test('storage values are the three agreed, stable strings', () {
      expect(
        EarlyMathsLane.values.map((l) => l.storageValue).toList(),
        ['early_maths_play', 'ks1_maths_foundations', 'not_sure'],
      );
    });

    test('unrecognised or missing values read as no lane chosen', () {
      expect(EarlyMathsLane.fromStorage(null), isNull);
      expect(EarlyMathsLane.fromStorage(''), isNull);
      expect(EarlyMathsLane.fromStorage('KS1'), isNull);
      expect(EarlyMathsLane.fromStorage('early_years'), isNull);
    });

    test('a lane is not a manifest stage or a practice stage', () {
      final manifest = jsonDecode(
        File('assets/config/curriculum_manifest.json').readAsStringSync(),
      ).toString();
      for (final lane in EarlyMathsLane.values) {
        expect(manifest.contains(lane.storageValue), isFalse,
            reason: 'The manifest must not know about lane '
                '${lane.storageValue} — lanes are presentation only.');
      }
    });
  });

  group('child activities per lane', () {
    test('Panda is in Early Maths Play and never in KS1 Foundations', () {
      expect(
        EarlyMathsLaneContent.childActivities(EarlyMathsLane.earlyMathsPlay),
        [EarlyMathsChildActivity.feedThePanda],
      );
      expect(
        EarlyMathsLaneContent.childActivities(
            EarlyMathsLane.ks1MathsFoundations),
        isNot(contains(EarlyMathsChildActivity.feedThePanda)),
      );
    });

    test('the abacus is only ever in KS1 Foundations', () {
      expect(
        EarlyMathsLaneContent.childActivities(
            EarlyMathsLane.ks1MathsFoundations),
        [EarlyMathsChildActivity.abacus],
      );
      for (final lane in [
        EarlyMathsLane.earlyMathsPlay,
        EarlyMathsLane.notSure,
        null
      ]) {
        expect(EarlyMathsLaneContent.childActivities(lane),
            isNot(contains(EarlyMathsChildActivity.abacus)),
            reason: 'Abacus must not appear for $lane');
      }
    });

    test('"I\'m not sure" and no choice behave the same: one gentle step', () {
      expect(EarlyMathsLaneContent.childActivities(EarlyMathsLane.notSure),
          EarlyMathsLaneContent.childActivities(null));
      expect(EarlyMathsLaneContent.childActivities(null).length,
          lessThanOrEqualTo(3));
      expect(EarlyMathsLaneContent.showsParentLedSection(null), isFalse);
      expect(
          EarlyMathsLaneContent.showsParentLedSection(EarlyMathsLane.notSure),
          isFalse);
    });

    test('only the two real, reachable activities exist as options', () {
      // A planned activity cannot be surfaced unless someone adds it here,
      // which this test then forces them to look at.
      expect(EarlyMathsChildActivity.values.map((a) => a.name).toSet(),
          {'feedThePanda', 'abacus'});
    });

    test('the abacus is interactive in the Visual Maths registry', () {
      // The Early Maths entry only offers the real interactive route. If the
      // registry changes, its badge and this learner-facing claim must be
      // reviewed together.
      expect(
        VisualMathsToolMeta
            .registry[VisualMathsToolId.abacus]!.hasInteractiveImplementation,
        isTrue,
      );
    });
  });

  group('parent-led Family Maths fit, from the real catalogue', () {
    late List<FamilyActivity> catalogue;

    setUpAll(() async {
      catalogue = await FamilyActivityCatalogService().all();
    });

    Set<String> idsFor(EarlyMathsLane lane) => {
          for (final a in catalogue)
            if (EarlyMathsLaneContent.parentLedActivityFits(lane, a)) a.id,
        };

    test('Early Maths Play suggests only activities that start at age 4', () {
      expect(idsFor(EarlyMathsLane.earlyMathsPlay), {'shape-hunt'});
    });

    test('KS1 Foundations suggests the activities that start at 6 or under',
        () {
      expect(idsFor(EarlyMathsLane.ks1MathsFoundations), {
        'shape-hunt',
        'build-twenty',
        'dice-race',
        'pattern-detective',
        'garden-geometry',
      });
    });

    test('nothing is suggested while the lane is undecided', () {
      expect(idsFor(EarlyMathsLane.notSure), isEmpty);
      for (final a in catalogue) {
        expect(EarlyMathsLaneContent.parentLedActivityFits(null, a), isFalse);
      }
    });

    test('every suggested activity has a real, loadable detail record', () {
      for (final lane in [
        EarlyMathsLane.earlyMathsPlay,
        EarlyMathsLane.ks1MathsFoundations,
      ]) {
        for (final id in idsFor(lane)) {
          expect(catalogue.where((a) => a.id == id), hasLength(1));
        }
      }
    });
  });

  group('copy honesty', () {
    late Map<String, dynamic> arb;

    setUpAll(() {
      arb = jsonDecode(File('lib/l10n/app_en.arb').readAsStringSync())
          as Map<String, dynamic>;
    });

    List<String> earlyMathsCopy() => [
          for (final e in arb.entries)
            if (e.key.startsWith('earlyMaths') &&
                e.key != _retiredIntroKey &&
                e.value is String)
              e.value as String,
        ];

    test('the entry copy has no coverage, level or "behind" language', () {
      final copy = earlyMathsCopy();
      expect(copy, isNotEmpty);
      final banned = RegExp(
        r'behind|catch up|full (reception|ks1|curriculum)|curriculum|'
        r'covered|complete|mastery|score|coming|planned|%',
        caseSensitive: false,
      );
      for (final text in copy) {
        // "not a level" is the one deliberate use of the word: it says age is
        // NOT a level. Any other use of "level" would be a claim.
        final withoutDisclaimer = text.replaceAll('not a level', '');
        expect(banned.hasMatch(withoutDisclaimer), isFalse,
            reason: 'Entry copy must not contain a banned claim: "$text"');
        expect(
            RegExp(r'\blevel\b', caseSensitive: false)
                .hasMatch(withoutDisclaimer),
            isFalse,
            reason: 'Entry copy must not contain a banned claim: "$text"');
      }
    });

    test('age is described as a suggestion, not an ability label', () {
      final intro = arb['earlyMathsEntryIntro'] as String;
      expect(intro.toLowerCase(), contains('suggestion'));
      expect(intro.toLowerCase(), contains('not a level'));
      expect(intro.toLowerCase(), contains('no test'));
    });

    test('Panda is described by its real, narrow scope', () {
      final scope = arb['earlyMathsPandaScope'] as String;
      expect(scope, contains('1 to 3 apples from 5'));
      expect(scope, contains('how many are left'));
    });

    test('the abacus copy describes only what it does', () {
      final scope = (arb['earlyMathsAbacusScope'] as String).toLowerCase();
      expect(scope, contains('interactive place-value tool'));
      expect(scope, contains('tap or drag beads'));
      expect(scope, contains('explore hundreds, tens and ones'));
      expect(scope, contains('hundreds, tens and ones'));
      for (final claim in [
        'preview',
        'coming soon',
        'soroban',
        'mental',
        'quiz',
        'multipl',
        'score',
      ]) {
        expect(scope.contains(claim), isFalse, reason: 'must not claim $claim');
      }
    });
  });
}
