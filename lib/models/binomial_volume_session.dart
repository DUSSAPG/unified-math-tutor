import 'package:flutter/foundation.dart';

import 'binomial_volume_model.dart';

/// The five guided steps. Steps 1–4 each ask the learner to find one term's
/// pieces; step 5 reveals the complete expansion. Any step can be opened at
/// any time — the order is a suggestion, never a gate.
enum BinomialGuidedStep {
  findACubed(BinomialTerm.aCubed),
  findASquaredB(BinomialTerm.aSquaredB),
  findABSquared(BinomialTerm.aBSquared),
  findBCubed(BinomialTerm.bCubed),
  revealExpansion(null);

  const BinomialGuidedStep(this.target);

  /// The term this step asks the learner to find; null for the reveal step.
  final BinomialTerm? target;

  /// 1-based number shown to learners.
  int get number => index + 1;

  BinomialGuidedStep? get next =>
      index + 1 < values.length ? values[index + 1] : null;
}

/// Session-only state for one visit to Binomial Volume Lab. Nothing here is
/// persisted, scored or timed: leaving the screen discards it.
class BinomialVolumeSession extends ChangeNotifier {
  BinomialDimensions _dimensions = BinomialDimensions.initial;
  double _explosion = 0;
  BinomialBlock? _selected;
  BinomialGuidedStep _step = BinomialGuidedStep.findACubed;
  final Set<BinomialGuidedStep> _found = {};
  bool _sequenceComplete = false;

  BinomialDimensions get dimensions => _dimensions;
  double get explosion => _explosion;
  int get explosionPercentValue => explosionPercent(_explosion);
  BinomialBlock? get selected => _selected;
  BinomialTerm? get selectedTerm => _selected?.term;
  BinomialGuidedStep get step => _step;
  Set<BinomialGuidedStep> get found => Set.unmodifiable(_found);
  bool isFound(BinomialGuidedStep s) => _found.contains(s);

  /// True once the learner has opened the reveal step. Purely a session
  /// flag that unlocks the "what next" choices; it is never recorded.
  bool get sequenceComplete => _sequenceComplete;

  /// True when the current step's target has been found by selecting one of
  /// its pieces (steps 1–4), or always for the reveal step.
  bool get currentStepFound => _step.target == null || _found.contains(_step);

  /// A piece of the current find-step's term is selected right now, so its
  /// matching pieces are visibly outlined. Only then may the UI say "Found
  /// it": a completed step reopened with no selection keeps its tick but
  /// shows the neutral prompt, because nothing is outlined.
  bool get selectionMatchesStep =>
      _selected != null &&
      _step.target != null &&
      _selected!.term == _step.target;

  /// The selected piece does not belong to the current find-step's term.
  bool get selectionMissesStep =>
      _selected != null &&
      _step.target != null &&
      _selected!.term != _step.target;

  /// Term whose pieces the model should highlight: the selected piece's
  /// term (so all matching pieces light up together).
  BinomialTerm? get highlightedTerm => _selected?.term;

  BinomialNumericCheck get numericCheck => BinomialNumericCheck(_dimensions);

  void setExplosion(double value) {
    final next = clampExplosion(value);
    if (next == _explosion) return;
    _explosion = next;
    notifyListeners();
  }

  void setDimensions({int? a, int? b}) {
    final next = BinomialDimensions(
      a: a ?? _dimensions.a,
      b: b ?? _dimensions.b,
    );
    if (next == _dimensions) return;
    _dimensions = next;
    notifyListeners();
  }

  void selectBlock(BinomialBlock block) {
    _selected = block;
    final target = _step.target;
    if (target != null && block.term == target) _found.add(_step);
    notifyListeners();
  }

  /// Selects the first piece of [term] — the keyboard / screen-reader
  /// equivalent of tapping that piece in the model.
  void selectTerm(BinomialTerm term) =>
      selectBlock(BinomialVolumeModel.blocksFor(term).first);

  /// Moves the selection to the next (or previous) piece in index order.
  void cycleSelection({bool forward = true}) {
    const n = 8;
    final current = _selected?.index ?? (forward ? -1 : n);
    final next = (current + (forward ? 1 : -1)) % n;
    selectBlock(BinomialVolumeModel.blocks[next < 0 ? next + n : next]);
  }

  void clearSelection() {
    if (_selected == null) return;
    _selected = null;
    notifyListeners();
  }

  /// Opens [step] (Next step or a step chip). Every step starts neutrally:
  /// the previous selection is cleared, so no "found" or "keep looking"
  /// feedback appears until the learner makes a fresh choice. Re-opening the
  /// current step changes nothing.
  void goToStep(BinomialGuidedStep step) {
    if (step == _step) return;
    _step = step;
    _selected = null;
    if (step == BinomialGuidedStep.revealExpansion) _sequenceComplete = true;
    notifyListeners();
  }

  /// "Reset view": assembled cube, nothing selected. Dimensions and step
  /// progress are kept — the learner is resetting the picture, not the visit.
  void resetView() {
    _explosion = 0;
    _selected = null;
    notifyListeners();
  }

  /// "Explore again": a completely fresh visit.
  void restart() {
    _dimensions = BinomialDimensions.initial;
    _explosion = 0;
    _selected = null;
    _step = BinomialGuidedStep.findACubed;
    _found.clear();
    _sequenceComplete = false;
    notifyListeners();
  }
}
