/* RENAME TO common_config.dart */

import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';

class CommonConfig {
  static String schoolName = "".tr();
  static Color primaryColor = const Color(0xff3E6553);
  static Color buttonTextColor = const Color(0xffffffff);

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
