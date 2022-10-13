import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class AppUtil {
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static showToast({required String message, required bool isSuccess}) {
    Get.snackbar(
        isSuccess == true
            ? LocalizationString.success
            : LocalizationString.error,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isSuccess == true ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
        icon: const Icon(Icons.error, color: Colors.white));
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static void showLoader(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
                backgroundColor: Colors.black12,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor)),
          );
        });
  }

  static void dismissLoader(BuildContext context) {
    Navigator.of(context).pop();
  }

  static Widget addProgressIndicator(BuildContext context) {
    return Center(
        child: SizedBox(
      width: 15,
      height: 15,
      child: CircularProgressIndicator(
          strokeWidth: 2.0,
          backgroundColor: Colors.black12,
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
    ));
  }

  static Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static Future<File> findPath(String imageUrl) async {
    final cache = DefaultCacheManager();
    final file = await cache.getSingleFile(imageUrl);
    return file;
  }

  static void logoutAction(BuildContext cxt, VoidCallback handler) {
    showDialog(
      barrierDismissible: false,
      context: cxt,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Text(AppConfig.projectName,
              style: TextStyle(color: Theme.of(context).primaryColor)),
          content: Text(LocalizationString.logout),
          actions: [
            TextButton(
              child: Text(LocalizationString.yes,
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              onPressed: () {
                Navigator.of(context).pop();
                handler();
              },
            ),
            TextButton(
              child: Text(LocalizationString.no,
                  style: const TextStyle(color: Colors.black87)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
