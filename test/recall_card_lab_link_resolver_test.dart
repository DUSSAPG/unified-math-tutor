import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/interactive_lab_id.dart';
import 'package:unified_math_tutor/services/recall_card_lab_link_resolver.dart';
import 'package:unified_math_tutor/services/topic_capability_resolver.dart';

/// The one small, typed, central mapping between a Recall Card's
/// `relatedInteractiveLabIds` entry and the real, shipped lab it names.
void main() {
  group('legacy ids', () {
    test('flight-lab resolves to the real Flight Path Lab', () {
      expect(RecallCardLabLinkResolver.resolve('flight-lab'),
          InteractiveLabId.flightPathLab);
    });

    test('data-lab resolves to the real Data Detective lab', () {
      expect(RecallCardLabLinkResolver.resolve('data-lab'),
          InteractiveLabId.dataDetective);
    });

    test('every legacy id used in the shipped catalog is covered', () {
      // The catalog's own only two authored lab ids today — see
      // assets/config/recall_cards.json. If a third legacy id is ever
      // authored there without being added here, this is the test that
      // should be extended, not one that should start failing silently.
      for (final id in ['flight-lab', 'data-lab']) {
        expect(RecallCardLabLinkResolver.resolve(id), isNotNull,
            reason: '"$id" is used by the shipped catalog and must resolve.');
      }
    });
  });

  group('canonical ids', () {
    test('every InteractiveLabId also resolves by its own enum name', () {
      // A card authored after this fix should be able to use the real id
      // directly, with no legacy-map entry required.
      for (final lab in InteractiveLabId.values) {
        expect(RecallCardLabLinkResolver.resolve(lab.name), lab);
      }
    });
  });

  group('unknown ids fail safely', () {
    test('an id matching nothing resolves to null, not a throw', () {
      expect(
        () => RecallCardLabLinkResolver.resolve('not-a-real-lab'),
        returnsNormally,
      );
      expect(RecallCardLabLinkResolver.resolve('not-a-real-lab'), isNull);
    });

    test('a near-miss (typo, different case, empty) also resolves to null', () {
      for (final id in ['flightlab', 'Flight-Lab', 'FLIGHTPATHLAB', '']) {
        expect(RecallCardLabLinkResolver.resolve(id), isNull, reason: id);
      }
    });
  });

  test('every id this resolver can produce has a real, routable destination',
      () {
    // Guards against the resolver and the route table drifting apart: if a
    // future InteractiveLabId is added without a labRoutes entry, a chip
    // could resolve to a lab with nowhere real to send the learner.
    for (final lab in InteractiveLabId.values) {
      expect(TopicCapabilityResolver.labRoutes.containsKey(lab), isTrue,
          reason: '$lab has no route in TopicCapabilityResolver.labRoutes.');
    }
  });
}
