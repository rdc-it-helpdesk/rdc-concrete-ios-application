import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangeController with ChangeNotifier {
  Locale? _appLocale;

  Locale? get appLocale => _appLocale;

  void changeLanguage(Locale type) async {
    //print("Changing language to: ${type.languageCode}"); // Debug print
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (type == Locale('en')) {
      await sp.setString('Languagecode', 'en');
    } else if (type == Locale('guj')) {
      await sp.setString('Languagecode', 'guj');
    } else {
      await sp.setString('Languagecode', 'es');
    }
    _appLocale = type; // Update the app locale
    notifyListeners(); // Notify listeners to rebuild the UI
  }
}
