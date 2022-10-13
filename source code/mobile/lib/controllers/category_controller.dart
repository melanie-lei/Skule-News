import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:skule_news_mobile/helper/common_import.dart';

class CategoryController extends GetxController {
  final DashboardController dashboardController = Get.find();
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxList<CategoryModel> selectedCategories = <CategoryModel>[].obs;

  bool isLoading = false;
  RxInt selectedCategoryIndex = 0.obs;

  clear() {
    dashboardController.clearPosts();
    categories.value = [];
  }

  selectCategory({required CategoryModel category}) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    update();
  }

  handleCategoryTap({required int index, required bool isVideo}) {
    selectedCategoryIndex.value = index;
    if (categories[index].id.isEmpty) {
      if(categories[index].name == LocalizationString.following){
        dashboardController.prepareSearchQueryWithFollowers();
        dashboardController.loadFollowingUsersPosts(callBack: (){});
      }
      else{
        dashboardController.prepareSearchQuery();
        dashboardController.loadPosts(callBack: () {});
      }
    } else {
      dashboardController
          .prepareSearchQueryWithCategoryId(categories[index].id);
      dashboardController.loadPosts(callBack: () {});
    }
    update();
  }

  loadCategories({
    bool? isVideo,
    String? searchText,
    DataType? dataType,
    required bool needDefaultCategory,
    VoidCallback? callBack,
  }) {
    isLoading = true;
    getIt<FirebaseManager>()
        .searchCategories(searchText: searchText)
        .then((result) {
      if (needDefaultCategory == true) {
        CategoryModel defaultCategory1 =
            CategoryModel(id: '', name: LocalizationString.forYou, status: 1,totalBlogPosts: 0);
        CategoryModel defaultCategory2 =
        CategoryModel(id: '', name: LocalizationString.following, status: 1,totalBlogPosts: 0);
        result.insert(0, defaultCategory1);
        result.insert(1, defaultCategory2);
      }
      categories.value = result;

      if (getIt<UserProfileManager>().user != null) {
        selectedCategories.value = categories
            .where((category) => getIt<UserProfileManager>()
                .user!
                .followingCategories
                .contains(category.id))
            .toList();
      }

      isLoading = false;
      update();

      if (callBack != null) {
        callBack();
      }
    });
  }

  updateInterest(VoidCallback callback) {
    getIt<FirebaseManager>()
        .updateCategoryPref(
            ids: selectedCategories.map((element) => element.id).toList())
        .then((value) {
      callback();
    });
  }
}
