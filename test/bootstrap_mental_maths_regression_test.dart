import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/core/bootstrap.dart';
import 'package:unified_math_tutor/models/mental_maths_challenge.dart';
import 'package:unified_math_tutor/services/mental_maths_progress_service.dart';

/// Isolated regression test, in its own file/isolate: [MentalMathsProgressService]
/// was missing from `AppBootstrap`'s `Future.wait` list, so its `late
/// SharedPreferences _prefs` field was never assigned before first use —
/// reproduced live in the running web app as `LateInitializationError: Field
/// '_prefs' has not been initialized.` when Mental Maths Hub rendered.
///
/// Deliberately does NOT call `MentalMathsProgressService.instance.init()`
/// directly — every other test in this suite does exactly that in its own
/// `setUp()`, which is precisely why this bug shipped undetected: manually
/// pre-initializing each service bypasses the real production ordering that
/// `AppBootstrap` enforces. Kept in its own file (not alongside
/// `test/widget_test.dart`'s full-app-boot test) because sharing a test
/// isolate with a `testWidgets` run of the full `UnifiedMathTutorApp` leaves
/// enough pending timers/bindings behind to make a second `AppBootstrap.
/// ensureStarted()` call hang indefinitely — a test-isolation issue, not a
/// production one.
void main() {
  test(
    'MentalMathsProgressService.tierFor does not throw after only the real AppBootstrap path',
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      await AppBootstrap.ensureStarted();

      expect(
        () => MentalMathsProgressService.instance
            .tierFor(MentalMathsCategory.numberBonds),
        returnsNormally,
      );
    },
  );
}
