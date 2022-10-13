import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final CategoryController categoryController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      categoryController.loadCategories(needDefaultCategory: false);
      categoryController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      // appBar: CustomNavigationBar(
      //   child: appBar(),
      // ),
      body: Column(
        children: [
          Container(
            height: 120,
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 5,
                      height: 25,
                      color: Theme.of(context).primaryColor.darken(),
                    ).round(10),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      LocalizationString.categories,
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontWeight: FontWeight.w900),
                    ),
                  ],
                ).p16,
              ],
            ),
          ),
          Expanded(child: categoriesView().hP16),
        ],
      ),
    );
  }

  Widget categoriesView() {
    return GetBuilder<CategoryController>(
        init: categoryController,
        builder: (ctx) {
          return categoryController.isLoading == true
              ? const CategoryShimmer()
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: GridView.builder(
                    padding: const EdgeInsets.only(top: 20),
                    itemCount: categoryController.categories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1,
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5),
                    itemBuilder: (BuildContext context, int index) {
                      return CategoryTile(
                              isLargeText: true,
                              category: categoryController.categories[index])
                          .ripple(() {
                        Get.to(() => CategoryPosts(
                            category: categoryController.categories[index]));
                      });
                    },
                  ),
                );
        });
  }
}
