class NumberLineExample {
  const NumberLineExample({
    required this.id,
    required this.min,
    required this.max,
    required this.step,
    required this.target,
  });

  final String id;
  final num min;
  final num max;
  final num step;
  final num target;

  factory NumberLineExample.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final min = json['min'];
    final max = json['max'];
    final step = json['step'];
    final target = json['target'];
    if (id is! String || id.trim().isEmpty) {
      throw const FormatException(
          'Number line example "id" must be a non-empty string.');
    }
    if (min is! num || max is! num || step is! num || target is! num) {
      throw FormatException(
          'Number line example "$id" min/max/step/target must all be numbers.');
    }
    if (max <= min) {
      throw FormatException(
          'Number line example "$id" max must be greater than min.');
    }
    if (target < min || target > max) {
      throw FormatException(
          'Number line example "$id" target must be within [min, max].');
    }
    return NumberLineExample(
        id: id, min: min, max: max, step: step, target: target);
  }
}
