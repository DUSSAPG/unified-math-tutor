import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/formula_library_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('formula_catalog.json loads and every entry is well-formed', () async {
    final entries = await FormulaLibraryService.instance.load();

    expect(entries, isNotEmpty);
    for (final entry in entries) {
      expect(entry.id, isNotEmpty);
      expect(entry.category, isNotEmpty);
      expect(entry.title, isNotEmpty);
      expect(entry.formula, isNotEmpty);
      expect(entry.explanation, isNotEmpty);
      expect(entry.example, isNotEmpty);
    }

    final ids = entries.map((e) => e.id).toSet();
    expect(ids.length, entries.length, reason: 'formula ids must be unique');
  });

  test('search matches by title and by category, and respects category filter',
      () async {
    final byTitle = await FormulaLibraryService.instance.search('pythagoras');
    expect(byTitle, isNotEmpty);

    final byCategory =
        await FormulaLibraryService.instance.search('', category: 'Area');
    expect(byCategory, isNotEmpty);
    expect(byCategory.every((e) => e.category == 'Area'), isTrue);
  });
}
