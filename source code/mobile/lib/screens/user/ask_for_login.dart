import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:get/get.dart';
import 'package:skule_news_mobile/screens/user/signup_via_email.dart';
import 'package:skule_news_mobile/screens/user/social_login.dart';

class AskForLogin extends StatefulWidget {
  const AskForLogin({Key? key}) : super(key: key);

  @override
  State<AskForLogin> createState() => _AskForLoginState();
}

class _AskForLoginState extends State<AskForLogin> {
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
                  height: MediaQuery.of(context).size.height / 2,
                  color: Theme.of(context).primaryColor,
                ).bottomRounded(10),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 120,
                  width: 120,
                  color: Theme.of(context).backgroundColor.lighten(0.05),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 80,
                    width: 80,
                  )).round(25),
              const SizedBox(
                height: 10,
              ),
              Text(
                AppConfig.projectName,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  height: 400,
                  width: MediaQuery.of(context).size.width - 32,
                  color: Theme.of(context).backgroundColor.lighten(0.05),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        LocalizationString.welcome,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        LocalizationString.welcomeSubtitleMsg,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        height: 40,
                        child: FilledButtonType1(
                          text: LocalizationString.signIn,
                          enabledTextStyle:
                              Theme.of(context).textTheme.titleMedium,
                          onPress: () {
                            Get.to(() => const LoginViaEmail());
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 40,
                        child: BorderButtonType1(
                          text: LocalizationString.signUp,
                          textStyle: Theme.of(context).textTheme.titleMedium,
                          onPress: () {
                            Get.to(() => const SignupViaEmail());
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            color: Theme.of(context).dividerColor,
                            height: 1,
                            width: 50,
                          ),
                          Text(
                            'Or connect using',
                            style: Theme.of(context).textTheme.titleSmall,
                          ).hP8,
                          Container(
                            color: Theme.of(context).dividerColor,
                            height: 1,
                            width: 50,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const SocialLogin(),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ).hP16,
                ).round(20),
              )
            ],
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Center(
                child: Column(
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
              ))
        ],
      ),
    );
  }
}
