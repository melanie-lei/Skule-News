import 'package:flutter/material.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  final loginController = Get.put(LoginController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
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
                ],
              ),
              Container(
                  height: 120,
                  width: 120,
                  color: Theme.of(context).backgroundColor,
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 80,
                    width: 80,
                  )).round(25),
              const SizedBox(
                height: 40,
              ),
              Container(
                height: 300,
                width: 450,
                color: Theme.of(context).backgroundColor,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      LocalizationString.forgotPwd,
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      LocalizationString.forgotPwdSubtitle,
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Obx(() => InputField(
                          icon: ThemeIcon.email,
                          cornerRadius: 5,
                          hintText: 'adam@gmail.com',
                          controller: loginController.email.value,
                          onChanged: (phone) {},
                          showBorder: true,
                          backgroundColor: Colors.black.withOpacity(0.05),
                        )).hP4,
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 40,
                      child: FilledButtonType1(
                        text: LocalizationString.submit,
                        enabledTextStyle: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                        onPress: () {
                          forgotPassword();
                        },
                      ),
                    ),
                  ],
                ).hP16,
              ).round(20),
              const SizedBox(
                height: 40,
              ),
            ],
          ).hP16,
        ],
      ),
    );
  }

  forgotPassword() {
    EasyLoading.show(status: LocalizationString.loading);

    loginController.resetPassword();
  }

  showMessage(String message, bool isError) {
    AppUtil.showToast(message: message, isSuccess: !isError);
  }
}
