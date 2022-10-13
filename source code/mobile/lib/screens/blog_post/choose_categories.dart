import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class ChooseCategories extends StatefulWidget {
  const ChooseCategories({Key? key}) : super(key: key);

  @override
  State<ChooseCategories> createState() => _ChooseCategoriesState();
}

class _ChooseCategoriesState extends State<ChooseCategories> {
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
      appBar: CustomNavigationBar(
        child: appBar(),
      ),
      body: Stack(
        children: [
          categoriesView(),
          Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                child: FilledButtonType1(
                  cornerRadius: 25,
                  text: LocalizationString.done,
                  enabledTextStyle: Theme.of(context).textTheme.titleLarge,
                  onPress: () {
                    if (categoryController.selectedCategories.isNotEmpty) {
                      categoryController.updateInterest(() {
                        getIt<UserProfileManager>().refreshProfile();
                        Get.to(() => const MainScreen());
                      });
                    } else {
                      AppUtil.showToast(
                          message:
                              LocalizationString.pleaseSelectSomeCategories,
                          isSuccess: false);
                    }
                  },
                ),
              ))
        ],
      ).hP16,
    );
  }

  Widget appBar() {
    return Text(
      LocalizationString.selectCategory,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget categoriesView() {
    return GetBuilder<CategoryController>(
        init: categoryController,
        builder: (ctx) {
          return categoryController.isLoading == true
              ? const CategoryShimmer()
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: GridView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: categoryController.categories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1,
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5),
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        children: [
                          CategoryTile(
                            isLargeText: false,
                              category: categoryController.categories[index]),
                          Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              top: 0,
                              child: categoryController.selectedCategories
                                      .contains(
                                          categoryController.categories[index])
                                  ? Container(
                                      color: Colors.black54,
                                      child: const ThemeIconWidget(
                                        ThemeIcon.checkMarkWithCircle,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Container())
                        ],
                      ).ripple(() {
                        categoryController.selectCategory(
                            category: categoryController.categories[index]);
                      });
                    },
                  ),
                );
        });
  }
}
