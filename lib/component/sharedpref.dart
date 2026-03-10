import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPref? _instance;
  static SharedPreferences? _prefs;

  // Private constructor
  SharedPref._();

  // Singleton pattern to get the instance
  static Future<SharedPref> getInstance() async {
    if (_instance == null) {
      _instance = SharedPref._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  // Method to store user information
  Future<void> storeUser(String profileName, String id) async {
    await _prefs?.setString('profileName', profileName);
    await _prefs?.setString('userId', id);
  }

  // Add other methods as needed
}
