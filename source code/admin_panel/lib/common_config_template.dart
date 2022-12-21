/* RENAME TO common_config.dart */

import 'package:flutter/material.dart';
import 'helper/common_import.dart';

class CommonConfig {
  static String schoolName = "".tr();
  static Color primaryColor = const Color(0xffdbc1c1);
  static Color buttonTextColor = const Color(0xff1c1c1c);

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
