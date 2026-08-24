import 'package:flutter_test/flutter_test.dart';
import 'package:unified_math_tutor/services/learner_scope_resolver.dart';

void main() {
  group('LearnerScopeId', () {
    test('deviceGuest is stable and equal across references', () {
      expect(LearnerScopeId.deviceGuest, LearnerScopeId.deviceGuest);
      expect(LearnerScopeId.deviceGuest.value, 'device-guest');
    });

    test('learnerProfile scopes never use a display name', () {
      final scope = LearnerScopeId.learnerProfile('abc123');
      expect(scope.value, 'learner:abc123');
      expect(scope.value.contains('@'), isFalse);
    });

    test('localAccount scopes are distinguishable from learner scopes', () {
      final account = LearnerScopeId.localAccount('tok_1');
      final learner = LearnerScopeId.learnerProfile('tok_1');
      expect(account, isNot(learner));
      expect(account.value, isNot(learner.value));
    });

    test('two different learner ids never resolve to the same scope', () {
      expect(LearnerScopeId.learnerProfile('a'),
          isNot(LearnerScopeId.learnerProfile('b')));
    });

    test('the same learner id always resolves to the same scope', () {
      expect(LearnerScopeId.learnerProfile('a'),
          LearnerScopeId.learnerProfile('a'));
    });
  });

  group('resolveLearnerScope precedence', () {
    test('guest with no role and no account: device guest scope', () {
      final scope = resolveLearnerScope(
        userType: null,
        activeLearnerId: null,
        isSignedInLocally: false,
        localAccountScopeToken: null,
      );
      expect(scope, LearnerScopeId.deviceGuest);
    });

    test('student role, signed out: device guest scope', () {
      final scope = resolveLearnerScope(
        userType: 'student',
        activeLearnerId: null,
        isSignedInLocally: false,
        localAccountScopeToken: null,
      );
      expect(scope, LearnerScopeId.deviceGuest);
    });

    test('signed in locally, no active learner: local account scope', () {
      final scope = resolveLearnerScope(
        userType: 'student',
        activeLearnerId: null,
        isSignedInLocally: true,
        localAccountScopeToken: 'tok_42',
      );
      expect(scope, LearnerScopeId.localAccount('tok_42'));
    });

    test(
        'signed in locally but token not ready yet: falls back to guest '
        'rather than an unstable/empty scope', () {
      final scope = resolveLearnerScope(
        userType: 'student',
        activeLearnerId: null,
        isSignedInLocally: true,
        localAccountScopeToken: null,
      );
      expect(scope, LearnerScopeId.deviceGuest);
    });

    test('parent role with an active learner: learner-profile scope wins', () {
      final scope = resolveLearnerScope(
        userType: 'parent',
        activeLearnerId: 'emily-id',
        isSignedInLocally: false,
        localAccountScopeToken: null,
      );
      expect(scope, LearnerScopeId.learnerProfile('emily-id'));
    });

    test(
        'parent role with an active learner AND signed in: learner-profile '
        'scope still wins — the specific managed learner is more specific '
        'than the account', () {
      final scope = resolveLearnerScope(
        userType: 'parent',
        activeLearnerId: 'emily-id',
        isSignedInLocally: true,
        localAccountScopeToken: 'tok_42',
      );
      expect(scope, LearnerScopeId.learnerProfile('emily-id'));
    });

    test('teacher role behaves the same as parent role', () {
      final scope = resolveLearnerScope(
        userType: 'teacher',
        activeLearnerId: 'class-1-sam',
        isSignedInLocally: false,
        localAccountScopeToken: null,
      );
      expect(scope, LearnerScopeId.learnerProfile('class-1-sam'));
    });

    test(
        'parent role with no active learner yet: falls through to account/guest',
        () {
      final scope = resolveLearnerScope(
        userType: 'parent',
        activeLearnerId: null,
        isSignedInLocally: false,
        localAccountScopeToken: null,
      );
      expect(scope, LearnerScopeId.deviceGuest);
    });

    test('whitespace-only activeLearnerId is treated as absent', () {
      final scope = resolveLearnerScope(
        userType: 'parent',
        activeLearnerId: '   ',
        isSignedInLocally: true,
        localAccountScopeToken: 'tok_42',
      );
      expect(scope, LearnerScopeId.localAccount('tok_42'));
    });

    test('switching the active learner id changes the resolved scope', () {
      final first = resolveLearnerScope(
        userType: 'parent',
        activeLearnerId: 'sam-id',
        isSignedInLocally: false,
        localAccountScopeToken: null,
      );
      final second = resolveLearnerScope(
        userType: 'parent',
        activeLearnerId: 'emily-id',
        isSignedInLocally: false,
        localAccountScopeToken: null,
      );
      expect(first, isNot(second));
    });
  });
}
