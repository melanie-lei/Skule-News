import 'package:flutter/material.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class PackagesList extends StatefulWidget {
  const PackagesList({Key? key}) : super(key: key);

  @override
  _PackagesListState createState() => _PackagesListState();
}

class _PackagesListState extends State<PackagesList> {
  TextEditingController search = TextEditingController();
  final PackageController packageController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    packageController.getAllPackages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SizedBox(
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleBar(title: LocalizationString.categories),
            const SizedBox(
              height: 20,
            ),
            Obx(() => Text(
                  '${packageController.packages.length} ${LocalizationString.packages.toLowerCase()}',
                  style: Theme.of(context).textTheme.bodyLarge,
                )),
            const Divider(
              height: 50,
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).backgroundColor.darken(0.04),
                child: GetBuilder<PackageController>(
                    init: packageController,
                    builder: (ctx) {
                      return ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: packageController.packages.length,
                          itemBuilder: (BuildContext context, int index) {
                            return PackageTile(
                              package: packageController.packages[index],
                              deleteCallback: () {
                                packageController.deletePackage(
                                    packageController.packages[index]);
                              },
                            ).ripple(() {
                              Get.to(() => AddPackage(
                                  package: packageController.packages[index]));
                            });
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              height: 20,
                            );
                          }).p25;
                    }),
              ).round(20),
            ),
          ],
        ),
      ).p25,
    );
  }
}
