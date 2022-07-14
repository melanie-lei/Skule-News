import 'package:flutter/material.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class AddPackage extends StatefulWidget {
  final PackageModel? package;

  const AddPackage({Key? key, this.package}) : super(key: key);

  @override
  _AddPackageState createState() => _AddPackageState();
}

class _AddPackageState extends State<AddPackage> {
  final AddPackageController addPackageController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    if (widget.package != null) {
      addPackageController.setPackage(widget.package!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: widget.package != null
          ? BackNavigationBar(title: LocalizationString.back)
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleBar(title: LocalizationString.addPackage),
          const SizedBox(
            height: 25,
          ),
          Text(LocalizationString.packageName,
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(
            height: 10,
          ),
          Obx(() => InputField(
                controller: addPackageController.name.value,
                cornerRadius: 5,
              )),
          const SizedBox(
            height: 20,
          ),
          Text(LocalizationString.packagePrice,
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(
            height: 10,
          ),
          Obx(() => InputField(
                controller: addPackageController.price.value,
                cornerRadius: 5,
              )),
          const SizedBox(
            height: 20,
          ),
          Text(LocalizationString.iosInAppId,
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(
            height: 10,
          ),
          Obx(() => InputField(
                controller: addPackageController.iOSInAppId.value,
                cornerRadius: 5,
              )),
          const SizedBox(
            height: 20,
          ),
          Text(LocalizationString.androidInAppId,
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(
            height: 10,
          ),
          Obx(() => InputField(
                controller: addPackageController.androidInAppId.value,
                cornerRadius: 5,
              )),
          const SizedBox(
            height: 40,
          ),
          Center(
            child: SizedBox(
                width: 150,
                height: 60,
                child: FilledButtonType1(
                    enabledTextStyle: Theme.of(context).textTheme.titleMedium,
                    text: LocalizationString.submit,
                    onPress: () {
                      addPackageController.submit();
                    })),
          )
        ],
      ).p25,
    );
  }
}
