import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class AddUsers extends StatefulWidget {
  const AddUsers({Key? key}) : super(key: key);

  @override 
  _AddUsersState createState() => _AddUsersState();
}

class _AddUsersState extends State<AddUsers> {
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
          TitleBar(title: LocalizationString.addUsers).p25,
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
        postSheetWidget(),
        const SizedBox(height: 40),
        Center(
          child: SizedBox(
            width: 150,
            height: 60,
            child: FilledButtonType1(
              enabledTextStyle: Theme.of(context).textTheme.titleMedium,
              text: LocalizationString.submit,
              onPress: () {
                addUsersController.submit();
              }
            )
          )
        )
      ],
    ).vP25;
  }

  Widget postSheetWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalizationString.addUsers,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Obx(() => InputField(
                controller: addUsersController.usersFileName.value,
                showBorder: true,
                cornerRadius: 5
              )),
            ),
            const SizedBox(width: 20),
            SizedBox(
              height: 60,
              width: 120,
              child: FilledButtonType1(
                enabledTextStyle: Theme.of(context).textTheme.titleMedium,
                text: LocalizationString.choose,
                onPress: () {
                  addUsersController.pickUsersFile();
                })
            )
          ],
        ),
      ],
    );
  }
}