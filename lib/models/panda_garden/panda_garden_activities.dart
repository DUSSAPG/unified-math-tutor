/// The Panda Garden activities that live inside the Early Maths Playground,
/// with their learning claims kept separate and explicit.
///
/// Both activities share the same original Panda Garden visual system
/// (Panda, the bowl, the garden backdrop, the 2.5D painters), but each owns
/// its own, narrow learning contract. Neither is mapped to the Topic Hub or
/// to any formal curriculum coverage; a curriculum binding needs separate
/// approval.
enum PandaGardenActivityId { feedTheHungryPanda, pandaPortions }

class PandaGardenActivity {
  const PandaGardenActivity({
    required this.id,
    required this.route,
    required this.claims,
    required this.notClaimed,
  });

  final PandaGardenActivityId id;

  /// Route under the Early Maths Playground.
  final String route;

  /// What the activity is designed to practise (internal, not shown).
  final List<String> claims;

  /// What it deliberately does not claim.
  final List<String> notClaimed;

  /// Whether the activity declares any formal curriculum / Topic Hub
  /// coverage. False for every Panda Garden activity in V1.
  bool get claimsCurriculumCoverage => false;
}

class PandaGardenActivities {
  PandaGardenActivities._();

  static const String playgroundRoute =
      '/math-studio/interactive-labs/early-maths-playground';

  static const feedTheHungryPanda = PandaGardenActivity(
    id: PandaGardenActivityId.feedTheHungryPanda,
    route: '$playgroundRoute/feed-the-hungry-panda',
    claims: [
      'Counting whole apples within 5.',
      'Giving Panda a target of 1 to 3 whole apples.',
      'Answering how many apples are left (5 minus the target).',
    ],
    notClaimed: [
      'Fractions, ratio or percentages.',
      'Topic Hub or formal curriculum coverage.',
      'Mastery, scores, streaks or timed challenge.',
    ],
  );

  static const pandaPortions = PandaGardenActivity(
    id: PandaGardenActivityId.pandaPortions,
    route: '$playgroundRoute/panda-portions',
    claims: [
      'Recognising equal and unequal parts of one whole apple.',
      'Feeding one half (1 of 2 equal parts) and naming what is left.',
      'Feeding one quarter (1 of 4 equal parts) and naming what is left.',
    ],
    notClaimed: [
      'KS2 or any formal curriculum coverage or Topic Hub mapping.',
      'Mastery, readiness, year-group placement or assessment scores.',
      'Fractions beyond unit halves and quarters of one whole.',
    ],
  );

  static const all = [feedTheHungryPanda, pandaPortions];
}
