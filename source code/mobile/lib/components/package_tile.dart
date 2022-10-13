import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class PackageTile extends StatelessWidget {
  final PackageProducts package;
  final SubscriptionPackageController packageController = Get.find();

  PackageTile({Key? key, required this.package}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(LocalizationString.premium,
              style: Theme.of(context).textTheme.titleMedium),
          package.id == packageController.subscribedProductId
              ? Container(
                  height: 25,
                  width: 100,
                  color: Theme.of(context).backgroundColor,
                  child: Center(
                    child: Text(
                      LocalizationString.subscribed,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  )).round(10)
              : Text(package.localizedPrice,
                  style: Theme.of(context).textTheme.titleMedium)
        ],
      ).p16,
    ).borderWithRadius(value: 0.5, radius: 30, context: context).ripple(() {
      if (package.id != packageController.subscribedProductId) {
        packageController.purchasePremium(package.id);
      }
    });
  }
}
