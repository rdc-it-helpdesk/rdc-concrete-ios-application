import 'dart:ui';

import 'package:get/get.dart';

class LanguageController extends GetxController {
  // This method updates the app's locale
  void updateLanguage(String langCode) {
    Locale locale = Locale(langCode);
    Get.updateLocale(locale);
  }
}
