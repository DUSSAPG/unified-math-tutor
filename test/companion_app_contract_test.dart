import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/models/companion_app.dart';

void main() {
  test('Football Studio contract exposes stable, separate-app metadata', () {
    const companion = CompanionApp.footballStudio;

    expect(companion.id, 'football-studio');
    expect(companion.title, 'Football Studio');
    expect(companion.androidPackageName, 'com.quantumlab.dinopolo');
    expect(companion.availability, CompanionAvailability.checking);
    expect(companion.learningDescription, contains('Coordinates'));
    expect(companion.learningDescription, contains('Algebra'));
    expect(companion.learningDescription, contains('Distance-Time-Speed'));
    expect(
      companion.supportedCurriculumStrands,
      contains('KS3 Algebra: equations'),
    );
    expect(
      companion.supportedCurriculumStrands,
      contains('KS3 Ratio and rates: distance, time and speed'),
    );
    expect(companion.learningDescription, isNot(contains('Moon Renderer')));
    expect(
      companion.progressOwnershipStatement,
      contains('Unified Math Tutor does not read or share them'),
    );
  });

  test('availability updates do not alter companion identity or ownership', () {
    final installed = CompanionApp.footballStudio.withAvailability(
      CompanionAvailability.installed,
    );

    expect(installed.availability, CompanionAvailability.installed);
    expect(installed.id, CompanionApp.footballStudio.id);
    expect(installed.androidPackageName, 'com.quantumlab.dinopolo');
    expect(
      installed.progressOwnershipStatement,
      CompanionApp.footballStudio.progressOwnershipStatement,
    );
  });
}
