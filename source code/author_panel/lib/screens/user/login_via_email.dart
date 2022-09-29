import 'package:flutter/material.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class LoginViaEmail extends StatefulWidget {
  const LoginViaEmail({Key? key}) : super(key: key);

  @override
  _LoginViaEmailState createState() => _LoginViaEmailState();
}

class _LoginViaEmailState extends State<LoginViaEmail> {
  final loginController = Get.put(LoginController());

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
                height: 380,
                width: 450,
                color: Theme.of(context).backgroundColor,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      LocalizationString.signIn,
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      LocalizationString.signInMessage,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(
                      height: 50,
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
                height: 40,
              ),
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
            Obx(() => InputField(
                  key: UniqueKey(),
                  controller: loginController.userName.value,
                  hintText: 'adam@zedge.com',
                  icon: ThemeIcon.email,
                  showBorder: true,
                  cornerRadius: 5,
                  backgroundColor: Colors.black.withOpacity(0.05),
                )),
            const SizedBox(
              height: 10,
            ),
            Obx(() => PasswordField(
                  onChanged: (txt) {},
                  key: UniqueKey(),
                  controller: loginController.password.value,
                  hintText: '*********',
                  icon: ThemeIcon.lock,
                  cornerRadius: 5,
                  showBorder: true,
                  backgroundColor: Colors.black.withOpacity(0.05),
                )),
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
    loginController.loginUser();
  }
}