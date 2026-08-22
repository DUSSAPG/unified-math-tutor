import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/canonical_identity_resolver.dart';

void main() {
  group('isLearnerFacingRole', () {
    test('true only for parent and teacher', () {
      expect(isLearnerFacingRole('parent'), isTrue);
      expect(isLearnerFacingRole('teacher'), isTrue);
      expect(isLearnerFacingRole('student'), isFalse);
      expect(isLearnerFacingRole(null), isFalse);
      expect(isLearnerFacingRole(''), isFalse);
      expect(isLearnerFacingRole('Parent'),
          isFalse); // case-sensitive, matches userType's raw contract
    });
  });

  group('resolveLearnerFacingName — learner role (student / unset)', () {
    test('uses the preferred display name when set', () {
      expect(
        resolveLearnerFacingName(
          userType: 'student',
          preferredDisplayName: 'Gerald',
          activeLearnerName: null,
          legacyChildName: null,
        ),
        'Gerald',
      );
    });

    test('falls back to null (neutral greeting) when no name exists', () {
      expect(
        resolveLearnerFacingName(
          userType: 'student',
          preferredDisplayName: null,
          activeLearnerName: null,
          legacyChildName: null,
        ),
        isNull,
      );
    });

    test('treats a whitespace-only preferred name as absent', () {
      expect(
        resolveLearnerFacingName(
          userType: 'student',
          preferredDisplayName: '   ',
          activeLearnerName: null,
          legacyChildName: null,
        ),
        isNull,
      );
    });

    test('trims surrounding whitespace', () {
      expect(
        resolveLearnerFacingName(
          userType: 'student',
          preferredDisplayName: '  Gerald  ',
          activeLearnerName: null,
          legacyChildName: null,
        ),
        'Gerald',
      );
    });

    test('supports Unicode names', () {
      expect(
        resolveLearnerFacingName(
          userType: 'student',
          preferredDisplayName: '田中太郎',
          activeLearnerName: null,
          legacyChildName: null,
        ),
        '田中太郎',
      );
    });

    test('supports right-to-left names', () {
      expect(
        resolveLearnerFacingName(
          userType: 'student',
          preferredDisplayName: 'محمد',
          activeLearnerName: null,
          legacyChildName: null,
        ),
        'محمد',
      );
    });

    test('supports apostrophes and hyphens', () {
      expect(
        resolveLearnerFacingName(
          userType: 'student',
          preferredDisplayName: "Anne-Marie O'Brien",
          activeLearnerName: null,
          legacyChildName: null,
        ),
        "Anne-Marie O'Brien",
      );
    });

    test('ignores activeLearnerName/legacyChildName entirely', () {
      // A learner-role user's own preferred name always wins — an active
      // learner profile only matters for parent/teacher roles.
      expect(
        resolveLearnerFacingName(
          userType: 'student',
          preferredDisplayName: null,
          activeLearnerName: 'SomeChild',
          legacyChildName: 'SomeChild',
        ),
        isNull,
      );
    });

    test('null userType (role not yet chosen) behaves as learner role', () {
      expect(
        resolveLearnerFacingName(
          userType: null,
          preferredDisplayName: 'Gerald',
          activeLearnerName: 'Ignored',
          legacyChildName: 'Ignored',
        ),
        'Gerald',
      );
    });
  });

  group('resolveLearnerFacingName — parent/teacher role', () {
    for (final role in ['parent', 'teacher']) {
      test('[$role] prefers the active learner name over legacy childName', () {
        expect(
          resolveLearnerFacingName(
            userType: role,
            preferredDisplayName: 'AccountHolderName',
            activeLearnerName: 'Emily',
            legacyChildName: 'Sam',
          ),
          'Emily',
        );
      });

      test('[$role] falls back to legacy childName when no active learner', () {
        expect(
          resolveLearnerFacingName(
            userType: role,
            preferredDisplayName: 'AccountHolderName',
            activeLearnerName: null,
            legacyChildName: 'Sam',
          ),
          'Sam',
        );
      });

      test('[$role] falls back to neutral (null) when neither is set', () {
        expect(
          resolveLearnerFacingName(
            userType: role,
            preferredDisplayName: 'AccountHolderName',
            activeLearnerName: null,
            legacyChildName: null,
          ),
          isNull,
        );
      });

      test('[$role] never uses the account holder\'s own preferred name', () {
        final result = resolveLearnerFacingName(
          userType: role,
          preferredDisplayName: 'AccountHolderName',
          activeLearnerName: null,
          legacyChildName: null,
        );
        expect(result, isNot('AccountHolderName'));
      });

      test('[$role] whitespace-only active learner name falls back to legacy',
          () {
        expect(
          resolveLearnerFacingName(
            userType: role,
            preferredDisplayName: null,
            activeLearnerName: '   ',
            legacyChildName: 'Sam',
          ),
          'Sam',
        );
      });
    }
  });

  group('email is never a valid input to begin with', () {
    // This resolver has no email/account parameter at all — the type
    // signature itself is the regression guard. This test exists to make
    // that guarantee explicit and discoverable in the test suite: an
    // account email or its prefix can never reach the learner-facing name
    // because there is no code path here that accepts one.
    test('resolver signature has no email/account-metadata parameter', () {
      final result = resolveLearnerFacingName(
        userType: 'student',
        preferredDisplayName:
            'gerald', // deliberately looks like an email prefix
        activeLearnerName: null,
        legacyChildName: null,
      );
      // A genuinely-entered preferred name that happens to look like an
      // email prefix is still valid — the point is there is no separate
      // email-derived fallback path feeding this function at all.
      expect(result, 'gerald');
    });
  });
}
