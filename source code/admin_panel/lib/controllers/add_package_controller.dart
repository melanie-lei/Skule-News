import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';

class AddPackageController extends GetxController {
  Rx<TextEditingController> name = TextEditingController().obs;
  Rx<TextEditingController> price = TextEditingController().obs;
  Rx<TextEditingController> iOSInAppId = TextEditingController().obs;
  Rx<TextEditingController> androidInAppId = TextEditingController().obs;

  Rx<PackageModel?> package = Rx<PackageModel?>(null);

  setPackage(PackageModel package) {
    name.value.text = package.name;
    price.value.text = package.price;
    iOSInAppId.value.text = package.inAppPurchaseIdIOS;
    androidInAppId.value.text = package.inAppPurchaseIdAndroid;
  }

  submit() async {
    if (name.value.text.isEmpty) {
      showMessage(LocalizationString.pleaseEnterPackageName, true);
      return;
    }
    if (iOSInAppId.value.text.isEmpty) {
      showMessage(LocalizationString.pleaseEnterIOSInAppId, true);
      return;
    }
    if (androidInAppId.value.text.isEmpty) {
      showMessage(LocalizationString.pleaseEnterAndroidInAppId, true);
      return;
    }

    EasyLoading.show(status: LocalizationString.loading);

    var id = package.value?.id ?? getRandString(25);

    getIt<FirebaseManager>()
        .insertPackage(
      package: package.value,
      id: id,
      name: name.value.text,
      price: price.value.text,
      iOSInAppId: iOSInAppId.value.text,
      androidInAppId: androidInAppId.value.text,
    )
        .then((response) {
      EasyLoading.dismiss();
      if (response.status == true) {
        name.value.text = '';
        iOSInAppId.value.text = '';
        androidInAppId.value.text = '';
        price.value.text = '';

        showMessage(
            package.value == null
                ? LocalizationString.packageAdded
                : LocalizationString.packageUpdated,
            true);
      } else {
        showMessage(response.message ?? '', true);
      }
    });
  }

  showMessage(String message, bool isError) {
    AppUtil.showToast(message: message, isSuccess: isError);
  }
}
