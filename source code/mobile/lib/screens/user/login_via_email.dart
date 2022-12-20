import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:get/get.dart';
import 'package:skule_news_mobile/screens/user/social_login.dart';

class LoginViaEmail extends StatefulWidget {
  const LoginViaEmail({Key? key}) : super(key: key);

  @override
  _LoginViaEmailState createState() => _LoginViaEmailState();
}

class _LoginViaEmailState extends State<LoginViaEmail> {
  TextEditingController loginEmail = TextEditingController();

  TextEditingController name = TextEditingController();
  TextEditingController loginPassword = TextEditingController();

  TextEditingController confirmPassword = TextEditingController();

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
            mainAxisAlignment: MainAxisAlignment.start,
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
                      Container(),
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
                    LocalizationString.signIn,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    LocalizationString.signInMessage,
                    style: AppTheme.configTheme.textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 260,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).backgroundColor.lighten(0.05),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    loginWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 40,
                      child: FilledButtonType1(
                        text: LocalizationString.signIn,
                        enabledTextStyle:
                            Theme.of(context).textTheme.titleMedium,
                        onPress: () {
                          loginUser();
                        },
                      ),
                    ),
                  ],
                ).hP16,
              ).round(20),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Theme.of(context).dividerColor,
                    height: 1,
                    width: 100,
                  ),
                  Container(
                    color: Theme.of(context).dividerColor,
                    height: 1,
                    width: 100,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Spacer(),
              const SizedBox(
                height: 30,
              )
            ],
          ).hP16,
        ],
      ),
    );
  }

  Widget loginWidget() {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputField(
              // key: UniqueKey(),
              controller: loginEmail,
              hintText: 'email',
              icon: ThemeIcon.email,
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
              controller: loginPassword,
              hintText: 'password',
              icon: ThemeIcon.lock,
              cornerRadius: 5,
              showBorder: true,
              backgroundColor: Colors.black.withOpacity(0.05),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  LocalizationString.forgotPwd,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ).ripple(() {
                  Get.to(() => const ForgotPassword());
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  loginUser() {
    if (loginEmail.text.isEmpty) {
      showMessage(LocalizationString.pleaseEnterValidEmail, true);
      return;
    } else if (loginPassword.text.isEmpty) {
      showMessage(LocalizationString.pleaseEnterPassword, true);
      return;
    }

    EasyLoading.show(status: LocalizationString.loading);

    loginController.loginViaEmail(
        email: loginEmail.text,
        password: loginPassword.text,
        callback: (error, credentials) async {
          await getIt<UserProfileManager>().refreshProfile();

          EasyLoading.dismiss();
          if (error == null) {
            if (credentials?.additionalUserInfo?.isNewUser == true) {
              Get.offAll(() => const ChooseCategories());
            } else {
              print('asl;dk' +
                  (getIt<UserProfileManager>().user?.status == 1).toString());
              if (getIt<UserProfileManager>().user?.status == 1) {
                Get.offAll(() => const MainScreen());
              } else {
                getIt<UserProfileManager>().logout();
                AppUtil.showToast(
                    message: LocalizationString.accountDeleted,
                    isSuccess: false);
              }
            }
          } else {
            showMessage(error, true);
          }
        });
  }

  showMessage(String message, bool isError) {
    AppUtil.showToast(message: message, isSuccess: !isError);
  }
}
