import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class AddAdmin extends StatefulWidget {
  const AddAdmin({Key? key}) : super(key: key);

  @override
  _AddAdminState createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  final AddUsersController addUsersController = Get.find();

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
        children: [
          TitleBar(title: LocalizationString.addAdmin).p25,
          Expanded(
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: addUsers().p25,
            ),
          ),
        ],
      ),
    );
  }

  Widget addUsers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            'Authorize new administrators',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          padding: EdgeInsets.fromLTRB(20.0, 0, 0, 45.0),
        ),
        addAdminWidget(),
        const SizedBox(height: 40),
        Center(
            child: SizedBox(
                width: 150,
                height: 60,
                child: FilledButtonType1(
                    enabledTextStyle: Theme.of(context).textTheme.titleMedium,
                    text: LocalizationString.submit,
                    onPress: () {
                      addUsersController.addAdmin();
                    })))
      ],
    ).vP25;
  }

  Widget addAdminWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalizationString.email,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Obx(() => InputField(
                  controller: addUsersController.newAdminEmail.value,
                  showBorder: true,
                  cornerRadius: 5)),
            ),
            const SizedBox(width: 20),
          ],
        ),
        Text(
          LocalizationString.password,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Obx(() => InputField(
                  controller: addUsersController.newAdminPassword.value,
                  showBorder: true,
                  cornerRadius: 5)),
            ),
            const SizedBox(width: 20),
          ],
        ),
        Text(
          "Admin Password",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Obx(() => InputField(
                  controller: addUsersController.adminPassword.value,
                  showBorder: true,
                  cornerRadius: 5)),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ],
    );
  }
}
