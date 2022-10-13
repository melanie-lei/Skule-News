import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class AddNewCategory extends StatefulWidget {
  final CategoryModel? category;

  const AddNewCategory({Key? key, this.category}) : super(key: key);

  @override
  _AddNewCategoryState createState() => _AddNewCategoryState();
}

class _AddNewCategoryState extends State<AddNewCategory> {
  final AddCategoryController addCategoryController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    if (widget.category != null) {
      addCategoryController.setCategory(widget.category!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: widget.category != null
          ? BackNavigationBar(title: LocalizationString.back)
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleBar(title: LocalizationString.addCategory),
              const SizedBox(
                height: 20,
              ),
              Text(
                LocalizationString.categoryImage,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Obx(() => InputField(
                          controller: addCategoryController.categoryCover.value,
                          showBorder: true,
                          cornerRadius: 5,
                        )),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 60,
                    width: 120,
                    child: FilledButtonType1(
                        text: LocalizationString.choose,
                        enabledTextStyle:
                            Theme.of(context).textTheme.titleMedium,
                        onPress: () {
                          addCategoryController.pickFile();
                        }),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Text(LocalizationString.categoryName,
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(
            height: 10,
          ),
          Obx(() => InputField(
                controller: addCategoryController.name.value,
                showBorder: true,
                cornerRadius: 5,
              )),
          const SizedBox(
            height: 20,
          ),
          Text(LocalizationString.status,
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(
            height: 10,
          ),
          Obx(() => HandleAvailabilityStatus(
              status: addCategoryController.availabilityStatus.value,
              statusHandler: (status) {
                addCategoryController.setAvailabilityStatus(status);
              })).vP8,
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
                      addCategoryController.addCategory();
                    })),
          )
        ],
      ).p25,
    );
  }

}
