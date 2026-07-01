class TutorUsageModel {
  static const int guestTipLimit = 3;

  final bool isPaid;
  final int tipsUsed;
  final int credits;

  const TutorUsageModel({
    required this.isPaid,
    required this.tipsUsed,
    required this.credits,
  });

  bool get tipsExhausted => !isPaid && tipsUsed >= guestTipLimit;
  int get tipsLeft => (guestTipLimit - tipsUsed).clamp(0, guestTipLimit);
  bool get hasCredits => credits > 0;

  TutorUsageModel copyWith({bool? isPaid, int? tipsUsed, int? credits}) =>
      TutorUsageModel(
        isPaid: isPaid ?? this.isPaid,
        tipsUsed: tipsUsed ?? this.tipsUsed,
        credits: credits ?? this.credits,
      );
}
