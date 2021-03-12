import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

import 'package:player/settings.dart';

void main() {
  test('get defaults', () async {
    SharedPreferences.setMockInitialValues({});
    await AppSettings().init();

    expect(AppSettings().baseUrl, contains('mock.your-concerto.com'));
    expect(AppSettings().screenId, 1);
  });

  test('setters', () async {
    SharedPreferences.setMockInitialValues({});
    await AppSettings().init();

    AppSettings().baseUrl = 'http://new-server';
    AppSettings().screenId = 99;

    expect(AppSettings().baseUrl, contains('http://new-server'));
    expect(AppSettings().screenId, 99);
  });
}
