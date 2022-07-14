import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  bool otpSent = false;
  bool wrongOTP = false;

  String? errorMessage;
  bool showLoginView = true;

  ConfirmationResult? confirmationResult;

  sendOTP(
      {required String phone,
      required Function(String) successCompletion,
      required Function(String) errorHandler}) async {
    getIt<FirebaseManager>().loginViaPhone(
        phoneNumber: phone,
        verificationIdHandler: (verificationId) {
          successCompletion(verificationId);
        },
        verificationFailedHandler: (error) {
          errorHandler(error);
        });
  }

  submitOTP(String otp, String verificationId, Function(String?) completion) {
    // EasyLoading.show(status: 'loading...');
    getIt<FirebaseManager>().verifyOTP(otp, verificationId,
        (loginStatus, isFirstTimeLogin) async {
      if (loginStatus == true) {
        await getIt<UserProfileManager>().refreshProfile();

        if (isFirstTimeLogin == true) {
          Get.offAll(() => const ChooseCategories());
        } else {
          Get.offAll(() => const MainScreen());
        }
        // completion(null);
      } else {
        completion(LocalizationString.wrongOTP);
      }
    });
  }

  loginViaEmail(
      {required String email,
      required String password,
      required Function(String?, UserCredential?) callback}) {
    getIt<FirebaseManager>().loginViaEmail(email: email, password: password).then((response) {
      EasyLoading.dismiss();
      if (response.status == true) {
        callback(null, response.credential);
      } else {
        errorMessage = response.message;
        callback(errorMessage, null);
      }
    });
  }

  signUpViaEmail(
      {required String email,
      required String password,
      required String name,
      required Function(String?) completion}) {
    getIt<FirebaseManager>()
        .signUpViaEmail(email: email, password: password, name: name)
        .then((response) {
      EasyLoading.dismiss();
      if (response.status == true) {
        completion(null);
      } else {
        completion(response.message);
      }
    });
  }

  resetPassword(String email, Function(String) completion) {
    getIt<FirebaseManager>().resetPassword(email).then((result) {
      if (result.status == true) {
        completion(LocalizationString.resetPwdLinkSent);
      } else {
        completion(result.message!);
      }
    });
  }

  changePassword(String password, Function(String?) completion) {
    getIt<FirebaseManager>()
        .changeProfilePassword(pwd: password)
        .then((result) {
      if (result.status == true) {
        completion(null);
      } else {
        completion(result.message!);
      }
    });
  }

  setWrongOTP() {
    wrongOTP = true;
  }
}
