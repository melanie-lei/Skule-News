import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class MyAccountController extends GetxController {
  RxBool darkMode = false.obs;

  setCurrentMode() async {
    darkMode.value = await SharedPrefs().isDarkMode();
    update();
  }

  setDarkMode(bool value) {
    Get.changeThemeMode(
      value ? ThemeMode.dark : ThemeMode.light,
    );

    AppThemeSetting.setDisplayMode(
        value == true ? DisplayMode.dark : DisplayMode.light);
    SharedPrefs().setDarkMode(value);
    darkMode.value = value;
    update();
  }


}
