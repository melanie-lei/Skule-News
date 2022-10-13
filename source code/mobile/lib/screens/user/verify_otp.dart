import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:get/get.dart';
import 'package:skule_news_mobile/screens/user/social_login.dart';

//ignore: must_be_immutable
class VerifyOTP extends StatefulWidget {
  String verificationId;
  final String phone;

  VerifyOTP({Key? key, required this.verificationId, required this.phone})
      : super(key: key);

  @override
  VerifyOTPState createState() => VerifyOTPState();
}

class VerifyOTPState extends State<VerifyOTP> {
  TextEditingController otp = TextEditingController();

  bool wrongOTP = false;
  final loginController = Get.put(LoginController());

  @override
  void initState() {
    // TODO: implement initState
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
                          color: Theme.of(context).backgroundColor,
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
                    LocalizationString.enterOTP,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    LocalizationString.enterOtpMessage,
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
                height: 160,
                width: MediaQuery.of(context).size.width - 32,
                color: Theme.of(context).backgroundColor,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    PasswordField(
                      cornerRadius: 5,
                      icon: ThemeIcon.otp,
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      hintText: LocalizationString.enterOTP,
                      controller: otp,
                      showBorder: true,
                      backgroundColor: Colors.black.withOpacity(0.05),
                      onChanged: (phone) {},
                    ).hP4,
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
                          submitOTP();
                        },
                      ),
                    ),
                  ],
                ).hP16,
              ).round(20),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Theme.of(context).dividerColor,
                    height: 1,
                    width: 100,
                  ),
                  Text(
                    'Or connect using',
                    style: Theme.of(context).textTheme.titleSmall,
                  ).hP8,
                  Container(
                    color: Theme.of(context).dividerColor,
                    height: 1,
                    width: 100,
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width - 32,
                  color: Theme.of(context).backgroundColor,
                  child: const SocialLogin())
                  .round(20),
              const Spacer(),
              Column(
                children: [
                  Text(
                    LocalizationString.skip,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Theme.of(context).dividerColor,
                    height: 2,
                    width: 50,
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ).hP16,
        ],
      ),
    );
  }

  submitOTP() {
    if (otp.text.isEmpty) {
      showMessage(LocalizationString.pleaseEnterOTP, true);
      return;
    }
    // EasyLoading.show(status: LocalizationString.loading);

    // EasyLoading.show(status: LocalizationString.loading);

    loginController.submitOTP(otp.text, widget.verificationId, (error) async{
      // EasyLoading.dismiss();
      if (error == null) {
        Get.to(() => const ChooseCategories());
      } else {
        showMessage(error, true);
      }
    });
  }

  resendOTP() {
    EasyLoading.show(status: LocalizationString.loading);
    loginController.sendOTP(
        phone: widget.phone,
        successCompletion: (id) {
          EasyLoading.dismiss();
          widget.verificationId = id;
        },
        errorHandler: (error) {
          showMessage(error, true);
        });
  }

  showMessage(String message, bool isError) {
    AppUtil.showToast(message: message, isSuccess: !isError);
  }
}
