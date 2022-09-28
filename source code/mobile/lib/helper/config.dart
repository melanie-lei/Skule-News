import 'package:music_streaming_mobile/helper/common_import.dart';

class AppConfig {
  static String projectName = 'Skule News'.tr();

  static String dummyProfilePictureUrl =
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZSUyMHBpY3R1cmV8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60';
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
