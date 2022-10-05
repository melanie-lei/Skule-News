import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmNewPassword = TextEditingController();

  final loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                color: Colors.white.darken(),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 3,
                  color: Theme.of(context).primaryColor,
                ).bottomRounded(10),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const ThemeIconWidget(
                        ThemeIcon.backArrow,
                        color: Colors.white,
                        size: 25,
                      ).ripple(() {
                        Get.back();
                      }),
                      Container(
                          height: 40,
                          width: 40,
                          color:
                              Theme.of(context).backgroundColor.lighten(0.05),
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 20,
                            width: 20,
                          )).round(10),
                      const SizedBox(
                        width: 25,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    LocalizationString.changePwd,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    LocalizationString.changePwdMessage,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Colors.white),
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                height: 230,
                width: MediaQuery.of(context).size.width - 32,
                color: Theme.of(context).backgroundColor.lighten(0.05),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    changePasswordView(),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 40,
                      child: FilledButtonType1(
                        text: LocalizationString.changePwd,
                        enabledTextStyle: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                        onPress: () {
                          changePassword();
                        },
                      ),
                    ),
                  ],
                ).hP16,
              ).round(20),
              const SizedBox(
                height: 40,
              ),
              const Spacer(),
            ],
          ).hP16,
        ],
      ),
    );
  }

  Widget changePasswordView() {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PasswordField(
              onChanged: (txt) {},
              key: UniqueKey(),
              controller: newPassword,
              hintText: 'new password',
              icon: ThemeIcon.lock,
              cornerRadius: 5,
              showBorder: true,
              backgroundColor: Colors.black.withOpacity(0.05),
            ),
            const SizedBox(
              height: 10,
            ),
            PasswordField(
              onChanged: (txt) {},
              key: UniqueKey(),
              controller: confirmNewPassword,
              hintText: 'confirm new password',
              icon: ThemeIcon.lock,
              cornerRadius: 5,
              showBorder: true,
              backgroundColor: Colors.black.withOpacity(0.05),
            ),
          ],
        ),
      ),
    );
  }

  changePassword() {
    if (newPassword.text.isEmpty) {
      showMessage(LocalizationString.pleaseEnterPassword, true);
      return;
    } else if (confirmNewPassword.text.isValidEmail() == false) {
      showMessage(LocalizationString.pleaseEnterConfirmPassword, true);
      return;
    } else if (newPassword.text != confirmNewPassword.text) {
      showMessage(LocalizationString.passwordsDoesNotMatched, true);
      return;
    }

    EasyLoading.show(status: LocalizationString.loading);

    loginController.changePassword(newPassword.text, (callbackMessage) {
      if (callbackMessage == null) {
        Get.off(const AskForLogin());
      } else {
        showMessage(callbackMessage, true);
      }
    });
  }

  showMessage(String message, bool isError) {
    AppUtil.showToast(message: message, isSuccess: !isError);
  }
}
