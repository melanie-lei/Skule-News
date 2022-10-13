import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.95,
              child: Stack(
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1506157786151-b8491531f063?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTZ8fG11c2ljfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=800&q=60',
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.95,
                    width: double.infinity,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.95,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        gradient: LinearGradient(
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            colors: [
                              Theme.of(context).backgroundColor
                                  .withOpacity(0.8),
                              Theme.of(context).backgroundColor
                                  .withOpacity(0.5),
                            ],
                            stops: const [
                              0.0,
                              1.0
                            ])),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Text(
                        LocalizationString.appTagline,
                        style: Theme.of(context).textTheme.headline1,
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      SizedBox(
                          height: 60,
                          width: 150,
                          child: FilledButtonType1(
                              cornerRadius: 50,
                              text: LocalizationString.login,
                              onPress: () {
                                signIn();
                              },
                              isEnabled: true,
                              enabledTextStyle:
                                  Theme.of(context).textTheme.titleMedium)),
                      const Spacer(),
                    ],
                  ).hP50
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  signIn() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AskForLogin();
        });
  }
}
