/// Recall Card scheduler state exposed to UI and to a future ALI
/// recommendation engine. Wire/storage id is snake_case per the product
/// contract; the Dart enum member names avoid the `new` keyword.
enum RecallCardState {
  newCard('new'),
  learning('learning'),
  reviewDue('review_due'),
  mastered('mastered');

  const RecallCardState(this.id);

  final String id;

  static RecallCardState fromId(String id) {
    for (final value in RecallCardState.values) {
      if (value.id == id) return value;
    }
    throw FormatException('Unknown recall card state "$id".');
  }
}
