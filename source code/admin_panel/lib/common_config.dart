import 'package:flutter/material.dart';
import 'helper/common_import.dart';

class CommonConfig {
  static String schoolName = "".tr();
  static Color primaryColor = const Color(0xffdbc1c1);
  static Color buttonTextColor = const Color(0xff1c1c1c);

  static FirebaseOptions options = const FirebaseOptions(
      apiKey: "AIzaSyC7C-de4bewAn2W7I8p9cIB3Q_y7Cef0Sc",
      authDomain: "skule-news.firebaseapp.com",
      databaseURL: "https://skule-news-default-rtdb.firebaseio.com",
      projectId: "skule-news",
      storageBucket: "skule-news.appspot.com",
      messagingSenderId: "472349549744",
      appId: "1:472349549744:web:2f3177dc0ef7c496f40775",
      measurementId: "G-ZVTL9XD6EX");
}
