import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'pack_registry_service.dart';

class JsonlPackLoader {
  JsonlPackLoader({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  static final instance = JsonlPackLoader();

  final AssetBundle _bundle;

  Future<List<Map<String, dynamic>>> load(PackEntry pack) async {
    final raw = await _bundle.loadString(pack.path);
    final parsed = <Map<String, dynamic>>[];
    final lines = raw.split(RegExp(r'\r?\n'));
    for (var index = 0; index < lines.length; index++) {
      final line = lines[index].trim();
      if (line.isEmpty) continue;
      try {
        final decoded = jsonDecode(line);
        if (decoded is! Map<String, dynamic>) {
          throw const FormatException('JSONL line must be an object.');
        }
        parsed.add(decoded);
      } on FormatException catch (error) {
        throw FormatException(
          '${pack.path}:${index + 1}: invalid JSONL: ${error.message}',
        );
      }
    }
    final expected = pack.count;
    if (expected != null && expected != parsed.length) {
      final message =
          '${pack.path}: registry count $expected does not match ${parsed.length} parsed lines.';
      if (kReleaseMode) throw StateError(message);
      debugPrint(message);
    }
    return parsed;
  }
}
