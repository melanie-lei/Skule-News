import 'package:flutter/material.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class ChangePassword extends StatefulWidget {
  final CategoryModel? genre;

  const ChangePassword({Key? key, this.genre}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final ChangePasswordController changePasswordController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
              TitleBar(title: LocalizationString.changePwd),
              const SizedBox(
                height: 20,
              ),
              Text(
                LocalizationString.newPassword,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(() => PasswordField(
                    controller: changePasswordController.newPassword.value,
                    showBorder: true,
                    cornerRadius: 5,
                    onChanged: (text) {},
                  )),
              const SizedBox(
                height: 20,
              ),
              Text(
                LocalizationString.confirmPassword,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(() => PasswordField(
                    controller: changePasswordController.confirmPassword.value,
                    showBorder: true,
                    cornerRadius: 5,
                    onChanged: (text) {},
                  )),
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
                      changePasswordController.changePassword();
                    }),
              )
            ],
          ),
        ],
      ).p25,
    );
  }
}
