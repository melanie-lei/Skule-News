import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';

class SettingsController extends GetxController {
  Rx<TextEditingController> phone = TextEditingController().obs;
  Rx<TextEditingController> email = TextEditingController().obs;
  Rx<TextEditingController> facebook = TextEditingController().obs;
  Rx<TextEditingController> twitter = TextEditingController().obs;
  Rx<TextEditingController> aboutUs = TextEditingController().obs;
  Rx<TextEditingController> privacyPolicy = TextEditingController().obs;

  SettingsModel? setting;

  getSettings() {
    getIt<FirebaseManager>().getSettings().then((result) {
      setting = result;
      if (setting != null) {
        phone.value.text = setting?.phone ?? '';
        email.value.text = setting?.email ?? '';
        facebook.value.text = setting?.facebook ?? '';
        twitter.value.text = setting?.twitter ?? '';
        aboutUs.value.text = setting?.aboutUs ?? '';
        privacyPolicy.value.text = setting?.privacyPolicy ?? '';
      }
      update();
    });
  }

  submitArtist() async {
    EasyLoading.show(status: LocalizationString.loading);

    getIt<FirebaseManager>()
        .saveSetting(
      phone: phone.value.text,
      email: email.value.text,
      facebook: facebook.value.text,
      twitter: twitter.value.text,
      aboutUs: aboutUs.value.text,
      privacyPolicy: privacyPolicy.value.text,
    )
        .then((response) {
      EasyLoading.dismiss();
      if (response.status == true) {
        showMessage(LocalizationString.settingsSaved, true);
      } else {
        showMessage(response.message ?? '', true);
      }
    });
  }

  showMessage(String message, bool isError) {
    AppUtil.showToast(message: message, isSuccess: isError);
  }
}
