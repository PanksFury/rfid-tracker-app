import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'firebase_options.dart';
import 'splash_screen/splash_view.dart';
import 'utility/colors_constant.dart';

void main() async {
  await GetStorage.init();

  ErrorWidget.builder = (FlutterErrorDetails details) {
    bool inDebug = false;
    assert(() {
      inDebug = true;
      return true;
    }());
    // In debug mode, use the normal error widget which shows
    // the error message:
    if (inDebug) {
      return ErrorWidget(details.exception);
    }
    // In release builds, show a yellow-on-blue message instead:
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Error! ${details.exception}',
        style: const TextStyle(color: Colors.yellow),
        textDirection: TextDirection.ltr,
      ),
    );
  };

  setupFirebase();
  runApp(const MyApp());

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
}

void setupFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Mirafical Infra RFID Tracking",
      theme: _customThemeData(),
      home: SplashView(),
    );
  }

  ThemeData _customThemeData() {
    return ThemeData(
      primaryColor: ColorsConstant.primary,
      backgroundColor: Colors.white,
      splashColor: ColorsConstant.primary,
      textTheme: const TextTheme(
        titleLarge: TextStyle(
            fontFamily: "Inter", fontSize: 25, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(
            fontFamily: "Inter", fontSize: 22, fontWeight: FontWeight.bold),
        titleSmall: TextStyle(
            fontFamily: "Inter", fontSize: 18, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(fontFamily: "Inter", fontSize: 24),
        bodyMedium: TextStyle(fontFamily: "Inter", fontSize: 20),
        bodySmall: TextStyle(fontFamily: "Inter", fontSize: 16),
      ),
    );
  }
}
