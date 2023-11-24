import 'package:chat_app/src/Sign_in.dart';
import 'package:chat_app/src/ThemeService.dart';
import 'package:chat_app/src/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'lag/lag.dart';
import 'lag/lag_control.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ThemeService().getThemeMode();
  await LanguageControl().setLocalee();
  //getLog();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _aoth = FirebaseAuth.instance;
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeService().lightTheme,
        darkTheme: ThemeService().darkTheme,
        translations: Translation(),
        locale: const Locale('ar'),
        fallbackLocale: const Locale('en'),
        title: 'Chat App',
        home: _aoth.currentUser != null ? const Home() : const SignIn());
  }
}
