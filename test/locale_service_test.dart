import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unified_math_tutor/services/locale_service.dart';

void main() {
  test('production selector exposes only neutral English, UK and Switzerland',
      () {
    expect(LocaleService.productionLocales, const [
      Locale('en'),
      Locale('en', 'GB'),
      Locale('de', 'CH'),
      Locale('fr', 'CH'),
      Locale('it', 'CH'),
    ]);
    expect(LocaleService.supported.take(2), const [
      Locale('en'),
      Locale('en', 'GB'),
    ]);
    expect(LocaleService.supported, contains(const Locale('sv', 'SE')));
    expect(LocaleService.supported, contains(const Locale('nb', 'NO')));
    expect(LocaleService.supported, contains(const Locale('da', 'DK')));
    expect(LocaleService.supported, contains(const Locale('sv')));
    expect(LocaleService.supported, contains(const Locale('da')));
    expect(LocaleService.supported, contains(const Locale('nb')));
    expect(LocaleService.supported, contains(const Locale('es')));
    expect(LocaleService.supported, contains(const Locale('pt')));
    expect(LocaleService.supported, contains(const Locale('id')));
    expect(LocaleService.selectable, LocaleService.productionLocales);
  });

  test('neutral English persists without a null country suffix', () async {
    SharedPreferences.setMockInitialValues({});
    await LocaleService.instance.init();
    await LocaleService.instance.setLocale(const Locale('en'));
    expect(
      (await SharedPreferences.getInstance()).getString('locale'),
      'en',
    );

    await LocaleService.instance.init();
    expect(LocaleService.instance.current, const Locale('en'));
  });

  test('resolves regional device English to neutral English except UK', () {
    expect(
      LocaleService.resolveDeviceLocale(
        const Locale('en', 'US'),
        LocaleService.supported,
      ),
      const Locale('en'),
    );
    expect(
      LocaleService.resolveDeviceLocale(
        const Locale('en', 'SG'),
        LocaleService.supported,
      ),
      const Locale('en'),
    );
    expect(
      LocaleService.resolveDeviceLocale(
        const Locale('en', 'GB'),
        LocaleService.supported,
      ),
      const Locale('en', 'GB'),
    );
  });

  test('unsupported locale selection falls back to neutral English', () async {
    SharedPreferences.setMockInitialValues({});
    await LocaleService.instance.init();
    await LocaleService.instance.setLocale(const Locale('ja', 'JP'));
    expect(LocaleService.instance.current, const Locale('en'));
  });
}
