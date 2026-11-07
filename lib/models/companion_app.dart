enum CompanionAvailability {
  checking,
  installed,
  notInstalled,
  unsupported,
  checkFailed,
}

class CompanionApp {
  const CompanionApp({
    required this.id,
    required this.title,
    required this.learningDescription,
    required this.supportedCurriculumStrands,
    required this.androidPackageName,
    required this.availability,
    required this.progressOwnershipStatement,
  });

  static const footballStudio = CompanionApp(
    id: 'football-studio',
    title: 'Football Studio',
    learningDescription:
        'Interactive activities cover Coordinates, Ratio & Scale, Angles, '
        'Distance-Time-Speed, Area, and Algebra.',
    supportedCurriculumStrands: [
      'KS2 Geometry: position and direction',
      'KS3 Ratio, proportion and rates of change',
      'KS3 Ratio and rates: distance, time and speed',
      'KS3 Geometry and measures: angles and area',
      'KS3 Algebra: equations',
    ],
    androidPackageName: 'com.quantumlab.dinopolo',
    availability: CompanionAvailability.checking,
    progressOwnershipStatement:
        'Achievements and progress stay on this device in Football Studio '
        'for V1. Unified Math Tutor does not read or share them.',
  );

  final String id;
  final String title;
  final String learningDescription;
  final List<String> supportedCurriculumStrands;
  final String androidPackageName;
  final CompanionAvailability availability;
  final String progressOwnershipStatement;

  CompanionApp withAvailability(CompanionAvailability value) => CompanionApp(
        id: id,
        title: title,
        learningDescription: learningDescription,
        supportedCurriculumStrands: supportedCurriculumStrands,
        androidPackageName: androidPackageName,
        availability: value,
        progressOwnershipStatement: progressOwnershipStatement,
      );
}
