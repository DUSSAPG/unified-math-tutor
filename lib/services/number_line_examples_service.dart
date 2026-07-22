import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/number_line_example.dart';

class NumberLineExamplesService {
  NumberLineExamplesService({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  static const assetPath = 'assets/config/number_line_examples.json';
  static final NumberLineExamplesService instance = NumberLineExamplesService();

  final AssetBundle _bundle;
  List<NumberLineExample>? _examples;

  Future<List<NumberLineExample>> all() async {
    final cached = _examples;
    if (cached != null) return cached;

    final decoded = jsonDecode(await _bundle.loadString(assetPath));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Number line examples root must be an object.');
    }
    final examplesValue = decoded['examples'];
    if (examplesValue is! List || examplesValue.isEmpty) {
      throw const FormatException('Number line examples "examples" must be a non-empty list.');
    }
    final examples = examplesValue
        .map((value) => NumberLineExample.fromJson(value as Map<String, dynamic>))
        .toList();
    _examples = List.unmodifiable(examples);
    return _examples!;
  }
}
