import 'package:flutter/material.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class CategoriesList extends StatefulWidget {
  final CategoryStatusType statusType;

  const CategoriesList({Key? key, required this.statusType}) : super(key: key);

  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  TextEditingController search = TextEditingController();
  final CategoryController categoryController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    categoryController.getCategories();
    super.initState();
  }

  loadData() {
    categoryController
        .setStatusType(widget.statusType == CategoryStatusType.active ? 1 : 0);
    categoryController.getCategories();
  }

  @override
  void didUpdateWidget(covariant CategoriesList oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    loadData();
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
            TitleBar(
                title: widget.statusType == CategoryStatusType.active
                    ? LocalizationString.categories
                    : LocalizationString.deActivatedCategory),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Obx(() => Text(
                      '${categoryController.categories.length} ${LocalizationString.category.toLowerCase()}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    )),
                const Spacer(),
                Expanded(
                  child: InputField(
                    controller: search,
                    hintText: LocalizationString.searchCategory,
                    onChanged: (text) {
                      categoryController.searchTextChanged(text);
                      categoryController.getCategories();
                    },
                  ).shadow(shadowOpacity: 0.2, context: context),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            const Divider(
              height: 50,
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).backgroundColor.darken(0.04),
                child: GetBuilder<CategoryController>(
                    init: categoryController,
                    builder: (ctx) {
                      return GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: categoryController.categories.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            crossAxisCount: Responsive.isDesktop(context)
                                ? 5
                                : Responsive.isTablet(context)
                                    ? 4
                                    : 3),
                        itemBuilder: (BuildContext context, int index) {
                          return CategoryTile(
                                  category:
                                      categoryController.categories[index])
                              .ripple(() {
                            Get.to(() => AddNewCategory(
                                category:
                                    categoryController.categories[index]));
                          });
                        },
                      ).p25;
                    }),
              ).round(20),
            ),
          ],
        ),
      ).p25,
    );
  }
}
