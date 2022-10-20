import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

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
                height: 70,
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
                height: 40,
              ),
              Center(
                child: Container(
                  height: 300,
                  width: 500,
                  color: Theme.of(context).backgroundColor,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        LocalizationString.welcome,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        LocalizationString.welcomeSubtitleMsg,
                        style: Theme.of(context).textTheme.titleSmall,
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
                        height: 50,
                      ),
                      // const SocialLogin(),
                    ],
                  ).hP16,
                ).round(20),
              )
            ],
          ),
        ],
      ),
    );
  }
}
