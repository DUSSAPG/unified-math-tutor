import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/fractions_of_a_set/fractions_of_a_set_session.dart';
import 'package:unified_math_tutor/models/panda_portions/panda_portions_content.dart';

/// Standing guard (brief §8 group 7): Fractions of a Set works with a
/// collection of separate counters shared into equal groups, Panda Portions
/// stays one whole apple in equal parts, halves and quarters, and the new
/// activity shares no code with Panda, Create the Angle or Pitch
/// Coordinates. Read-only: these tests only read source files.
void main() {
  const newSources = [
    'lib/models/fractions_of_a_set/fractions_of_a_set_session.dart',
    'lib/widgets/labs/fractions_of_a_set/fractions_of_a_set_trays.dart',
    'lib/widgets/labs/fractions_of_a_set/fractions_of_a_set_bar.dart',
    'lib/screens/labs/fractions_of_a_set/fractions_of_a_set_screen.dart',
  ];
  const otherDirs = [
    'lib/models/panda_portions',
    'lib/screens/labs/panda_portions',
    'lib/widgets/labs/panda_portions',
    'lib/screens/labs/feed_panda',
    'lib/models/create_angle',
    'lib/screens/labs/create_angle',
    'lib/widgets/labs/create_angle',
    'lib/models/pitch_coordinates',
    'lib/screens/labs/pitch_coordinates',
    'lib/widgets/labs/pitch_coordinates',
  ];
  String read(String p) => File(p).readAsStringSync();

  test('the new sources import nothing from the other activities', () {
    final banned = RegExp(
        r'''import\s+['"][^'"]*(panda_portions|feed_panda|create_angle|pitch_coordinates)/''');
    for (final p in newSources) {
      expect(banned.hasMatch(read(p)), isFalse, reason: p);
    }
  });

  test('no other activity refers to Fractions of a Set', () {
    final marker = RegExp(r'fractions_of_a_set|FractionsOfASet|Fos[A-Z]');
    for (final dir in otherDirs) {
      final d = Directory(dir);
      if (!d.existsSync()) continue;
      for (final f in d.listSync(recursive: true).whereType<File>()) {
        expect(marker.hasMatch(f.readAsStringSync()), isFalse, reason: f.path);
      }
    }
  });

  test('Panda Portions lessons are exactly equalParts, halves, quarters', () {
    expect(PortionLessonId.values.map((e) => e.name).toList(),
        ['equalParts', 'halves', 'quarters']);
  });

  test('Fractions of a Set is a set of objects, not one whole', () {
    // Every item shares a collection of at least four counters into at
    // least two equal groups of at least two.
    for (final f in fosFindSpace) {
      expect(f.total, greaterThanOrEqualTo(4));
      expect(f.d, greaterThanOrEqualTo(2));
      expect(f.g, greaterThanOrEqualTo(2));
    }
    // Denominators go beyond halves and quarters.
    expect(fosDenominators, containsAll([3, 5, 6, 8, 10]));
  });

  test(
      'Panda, Create the Angle, Pitch and Binomial files are unchanged '
      'in this working tree', () {
    final git = Process.runSync('git', [
      'status',
      '--porcelain',
      '--',
      ...otherDirs,
      'lib/screens/labs/binomial_volume',
      'lib/models/binomial_volume_model.dart',
      'lib/models/binomial_volume_session.dart',
      'lib/widgets/labs/binomial_volume',
      'lib/screens/labs/early_maths_playground_hub_screen.dart',
    ]);
    if (git.exitCode != 0) {
      markTestSkipped('git is not available here');
      return;
    }
    expect((git.stdout as String).trim(), isEmpty);
  });
}
