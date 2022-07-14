import 'package:flutter/material.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  Rx<TextEditingController> userName = TextEditingController().obs;
  Rx<TextEditingController> password = TextEditingController().obs;

  Rx<TextEditingController> email = TextEditingController().obs;

  String emailText = '';

  setEmail(String email) {
    emailText = email;
  }

  loginUser() {
    if (userName.value.text.isEmpty) {
      showMessage(LocalizationString.pleaseEnterUserName, true);
      return;
    } else if (password.value.text.isEmpty) {
      showMessage(LocalizationString.pleaseEnterPassword, true);
      return;
    }

    EasyLoading.show(status: LocalizationString.loading);
    getIt<FirebaseManager>()
        .login(userName.value.text, password.value.text)
        .then((response) async {
      EasyLoading.dismiss();
      if (response.status == true) {
        await getIt<UserProfileManager>().refreshProfile();

        if (getIt<UserProfileManager>().user!.status == 1) {
          Get.offAll(() => const MainScreen());
        } else {
          getIt<UserProfileManager>().logout();
          AppUtil.showToast(
              message: LocalizationString.accountDeleted, isSuccess: false);
        }
      } else {
        showMessage(response.message ?? '', true);
      }
    });
  }

  resetPassword() {
    if (emailText.isNotEmpty && emailText.isValidEmail()) {
      getIt<FirebaseManager>().resetPassword(emailText).then((result) {
        if (result.status == true) {
          showMessage(LocalizationString.resetPwdLinkSent, false);
        } else {
          showMessage(result.message!, true);
        }
      });
    } else {
      showMessage(LocalizationString.pleaseEnterValidEmail, true);
    }
  }

  signUpViaEmail(
      {required String email,
      required String password,
      required String name}) async {
    EasyLoading.show(status: LocalizationString.loading);
    getIt<FirebaseManager>()
        .signUpViaEmail(email: email, password: password, name: name)
        .then((value) async {
      await getIt<UserProfileManager>().refreshProfile();

      EasyLoading.dismiss();
      if (value.status == true) {
        Get.to(() => const MainScreen());
      } else {
        showMessage(value.message!, true);
      }
    });
  }

  showMessage(String message, bool isError) {
    AppUtil.showToast(message: message, isSuccess: !isError);
  }
}
