import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveSession(String email) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("email", email);
}

Future<String?> getSession() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("email");
}

Future<void> clearSession() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove("email");
}
