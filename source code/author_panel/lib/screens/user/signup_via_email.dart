import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

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
                height: 450,
                width: 450,
                color: Theme.of(context).backgroundColor,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      LocalizationString.signUp,
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      LocalizationString.signUpMessage,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(
                      height: 50,
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
                            .copyWith(fontWeight: FontWeight.w600),
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
              key: UniqueKey(),
              controller: signUpEmail,
              hintText: LocalizationString.email,
              icon: ThemeIcon.email,
              showBorder: true,
              cornerRadius: 5,
              backgroundColor: Colors.black.withOpacity(0.05),
            ),
            const SizedBox(
              height: 10,
            ),
            InputField(
              key: UniqueKey(),
              controller: name,
              hintText: LocalizationString.name,
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
              key: UniqueKey(),
              controller: signUpPassword,
              hintText: LocalizationString.password,
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

  signup() {
    // Validates sign up information is filled out.
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
    );
  }

  showMessage(String message, bool isError) {
    AppUtil.showToast(message: message, isSuccess: !isError);
  }
}
