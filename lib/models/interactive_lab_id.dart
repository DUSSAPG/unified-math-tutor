/// The fixed RC1 Interactive Labs roster. New labs are an additive enum +
/// route change, never a schema change — mirrors [RecallTopic]/
/// [RecallCardType]'s closed-enum convention.
enum InteractiveLabId {
  fractionBuilder,
  algebraBalance,
  numberLineExplorer,
  flightPathLab,
  dataDetective;

  static InteractiveLabId fromId(String id) {
    for (final value in InteractiveLabId.values) {
      if (value.name == id) return value;
    }
    throw FormatException('Unknown interactive lab id "$id".');
  }
}
