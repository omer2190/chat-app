// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:get_storage/get_storage.dart';

class ThemeService {
  ///Themes

  final lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.blueGrey.shade300,
    appBarTheme: const AppBarTheme(),
    dividerColor: Colors.black12,
  );

  final darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.blue,
    appBarTheme: const AppBarTheme(),
    dividerColor: Colors.white54,
  );

  //final _getStorage = GetStorage();
  final _darkThemeKey = "isDarkTheme";

  void saveThemeData(bool isDarkMode) async {
    SharedPreferences share = await SharedPreferences.getInstance();
    share.setString(_darkThemeKey, isDarkMode.toString());
  }

  void getThemeMode() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    String bb = share.getString(_darkThemeKey).toString();
    if (bb == "true") {
      changeTheme(true);
    } else {
      changeTheme(false);
    }
  }

  void changeTheme(bool bool) {
    if (bool == true) {
      Get.changeThemeMode(ThemeMode.dark);
    } else if (bool == false) {
      Get.changeThemeMode(ThemeMode.light);
    }
  }
}
