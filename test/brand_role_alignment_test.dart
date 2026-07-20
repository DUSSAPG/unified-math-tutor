import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/l10n/app_localizations.dart';
import 'package:unified_math_tutor/screens/onboarding/user_type_screen.dart';
import 'package:unified_math_tutor/services/locale_service.dart';
import 'package:unified_math_tutor/services/onboarding_profile_service.dart';

void main() {
  const configuredLocaleFiles = [
    'app_en.arb',
    'app_fr_CH.arb',
    'app_de_CH.arb',
    'app_it_CH.arb',
    'app_sv.arb',
    'app_da.arb',
    'app_nb.arb',
    'app_es.arb',
    'app_pt.arb',
    'app_id.arb',
  ];

  const requiredBrandAndRoleKeys = [
    'onboardingProductName',
    'onboardingTechBadge',
    'onboardingHeroStatement',
    'onboardingSupportingStatement',
    'onboardingStudentLabel',
    'onboardingStudentSub',
    'onboardingParentLabel',
    'onboardingParentSub',
    'onboardingRoleClarification',
    'learningAnalyticsTitle',
    'learningAnalyticsSummary',
    'learningAnalyticsEmptyState',
  ];

  test('configured locales include complete brand and role alignment keys', () {
    for (final fileName in configuredLocaleFiles) {
      final file = File('lib/l10n/$fileName');
      final arb = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;

      for (final key in requiredBrandAndRoleKeys) {
        expect(
          arb[key],
          isA<String>()
              .having((value) => value.trim(), 'trimmed value', isNotEmpty)
              .having((value) => value.contains('...'), 'no ellipsis', isFalse)
              .having(
                (value) => value.contains('?'),
                'no replacement question marks',
                isFalse,
              ),
          reason: '$fileName must define $key with complete production copy',
        );
      }
    }
  });

  testWidgets('welcome screen renders Math Intelligence hierarchy and roles',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    await LocaleService.instance.init();
    await OnboardingProfileService.instance.init();

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const UserTypeScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Math Intelligence'), findsOneWidget);
    expect(
        find.text('Powered by Adaptive Learning Intelligence'), findsOneWidget);
    expect(
      find.text('Develop mathematical thinking.\nUnlock your potential.'),
      findsOneWidget,
    );
    expect(find.text("I'm a Learner"), findsOneWidget);
    expect(find.text("I'm supporting a learner"), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);

    final headline = tester.widget<Text>(find.text('Math Intelligence'));
    expect(headline.style?.color, Colors.white);
  });
}
