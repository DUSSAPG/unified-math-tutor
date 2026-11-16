import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Standing guard (contract §12): Create the Angle stays an angle-only
/// activity with no coordinate grid, and the two activities share no code.
/// Read-only: these tests only read source files.
void main() {
  const angleSources = [
    'lib/models/create_angle/create_angle_session.dart',
    'lib/widgets/labs/create_angle/create_angle_pitch_painter.dart',
    'lib/screens/labs/create_angle/create_angle_screen.dart',
  ];
  const pitchSources = [
    'lib/models/pitch_coordinates/pitch_coordinates_session.dart',
    'lib/widgets/labs/pitch_coordinates/pitch_coordinates_grid_painter.dart',
    'lib/screens/labs/pitch_coordinates/pitch_coordinates_screen.dart',
  ];
  String read(String p) => File(p).readAsStringSync();

  test('Create the Angle model and painter draw no grid, axes or coordinates',
      () {
    final coord = RegExp(
        r'grid|coordinat|\baxis\b|\baxes\b|ordered ?pair|translat',
        caseSensitive: false);
    for (final p in angleSources.take(2)) {
      expect(coord.hasMatch(read(p)), isFalse, reason: p);
    }
  });

  test("Create the Angle screen: only Flutter layout 'axis' identifiers", () {
    final hits = RegExp(r'\w*(grid|coordinat|axis|axes|translat)\w*',
            caseSensitive: false)
        .allMatches(read(angleSources[2]))
        .map((m) => m[0]!)
        .toSet();
    expect(
        hits.difference({
          'crossAxisAlignment',
          'CrossAxisAlignment',
          'mainAxisAlignment',
          'MainAxisAlignment',
          'mainAxisSize',
          'MainAxisSize',
        }),
        isEmpty);
  });

  test('Create the Angle is still an angle model (0-180 degrees, tolerance)',
      () {
    final model = read(angleSources.first);
    expect(model, contains('180'));
    expect(model.toLowerCase(), contains('tolerance'));
    expect(model, contains('includedAngle'));
  });

  test('neither activity imports the other', () {
    for (final p in pitchSources) {
      expect(read(p).contains('create_angle'), isFalse, reason: p);
    }
    for (final p in angleSources) {
      expect(
          RegExp('pitch_coordinates|PitchCoordinates|PitchGrid')
              .hasMatch(read(p)),
          isFalse,
          reason: p);
    }
  });
}
