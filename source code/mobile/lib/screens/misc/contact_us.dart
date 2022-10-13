import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: BackNavigationBar(
        title: LocalizationString.contactUs,
        backTapHandler: () {
          Get.back();
        },
      ),
      body: Column(
        children: [
          Column(
            children: [
              InputField(
                // textStyle: Theme.of(context).textTheme.bodyMedium,
                controller: name,
                hintText: LocalizationString.name,
                showBorder: false,
                showDivider: true,
              ),
              const SizedBox(
                height: 20,
              ),
              InputField(
                // textStyle: Theme.of(context).textTheme.bodyMedium,
                controller: email,
                hintText: LocalizationString.email,
                showBorder: false,
                showDivider: true,
              ),
              const SizedBox(
                height: 20,
              ),
              InputField(
                // textStyle: Theme.of(context).textTheme.bodyMedium,
                controller: phone,
                hintText: LocalizationString.phoneNumber,
                showBorder: false,
                showDivider: true,
              ),
              const SizedBox(
                height: 20,
              ),
              InputField(
                // textStyle: Theme.of(context).textTheme.bodyMedium,
                controller: message,
                hintText: LocalizationString.message,
                showBorder: false,
                showDivider: true,
                maxLines: 10,
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                  width: 120,
                  height: 50,
                  child: FilledButtonType1(
                      isEnabled: true,
                      cornerRadius: 10,
                      text: LocalizationString.submit,
                      enabledTextStyle: Theme.of(context).textTheme.titleMedium,
                      onPress: () {
                        sendMessage();
                      }))
            ],
          )
        ],
      ).hP16,
    );
  }

  sendMessage() {
    if (name.text.isEmpty) {
      showMessage(LocalizationString.pleaseEnterName, true);
      return;
    }
    if (email.text.isEmpty) {
      showMessage(LocalizationString.pleaseEnterEmail, true);
      return;
    }
    if (phone.text.isEmpty) {
      showMessage(LocalizationString.pleaseEnterPhone, true);
      return;
    }
    if (message.text.isEmpty) {
      showMessage(LocalizationString.pleaseEnterMessage, true);
      return;
    }

    EasyLoading.show(status: LocalizationString.loading);
    getIt<FirebaseManager>()
        .sendContactusMessage(name.text, email.text, phone.text, message.text)
        .then((result) {
      EasyLoading.dismiss();
      if (result.status == true) {
        showMessage(result.message ?? LocalizationString.requestSent, false);
      } else {
        showMessage(result.message ?? LocalizationString.errorMessage, true);
      }
    });
  }

  showMessage(String message, bool isError) {
    AppUtil.showToast(message: message, isSuccess: !isError);
  }
}
