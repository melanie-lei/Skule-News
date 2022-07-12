import 'package:get/get.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class SourceController extends GetxController {
  RxList<NewsModel> posts = <NewsModel>[].obs;
  Rx<NewsSourceModel?> reporter = Rx<NewsSourceModel?>(null);
  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  Rx<int> selectedTab = 0.obs;
  bool isLoading = false;
  RxInt selectedCategoryIndex = 0.obs;

  selectCategory(int index) {
    if (selectedCategoryIndex.value != index) {
      posts.value = [];
      selectedCategoryIndex.value = index;
      loadSourcePosts(
          reporterId: reporter.value!.id, categoryId: categories[index].id);
      update();
    }
  }

  changeTab(int index) {
    selectedTab.value = index;
    update();
  }

  getSourceDetail({required String id}) {
    isLoading = true;
    getIt<FirebaseManager>().getSourceDetail(id).then((result) {
      reporter.value = result;
      isLoading = false;
      update();
    });
  }

  getSourceCategories({required String id}) {
    isLoading = true;
    getIt<FirebaseManager>().getSourceCategories(id).then((result) {
      categories.value = result;
      isLoading = false;
      if (result.isNotEmpty) {
        loadSourcePosts(reporterId: id, categoryId: result.first.id);
      }
      update();
    });
  }

  loadSourcePosts({
    String? categoryId,
    String? reporterId,
  }) {
    PostSearchParamModel searchParamModel =
        PostSearchParamModel(userId: reporterId);
    getIt<FirebaseManager>()
        .searchPosts(
      searchModel: searchParamModel,
    )
        .then((result) {
      posts.value = result;
      update();
    });
  }

  void followUnfollowUser() {
    if (getIt<UserProfileManager>().isLogin() == false) {
      Get.to(() => const AskForLogin());
      return;
    }

    bool isFollowing = false;
    if (reporter.value!.isFollowing() == true) {
      getIt<UserProfileManager>()
          .user!
          .followingProfiles
          .remove(reporter.value!.id);
      reporter.value!.totalFollowers -= 1;
      isFollowing = false;
    } else {
      getIt<UserProfileManager>()
          .user!
          .followingProfiles
          .add(reporter.value!.id);
      reporter.value!.totalFollowers += 1;
      isFollowing = true;
    }

    update();

    AppUtil.checkInternet().then((value) async {
      if (value) {
        if (isFollowing) {
          getIt<FirebaseManager>()
              .followUser(id: reporter.value!.id, isSource: true);
        } else {
          getIt<FirebaseManager>()
              .unFollowUser(id: reporter.value!.id, isSource: true);
        }
      } else {
        // AppUtil.showToast(
        //     message: LocalizationString.noInternet, isSuccess: true);
      }
    });

    update();
  }

  reportSource() {
    if (getIt<UserProfileManager>().isLogin() == false) {
      Get.to(() => const AskForLogin());
      return;
    }
    getIt<FirebaseManager>()
        .reportAbuse(reporter.value!.id, reporter.value!.name, DataType.source)
        .then((value) {
      // AppUtil.showToast(
      //     message: LocalizationString.sourceReported, isSuccess: true);
    });
  }
}
