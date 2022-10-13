import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final SettingsController settingsController = Get.find();

  @override
  void initState() {
    // TODO: implement initState

    settingsController.getSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('building shit');
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleBar(title: LocalizationString.settings),
            const SizedBox(
              height: 20,
            ),
            Text(LocalizationString.phoneNumber,
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(
              height: 10,
            ),
            Obx(() => InputField(
                  controller: settingsController.phone.value,
                  showBorder: true,
                  cornerRadius: 5,
                )),
            const SizedBox(
              height: 20,
            ),
            Text(LocalizationString.email,
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(
              height: 10,
            ),
            Obx(() => InputField(
                  controller: settingsController.email.value,
                  showBorder: true,
                  cornerRadius: 5,
                )),
            const SizedBox(
              height: 20,
            ),
            Text(LocalizationString.facebook,
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(
              height: 10,
            ),
            Obx(() => InputField(
                  controller: settingsController.facebook.value,
                  showBorder: true,
                  cornerRadius: 5,
                )),
            const SizedBox(
              height: 20,
            ),
            Text(LocalizationString.twitter,
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(
              height: 10,
            ),
            Obx(() => InputField(
                  controller: settingsController.twitter.value,
                  showBorder: true,
                  cornerRadius: 5,
                )),
            const SizedBox(
              height: 20,
            ),
            Text(LocalizationString.aboutUs,
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(
              height: 10,
            ),
            Obx(() => InputField(
                  controller: settingsController.aboutUs.value,
                  showBorder: true,
                  cornerRadius: 5,
                )),
            const SizedBox(
              height: 20,
            ),
            Text(LocalizationString.privacyPolicy,
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(
              height: 10,
            ),
            Obx(() => InputField(
                  controller: settingsController.privacyPolicy.value,
                  showBorder: true,
                  cornerRadius: 5,
                )),
            const SizedBox(
              height: 20,
            ),
            Text(LocalizationString.iosInAppId,
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(
              height: 10,
            ),
            Obx(() => InputField(
                  controller: settingsController.iosInAppId.value,
                  showBorder: true,
                  cornerRadius: 5,
                )),
            const SizedBox(
              height: 20,
            ),
            Text(LocalizationString.androidInAppId,
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(
              height: 10,
            ),
            Obx(() => InputField(
                  controller: settingsController.androidInAppId.value,
                  showBorder: true,
                  cornerRadius: 5,
                )),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: SizedBox(
                  width: 150,
                  height: 50,
                  child: FilledButtonType1(
                      text: LocalizationString.submit,
                      enabledTextStyle: Theme.of(context).textTheme.titleMedium,
                      onPress: () {
                        settingsController.submitArtist();
                      })),
            )
          ],
        ).p25,
      ),
    );
  }
}
