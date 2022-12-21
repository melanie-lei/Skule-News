/* RENAME TO common_config.dart */

import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';

class CommonConfig {
  static String schoolName = "".tr();
  static Color primaryColor = const Color(0xff3E6553);
  static Color buttonTextColor = const Color(0xffffffff);

  // Firebase app config.
  static String apiKey = "";
  static String authDomain = "";
  static String projectId = "";
  static String storageBucket = "";
  static String messagingSenderId = "";
  static String appId = "";
  static String measurementId = "";

  static FirebaseOptions options = const FirebaseOptions(
    apiKey: "",
    authDomain: "",
    projectId: "",
    storageBucket: "",
    messagingSenderId: "",
    appId: "",
    measurementId: ""
  );
}