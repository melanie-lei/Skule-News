import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return AdmobConstants.bannerAdUnitIdForAndroid;
    } else if (Platform.isIOS) {
      return AdmobConstants.bannerAdUnitIdForiOS;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return AdmobConstants.interstitialAdUnitIdForAndroid;
    } else if (Platform.isIOS) {
      return AdmobConstants.interstitialAdUnitIdForiOS;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return AdmobConstants.rewardAdUnitIdForAndroid;
    } else if (Platform.isIOS) {
      return AdmobConstants.rewardAdUnitIdForiOS;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}

class BannerAds extends StatefulWidget {
  const BannerAds({Key? key}) : super(key: key);

  @override
  _BannerAdsState createState() => _BannerAdsState();
}

class _BannerAdsState extends State<BannerAds> {
  @override
  // TODO: Add _bannerAd
  late BannerAd _bannerAd;

  // TODO: Add _isBannerAdReady

  @override
  void initState() {
    super.initState();
    if (getIt<UserProfileManager>().user?.isPro == false) {
      loadAds();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: getIt<UserProfileManager>().user?.isPro == false
            ? _bannerAd.size.height.toDouble()
            : 0,
        child: getIt<UserProfileManager>().user?.isPro == false
            ? AdWidget(ad: _bannerAd)
            : const SizedBox(
                height: 1,
              ),
      ),
    );
  }

  void loadAds() {
    // TODO: Initialize _bannerAd
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
          });
        },
        onAdFailedToLoad: (ad, err) {
          //ad.dispose();
        },
      ),
    );
    _bannerAd.load();
  }
}

class InterstitialAds extends StatelessWidget {
  final VoidCallback? onCompletion;

  InterstitialAds({Key? key, this.onCompletion}) : super(key: key);

  // TODO: Add _interstitialAd
  InterstitialAd? _interstitialAd;

  // TODO: Add _isInterstitialAdReady
  bool _isInterstitialAdReady = false;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void loadInterstitialAd() {
    if (getIt<UserProfileManager>().user?.isPro == true) {
      onCompletion!();
      return;
    }
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd?.show();

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              onCompletion!();
            },
          );

          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          _isInterstitialAdReady = false;
          onCompletion!();
        },
      ),
    );
  }
}
