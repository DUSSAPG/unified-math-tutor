import 'dart:convert';

import 'package:flutter/services.dart';

class FormulaVariable {
  const FormulaVariable({required this.symbol, required this.meaning});

  final String symbol;
  final String meaning;

  factory FormulaVariable.fromJson(Map<String, dynamic> json) {
    final symbol = json['symbol'];
    final meaning = json['meaning'];
    if (symbol is! String || symbol.trim().isEmpty) {
      throw const FormatException(
          'Formula variable "symbol" must be a string.');
    }
    if (meaning is! String || meaning.trim().isEmpty) {
      throw const FormatException(
          'Formula variable "meaning" must be a string.');
    }
    return FormulaVariable(symbol: symbol, meaning: meaning);
  }
}

class FormulaEntry {
  const FormulaEntry({
    required this.id,
    required this.category,
    required this.title,
    required this.formula,
    required this.meaning,
    required this.variables,
    required this.explanation,
    required this.example,
    this.diagramAssetId,
  });

  final String id;
  final String category;
  final String title;
  final String formula;
  final String meaning;
  final List<FormulaVariable> variables;
  final String explanation;
  final String example;

  /// Optional [VisualAsset.id] rendered above the explanation when set —
  /// most entries have none and render exactly as before. Part of the
  /// Visual Asset System's Formula Library integration.
  final String? diagramAssetId;

  factory FormulaEntry.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final category = json['category'];
    final title = json['title'];
    final formula = json['formula'];
    final meaning = json['meaning'];
    final explanation = json['explanation'];
    final example = json['example'];
    if (id is! String || id.trim().isEmpty) {
      throw const FormatException(
          'Formula catalog entry "id" must be a string.');
    }
    if (category is! String || category.trim().isEmpty) {
      throw FormatException('Formula catalog "$id" is missing a category.');
    }
    if (title is! String || title.trim().isEmpty) {
      throw FormatException('Formula catalog "$id" is missing a title.');
    }
    if (formula is! String || formula.trim().isEmpty) {
      throw FormatException('Formula catalog "$id" is missing a formula.');
    }
    if (meaning is! String) {
      throw FormatException(
          'Formula catalog "$id" "meaning" must be a string.');
    }
    if (explanation is! String) {
      throw FormatException(
          'Formula catalog "$id" "explanation" must be a string.');
    }
    if (example is! String) {
      throw FormatException(
          'Formula catalog "$id" "example" must be a string.');
    }
    final variablesValue = json['variables'];
    if (variablesValue is! List) {
      throw FormatException(
          'Formula catalog "$id" "variables" must be a list.');
    }
    final diagramAssetIdValue = json['diagramAssetId'];
    if (diagramAssetIdValue != null && diagramAssetIdValue is! String) {
      throw FormatException(
          'Formula catalog "$id" "diagramAssetId" must be a string if present.');
    }
    return FormulaEntry(
      id: id,
      category: category,
      title: title,
      formula: formula,
      meaning: meaning,
      variables: variablesValue
          .cast<Map<String, dynamic>>()
          .map(FormulaVariable.fromJson)
          .toList(),
      explanation: explanation,
      example: example,
      diagramAssetId: diagramAssetIdValue as String?,
    );
  }

  /// True if [query] matches this formula's title, category, or formula text.
  bool matches(String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();
    return title.toLowerCase().contains(q) ||
        category.toLowerCase().contains(q) ||
        formula.toLowerCase().contains(q);
  }
}

/// Offline, JSON-backed formula reference library. English only for v1 —
/// deliberately does not depend on locale, unlike TopicCatalogService.
class FormulaLibraryService {
  FormulaLibraryService({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  static const assetPath = 'assets/config/formula_catalog.json';
  static final FormulaLibraryService instance = FormulaLibraryService();

  final AssetBundle _bundle;
  List<FormulaEntry>? _entries;

  Future<List<FormulaEntry>> load() async {
    final cached = _entries;
    if (cached != null) return cached;

    final decoded = jsonDecode(await _bundle.loadString(assetPath));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Formula catalog root must be an object.');
    }
    if (decoded['version'] is! int) {
      throw const FormatException(
          'Formula catalog "version" must be an integer.');
    }
    final formulas = decoded['formulas'];
    if (formulas is! List || formulas.isEmpty) {
      throw const FormatException('Formula catalog "formulas" must be a list.');
    }

    final entries = formulas
        .cast<Map<String, dynamic>>()
        .map(FormulaEntry.fromJson)
        .toList(growable: false);
    _entries = entries;
    return entries;
  }

  Future<List<String>> categories() async {
    final entries = await load();
    return entries.map((e) => e.category).toSet().toList(growable: false);
  }

  Future<List<FormulaEntry>> search(String query, {String? category}) async {
    final entries = await load();
    return entries
        .where((e) =>
            (category == null || e.category == category) && e.matches(query))
        .toList(growable: false);
  }
}
