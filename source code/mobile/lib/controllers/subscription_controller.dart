import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class SubscriptionPackageController extends GetxController {
  RxList<PackageModel> packages = <PackageModel>[].obs;

  RxInt coins = 0.obs;

  final bool kAutoConsume = true;
  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> subscription;
  RxList<ProductDetails> products = <ProductDetails>[].obs;
  RxBool isAvailable = false.obs;
  RxString selectedPurchaseId = ''.obs;
  RxInt selectedPackage = 0.obs;
  RxString subscriptionStatus = ''.obs;

  initiate() {
    AppUtil.checkInternet().then((value) {
      if (value) {
        getIt<FirebaseManager>().getPackages().then((value) {
          packages.value = value;
          initStoreInfo();
          update();
        });
      }
    });

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
  }

  Future<void> initStoreInfo() async {
    isAvailable.value = await InAppPurchase.instance.isAvailable();
    if (!isAvailable.value) {
      products.value = [];
      update();
      return;
    }

    List<String> _kProductIds = packages
        .map((e) =>
            Platform.isIOS ? e.inAppPurchaseIdIOS : e.inAppPurchaseIdAndroid)
        .toList();
    ProductDetailsResponse productDetailResponse =
        await inAppPurchase.queryProductDetails(_kProductIds.toSet());

    products.value = productDetailResponse.productDetails;
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

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        //showPending error
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          //show error
          // AppUtil.showToast(
          //     message: LocalizationString.purchaseError, isSuccess: false);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          //show success

          AppUtil.checkInternet().then((value) {
            if (value) {
              // ApiController()
              //     .subscribePackage(
              //     packages[selectedPackage.value].id.toString(),
              //     purchaseDetails.purchaseID!,
              //     packages[selectedPackage.value].price.toString())
              //     .then((response) {
              //   AppUtil.showToast(
              //       message: LocalizationString.coinsAdded, isSuccess: true);
              //   getIt<UserProfileManager>().refreshProfile();
              //   if (response.success) {
              //     user.value.coins = packages[selectedPackage.value].coin;
              //   }
              // });
            }
          });
        }
        if (Platform.isAndroid) {
          if (!kAutoConsume &&
              purchaseDetails.productID == selectedPurchaseId.value) {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
                inAppPurchase.getPlatformAddition<
                    InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    });
  }

  updatedSubscriptionStatus() {
    getIt<FirebaseManager>()
        .updateUserSubscription(numberOfDays: 30, subscriptionTerm: '1 Month')
        .then((value) {
      getIt<UserProfileManager>().refreshProfile();

      if (value.status == true) {
        AppUtil.showToast(
            message: LocalizationString.subscribed, isSuccess: true);
      } else {
        AppUtil.showToast(
            message: LocalizationString.errorMessage, isSuccess: true);
      }
    });
  }

  getSubscriptionStatus() {
    DateTime? subscriptionDate =
        getIt<UserProfileManager>().user!.subscriptionDate;
    if (subscriptionDate != null) {
      DateTime todayDate = getIt<UserProfileManager>().user!.todayDate;
      int daysConsumed = todayDate.difference(subscriptionDate).inDays;
      int noOfDaysInSubscription =
          getIt<UserProfileManager>().user!.subscriptionDays;
      String? subscriptionTerm =
          getIt<UserProfileManager>().user!.subscriptionTerm;

      if (noOfDaysInSubscription > daysConsumed) {
        DateTime subscriptionsExpiredDate = todayDate
            .add(Duration(days: (noOfDaysInSubscription - daysConsumed)));
        String formattedDate =
            DateFormat('dd-MM-yyyy').format(subscriptionsExpiredDate);

        subscriptionStatus.value =
            '(${subscriptionTerm!} ${LocalizationString.subscriptionValidTill} $formattedDate)';
      } else {
        subscriptionStatus.value = LocalizationString.subscriptionExpired;
      }
    } else {
      subscriptionStatus.value = LocalizationString.noSubscription;
    }

    update();
  }

}
