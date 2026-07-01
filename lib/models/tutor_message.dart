enum TutorMessageRole { user, bot }

class TutorMessage {
  final TutorMessageRole role;
  final String text;

  const TutorMessage({required this.role, required this.text});
}
