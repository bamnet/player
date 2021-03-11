import 'package:shared_preferences/shared_preferences.dart';

const defaultBaseUrl = "http://mock.your-concerto.com";
const defaultScreenId = 1;

const keyBaseUrl = 'base_url';
const keyScreenId = '';

class AppSettings {
  static SharedPreferences _sharedPreferences;

  factory AppSettings() => AppSettings._internal();

  AppSettings._internal();

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  String get baseUrl =>
      _sharedPreferences.getString(keyBaseUrl) ?? defaultBaseUrl;

  set baseUrl(String value) {
    _sharedPreferences.setString(keyBaseUrl, value);
  }

  int get screenId => _sharedPreferences.getInt(keyScreenId) ?? defaultScreenId;

  set screenId(int value) {
    _sharedPreferences.setInt(keyScreenId, value);
  }
}
