import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:rdc_concrete/screens/languagecontroller.dart';
import 'package:rdc_concrete/screens/select_profile.dart';
import 'package:rdc_concrete/src/generated/l10n/app_localizations.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>(); // Global instance
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Register the LanguageController
  Get.put(LanguageController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RDC Concrete',
      theme: ThemeData(
        primaryColor: const Color(0xFF0EB154),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      // supportedLocales: [
      //   Locale('en', ''), // English
      //   Locale('hi', ''), // Hindi
      //   Locale('gu', ''), // Gujarati
      // ],
      // localizationsDelegates: [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      //   AppLocalizations.delegate, // Add the generated delegate
      // ], // Default to English
      navigatorObservers: [routeObserver],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SelectProfile(), // Set home screen  // Your home page

    );
  }
}
