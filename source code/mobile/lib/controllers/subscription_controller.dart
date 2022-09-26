import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class SubscriptionPackageController extends GetxController {
  Rx<PackageProducts?> package = Rx<PackageProducts?>(null);

  RxInt coins = 0.obs;

  final bool kAutoConsume = true;
  String subscribedProductId = '';

  late StreamSubscription purchaseUpdatedSubscription;
  late StreamSubscription purchaseErrorSubscription;
  late StreamSubscription connectionSubscription;

  final List<IAPItem> items = [];

  initiate() async {
    // prepare
    await FlutterInappPurchase.instance.initialize();

    connectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      // print('connected: $connected');
    });

    purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      // print('purchase-updated: $productItem');
      if (productItem?.purchaseStateAndroid == PurchaseState.purchased ||
          productItem?.transactionStateIOS == TransactionState.purchased) {
        updateReceipt(
            receipt: productItem!.transactionReceipt!,
            purchaseDate: productItem.transactionDate!.millisecondsSinceEpoch);
      }
    });

    purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
    });

    AppUtil.checkInternet().then((value) {
      if (value) {
        getIt<FirebaseManager>().getSettings().then((setting) {
          if (setting != null) {
            _getProduct(Platform.isIOS
                ? setting.iOSInAppPurchaseId!
                : setting.androidInAppPurchaseId!);
          }
        });
      }
    });
  }

  Future _getProduct(String productId) async {
    List<IAPItem> items =
        await FlutterInappPurchase.instance.getProducts([productId]);

    if (items.isNotEmpty) {
      package.value = PackageProducts(
        id: items.first.productId!,
        localizedPrice: items.first.localizedPrice!,
        title: items.first.title!,
      );

      update();
    }
  }

  showRewardedAds() {
    // RewardedInterstitialAds(onRewarded: () {
    //   ApiController().rewardCoins().then((response) {
    //     if (response.success == true) {
    //       getIt<UserProfileManager>().refreshProfile();
    //     } else {}
    //   });
    // }).loadInterstitialAd();
  }

  purchasePremium(String productId) {
    FlutterInappPurchase.instance.requestPurchase(productId).then((value) {
      // print(value);
    });
  }

  restorePurchase() {
    if (getIt<UserProfileManager>().user?.subscriptionReceipt != null) {
      FlutterInappPurchase.instance.getAvailablePurchases().then((value) {
        AppUtil.showToast(
            message: LocalizationString.restorePurchaseDone, isSuccess: true);
      });
    } else {
      AppUtil.showToast(
          message: LocalizationString.notSubscribedYet, isSuccess: false);
    }
  }

  updateReceipt({required String receipt, required int purchaseDate}) {
    getIt<FirebaseManager>()
        .updateUserSubscription(receipt: receipt, purchaseDate: purchaseDate)
        .then((value) async {
      await getIt<UserProfileManager>().refreshProfile();

      if (value.status == true) {
        AppUtil.showToast(
            message: LocalizationString.subscribedSuccessfully,
            isSuccess: true);
      } else {
        AppUtil.showToast(
            message: LocalizationString.errorMessage, isSuccess: true);
      }
    });
  }
}
