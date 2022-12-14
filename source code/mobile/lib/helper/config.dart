import 'package:skule_news_mobile/helper/common_import.dart';

class AppConfig {
  static String projectName = 'Skule News'.tr();

  static String dummyProfilePictureUrl =
      'https://images.unsplash.com/photo-1521913626209-0fbf68f4c4b1?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80';
  static String backgroundImage =
      'https://images.unsplash.com/photo-1655212681194-fd1932c9b542?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyOHx8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=60';
  static bool isLoggedIn = false;
  static bool isRightToLeft = false;
}

class AdmobConstants {
  // Admob ids for android
  static const bannerAdUnitIdForAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const interstitialAdUnitIdForAndroid =
      'ca-app-pub-3940256099942544/1033173712';

  // Admob ids for iOS
  static const bannerAdUnitIdForiOS = 'ca-app-pub-3940256099942544/6300978111';
  static const interstitialAdUnitIdForiOS =
      'ca-app-pub-3940256099942544/1033173712';
}
