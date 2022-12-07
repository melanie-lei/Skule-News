import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class SendAlert extends StatefulWidget {
  const SendAlert({Key? key}) : super(key: key);

  @override
  _SendAlertState createState() => _SendAlertState();
}

class _SendAlertState extends State<SendAlert> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String? title;
  String? message;
  var titleField = TextEditingController();
  var messageField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleBar(title: LocalizationString.sendAlert),
              const SizedBox(
                height: 20,
              ),
              Text(
                LocalizationString.alertDescription,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                LocalizationString.alertTitle,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 10,
              ),
              InputField(
                showBorder: true,
                cornerRadius: 5,
                cursorColor: Colors.black12,
                controller: titleField,
                onChanged: (t) {
                  title = t;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                LocalizationString.alertMessage,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 10,
              ),
              InputField(
                showBorder: true,
                cornerRadius: 5,
                cursorColor: Colors.black12,
                controller: messageField,
                onChanged: (m) {
                  message = m;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: 120,
                child: FilledButtonType1(
                    text: LocalizationString.submit,
                    enabledTextStyle: Theme.of(context).textTheme.titleMedium,
                    onPress: () {
                      EasyLoading.show(status: LocalizationString.loading);
                      if (title != null && message != null) {
                        NotificationHelper.pushAlert(title!, message!);
                        AppUtil.showToast(
                            message: LocalizationString.alertSuccess,
                            isSuccess: true);
                        titleField.clear();
                        messageField.clear();
                      } else {
                        AppUtil.showToast(
                            message: LocalizationString.pleaseFillInAllFields,
                            isSuccess: false);
                      }
                      EasyLoading.dismiss();
                    }),
              )
            ],
          ),
        ],
      ).p25,
    );
  }
}
