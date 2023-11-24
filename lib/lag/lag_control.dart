import 'dart:ui';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageControl extends GetxController {
  //final PrefService _prefService = PrefService();

  var savedLang = "en".obs;

  saveLocale() async {
    SharedPreferences prefService = await SharedPreferences.getInstance();
    prefService.setString("locale", savedLang.value);
  }

  Future<void> setLocalee() async {
    SharedPreferences prefService = await SharedPreferences.getInstance();
    var value = prefService.getString('locale');
    //print(value);
    if (value != "" && value != null) {
      Get.updateLocale(Locale(value.toString().toLowerCase()));
      savedLang.value = value.toString();
      update();
    }
  }

  @override
  void onInit() async {
    setLocalee();
    super.onInit();
  }
}
