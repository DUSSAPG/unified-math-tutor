import '../services/continue_learning_destination_resolver.dart';

/// The result of attempting to resume Continue Learning's practice-session
/// checkpoint (see `ContinueLearningService.attemptResumePracticeSession`).
/// A closed, typed outcome — never a thrown exception, never a partially-
/// resolved session standing in for the real one. Whatever future screen
/// wires Continue Learning into visible UI switches on this, rather than on
/// nullability or a caught error.
sealed class ContinueLearningResumeOutcome {
  const ContinueLearningResumeOutcome();
}

/// No checkpoint exists for the current learner scope — nothing to resume,
/// not an error.
class ContinueLearningResumeNone extends ContinueLearningResumeOutcome {
  const ContinueLearningResumeNone();
}

/// A checkpoint existed, resolved successfully, and is ready to reopen —
/// carries the same validated bundle `PracticeScreen(resumeFrom: ...)`
/// already consumes.
class ContinueLearningResumeAvailable extends ContinueLearningResumeOutcome {
  const ContinueLearningResumeAvailable(this.resume);
  final ResolvedPracticeResume resume;
}

/// A checkpoint existed but could not be safely resolved back to real
/// content (e.g. a stable id it references no longer exists in the
/// currently-bundled pack — see `ContinueLearningDestinationResolver`'s own
/// fail-closed contract). The stale checkpoint has already been invalidated
/// (removed) by the time this is returned, so the learner is never shown a
/// dangling "Continue" affordance for content that's gone.
///
/// [defaultMessage] is reference copy for a UI consumer that hasn't wired
/// its own localized string yet — not itself localized, and not meant to be
/// shown verbatim by a production screen once one exists.
class ContinueLearningResumeUnavailable extends ContinueLearningResumeOutcome {
  const ContinueLearningResumeUnavailable();

  static const defaultMessage =
      'This activity is no longer available — start a fresh practice session.';
}
