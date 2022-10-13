import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  Rx<TextEditingController> newPassword = TextEditingController().obs;
  Rx<TextEditingController> confirmPassword = TextEditingController().obs;

  changePassword() async {
    if (newPassword.value.text.isEmpty) {
      showMessage(LocalizationString.pleaseEnterPassword, true);
      return;
    } else if (newPassword.value.text.length < 6) {
      showMessage(LocalizationString.passwordRule, true);
      return;
    } else if (confirmPassword.value.text.isEmpty) {
      showMessage(LocalizationString.pleaseEnterConfirmPassword, true);
      return;
    } else if (confirmPassword.value.text != newPassword.value.text) {
      showMessage(LocalizationString.passwordsDoesNotMatched, true);
      return;
    }
    EasyLoading.show(status: LocalizationString.loading);

    getIt<FirebaseManager>()
        .changeProfilePassword(pwd: newPassword.value.text)
        .then((response) {
      EasyLoading.dismiss();
      if (response.status == true) {
        newPassword.value.text = '';
        confirmPassword.value.text = '';
        update();
        showMessage(LocalizationString.passwordChanged, true);
      } else {
        showMessage(response.message ?? '', true);
      }
    });
  }

  showMessage(String message, bool isError) {
    AppUtil.showToast(message: message, isSuccess: !isError);
  }
}
