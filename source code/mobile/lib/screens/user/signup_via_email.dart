import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get/get.dart';
import 'package:music_streaming_mobile/screens/user/social_login.dart';

class SignupViaEmail extends StatefulWidget {
  const SignupViaEmail({Key? key}) : super(key: key);

  @override
  _SignupViaEmailState createState() => _SignupViaEmailState();
}

class _SignupViaEmailState extends State<SignupViaEmail> {
  TextEditingController signUpEmail = TextEditingController();
  TextEditingController name = TextEditingController();

  TextEditingController signUpPassword = TextEditingController();

  final loginController = Get.put(LoginController());

  String emailText = '';

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
                    LocalizationString.signUp,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    LocalizationString.signUpMessage,
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
                height: 300,
                width: MediaQuery.of(context).size.width - 32,
                color: Theme.of(context).backgroundColor.lighten(0.05),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    signUpView(),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 40,
                      child: FilledButtonType1(
                        text: LocalizationString.signUp,
                        enabledTextStyle: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                        onPress: () {
                          signup();
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
                      color: Theme.of(context).backgroundColor.lighten(0.05),
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
              ).ripple(() {
                getIt<UserProfileManager>().loginAnonymously();
              }),
              const SizedBox(
                height: 50,
              )
            ],
          ).hP16,
        ],
      ),
    );
  }

  Widget signUpView() {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputField(
              // key: UniqueKey(),
              controller: signUpEmail,
              hintText: "email",
              icon: ThemeIcon.email,
              showBorder: true,
              cornerRadius: 5,
              backgroundColor: Colors.black.withOpacity(0.05),
            ),
            const SizedBox(
              height: 10,
            ),
            InputField(
              // key: UniqueKey(),
              controller: name,
              hintText: 'name',
              icon: ThemeIcon.account,
              showBorder: true,
              cornerRadius: 5,
              backgroundColor: Colors.black.withOpacity(0.05),
            ),
            const SizedBox(
              height: 10,
            ),
            PasswordField(
              onChanged: (txt) {},
              // key: UniqueKey(),
              controller: signUpPassword,
              hintText: 'password',
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

  resetPassword() {
    EasyLoading.show(status: LocalizationString.loading);

    loginController.resetPassword(emailText, (message) {
      showMessage(message, true);
    });
  }

  signup() {
    if (signUpEmail.text.isEmpty) {
      showMessage(LocalizationString.pleaseEnterValidEmail, true);
      return;
    } else if (signUpEmail.text.isValidEmail() == false) {
      showMessage(LocalizationString.pleaseEnterValidEmail, true);
      return;
    } else if (signUpPassword.text.isEmpty) {
      showMessage(LocalizationString.pleaseEnterPassword, true);
      return;
    }

    EasyLoading.show(status: LocalizationString.loading);

    loginController.signUpViaEmail(
        email: signUpEmail.text,
        password: signUpPassword.text,
        name: name.text,
        completion: (error) async {
          await getIt<UserProfileManager>().refreshProfile();

          EasyLoading.dismiss();
          if (error == null) {
            Get.offAll(() => const ChooseCategories());
          } else {
            showMessage(error, true);
          }
        });
  }

  showMessage(String message, bool isError) {
    AppUtil.showToast(message: message, isSuccess: !isError);
  }
}
