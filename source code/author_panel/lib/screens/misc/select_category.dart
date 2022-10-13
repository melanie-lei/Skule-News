import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class SelectCategory extends StatefulWidget {
  final void Function(CategoryModel) callback;

  const SelectCategory({Key? key, required this.callback}) : super(key: key);

  @override
  _SelectCategoryState createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  final CategoryController categoryController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    categoryController.setStatusType(1);
    categoryController.getAllCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor.lighten(0.2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ThemeIconWidget(
                  ThemeIcon.close,
                  color: Theme.of(context).iconTheme.color,
                  size: 40,
                ).ripple(() {
                  Get.back();
                }),
                Text(
                  LocalizationString.selectCategory,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  width: 40,
                  height: 40,
                )
              ],
            ).p25,
          ).round(20).p25,
          Expanded(
            child: Container(
              color: Theme.of(context).backgroundColor.darken(),
              child: GetBuilder<CategoryController>(
                  init: categoryController,
                  builder: (ctx) {
                    return ListView.separated(
                      padding: const EdgeInsets.only(top: 25),
                      itemCount: categoryController.categories.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return CategoryHorizontalTile(
                                genre: categoryController.categories[index])
                            .ripple(() {
                          widget.callback(categoryController.categories[index]);
                          Get.back();
                        });
                      },
                      separatorBuilder: (BuildContext ctx, int index) {
                        return const SizedBox(
                          height: 20,
                        );
                      },
                    ).hP25;
                  }),
            ).round(20).p25,
          )
        ],
      ),
    );
  }
}
