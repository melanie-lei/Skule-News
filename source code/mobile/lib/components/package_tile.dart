import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class PackageTile extends StatelessWidget {
  final PackageModel package;
  final int index;
  final SubscriptionPackageController packageController = Get.find();

  PackageTile({Key? key, required this.package, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(package.name, style: Theme.of(context).textTheme.titleMedium),
          Text('\$9.99', style: Theme.of(context).textTheme.titleMedium),
        ],
      ).p16,
    ).borderWithRadius(value: 0.5, radius: 30, context: context).ripple(() {
      if (packageController.isAvailable.value) {
        packageController.selectedPackage.value = index;
        // For Real Time
        packageController.selectedPurchaseId.value = Platform.isIOS
            ? package.inAppPurchaseIdIOS
            : package.inAppPurchaseIdAndroid;
        List<ProductDetails> matchedProductArr = packageController.products
            .where((element) =>
                element.id == packageController.selectedPurchaseId.value)
            .toList();
        if (matchedProductArr.isNotEmpty) {
          ProductDetails matchedProduct = matchedProductArr.first;
          PurchaseParam purchaseParam = PurchaseParam(
              productDetails: matchedProduct, applicationUserName: null);
          packageController.inAppPurchase.buyConsumable(
              purchaseParam: purchaseParam,
              autoConsume: packageController.kAutoConsume || Platform.isIOS);
        } else {
          // AppUtil.showToast(
          //     message: LocalizationString.noProductAvailable,
          //     isSuccess: false);
        }
      } else {
        print('not available');
        packageController.updatedSubscriptionStatus();
        // AppUtil.showToast(
        //     message: LocalizationString.storeIsNotAvailable,
        //     isSuccess: false);
      }
    });
  }
}
