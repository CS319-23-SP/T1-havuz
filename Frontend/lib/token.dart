import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _tokenKey = 'token';
  static const _roleKey = 'mamannigayeee';
  static const _idKey = 'HeHeHeHaw';

  TokenStorage._();

  static TokenStorage? _instance;

  static TokenStorage getInstance() {
    _instance ??= TokenStorage._(); // Create instance if not exists
    return _instance!;
  }

  static Future<void> saveToken(String token, String role, String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_roleKey, role);
    await prefs.setString(_idKey, id);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<String?> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_idKey);
  }

  static Future<String?> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  static Future<void> deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_roleKey);
    await prefs.remove(_idKey);
  }
}
