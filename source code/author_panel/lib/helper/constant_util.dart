class AppConfig {
  static String projectName = 'Skule News';
  static String projectTagline = 'School Newspaper App';

  static String firebaseStorageBucketUrl = 'skule-news.appspot.com';

  static String backgroundImage =
      'https://images.unsplash.com/photo-1655212681194-fd1932c9b542?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyOHx8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=60';
  static bool isLoggedIn = false;
}

class AdmobConstants {
  // Admob ids for android
  static const bannerAdUnitIdForAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const interstitialAdUnitIdForAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const rewardAdUnitIdForAndroid =
      "ca-app-pub-3940256099942544/5224354917";

  // Admob ids for iOS
  static const bannerAdUnitIdForiOS = 'ca-app-pub-3940256099942544/6300978111';
  static const interstitialAdUnitIdForiOS =
      'ca-app-pub-3940256099942544/1033173712';
  static const rewardAdUnitIdForiOS = "ca-app-pub-3940256099942544/1712485313";
}
