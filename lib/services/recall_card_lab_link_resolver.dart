import '../models/interactive_lab_id.dart';

/// Resolves one entry of [RecallCard.relatedInteractiveLabIds] to the real
/// [InteractiveLabId] it names, so a Recall Card can link straight to a real,
/// shipped Interactive Lab instead of rendering an inert "coming soon" chip.
///
/// The catalog authored two ids (`flight-lab`, `data-lab`) before
/// [InteractiveLabId] existed, from a time when Interactive Labs really were
/// only a forward-declared contract. Those ids never matched
/// `InteractiveLabId.name`, so the only thing that ever consumed them
/// (`RecallCardBody`'s `_RelatedLinks`) always fell back to a static,
/// non-navigating chip — the two ids are kept exactly as authored in
/// `assets/config/recall_cards.json` (that JSON is untouched by this fix) and
/// this small, typed, centrally-tested map is the one place that translates
/// them. A card authored later with the canonical `InteractiveLabId.name`
/// (e.g. `footballPrecision`) resolves too, via [InteractiveLabId.fromId], so
/// both spellings are supported without a second lookup table to keep in
/// sync.
///
/// [resolve] never throws: an id that matches neither the legacy map nor a
/// canonical [InteractiveLabId] name returns `null`, which the caller must
/// treat as "no real destination" — never as a reason to render a misleading
/// live-looking chip.
class RecallCardLabLinkResolver {
  const RecallCardLabLinkResolver._();

  /// Legacy ids authored in `recall_cards.json` before [InteractiveLabId]
  /// existed. Add to this map only for an id already present in the shipped
  /// catalog — a new card should be authored with the canonical
  /// [InteractiveLabId] name directly.
  static const Map<String, InteractiveLabId> legacyIds = {
    'flight-lab': InteractiveLabId.flightPathLab,
    'data-lab': InteractiveLabId.dataDetective,
  };

  static InteractiveLabId? resolve(String rawId) {
    final legacy = legacyIds[rawId];
    if (legacy != null) return legacy;
    try {
      return InteractiveLabId.fromId(rawId);
    } on FormatException {
      return null;
    }
  }
}
