import 'package:get/get.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class AuthorController extends GetxController {
  RxList<BlogPostModel> posts = <BlogPostModel>[].obs;
  Rx<AuthorModel?> author = Rx<AuthorModel?>(null);
  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  Rx<int> selectedTab = 0.obs;
  bool isLoading = false;
  RxInt selectedCategoryIndex = 0.obs;

  clear() {
    posts.clear();
    author.value = null;
    categories.clear();
  }

  selectCategory(int index) {
    if (selectedCategoryIndex.value != index) {
      posts.value = [];
      selectedCategoryIndex.value = index;
      loadAuthorPosts(
          authorId: author.value!.id, categoryId: categories[index].id);
      update();
    }
  }

  changeTab(int index) {
    selectedTab.value = index;
    update();
  }

  getAuthorDetail({required String id}) {
    isLoading = true;
    getIt<FirebaseManager>().getAuthorDetail(id).then((result) {
      author.value = result;
      isLoading = false;
      getAllCategories(id: id);
      update();
    });
  }

  void getAllCategories({required String id}) async {
    categories.clear();

    List<CategoryModel> allCategories = [];

    var responses = await Future.wait([
      getAuthorCategories(id: id),
      getAdminCategories(),
    ]);

    allCategories.addAll(responses[0]);
    allCategories.addAll(responses[1]);

    categories.value = allCategories
        .where((element) => author.value!.usedCategories.contains(element.id))
        .toList();

    isLoading = false;
    if (categories.isNotEmpty) {
      loadAuthorPosts(authorId: id, categoryId: categories.first.id);
    }
    update();

    update();
  }

  Future<List<CategoryModel>> getAuthorCategories({required String id}) async {
    List<CategoryModel> list = [];
    await AppUtil.checkInternet().then((value) async {
      if (value) {
        await getIt<FirebaseManager>().getAuthorCategories(id).then((result) {
          list = result;
        });
      } else {}
    });
    return list;
  }

  Future<List<CategoryModel>> getAdminCategories() async {
    List<CategoryModel> list = [];

    await AppUtil.checkInternet().then((value) async {
      if (value) {
        await getIt<FirebaseManager>().searchCategories().then((result) {
          list = result;
        });
      } else {}
    });
    return list;
  }

  // getAuthorCategories({required String id}) {
  //   isLoading = true;
  //   getIt<FirebaseManager>().getAuthorCategories(id).then((result) {
  //     categories.value = result;
  //     print(categories.length);
  //     isLoading = false;
  //     if (result.isNotEmpty) {
  //       loadAuthorPosts(authorId: id, categoryId: result.first.id);
  //     }
  //     update();
  //   });
  // }

  loadAuthorPosts({
    String? categoryId,
    String? authorId,
  }) {
    PostSearchParamModel searchParamModel =
        PostSearchParamModel(userId: authorId, categoryId: categoryId);
    getIt<FirebaseManager>()
        .searchPosts(
      searchModel: searchParamModel,
    )
        .then((response) {
      posts.value = response.result as List<BlogPostModel>;

      update();
    });
  }

  void followUnfollowUser() {
    if (getIt<UserProfileManager>().isLogin() == false) {
      Get.to(() => const AskForLogin());
      return;
    }

    bool isFollowing = false;
    if (author.value!.isFollowing() == true) {
      getIt<UserProfileManager>()
          .user!
          .followingProfiles
          .remove(author.value!.id);
      author.value!.totalFollowers -= 1;
      isFollowing = false;
    } else {
      getIt<UserProfileManager>().user!.followingProfiles.add(author.value!.id);
      author.value!.totalFollowers += 1;
      isFollowing = true;
    }

    update();

    AppUtil.checkInternet().then((value) async {
      if (value) {
        if (isFollowing) {
          getIt<FirebaseManager>()
              .followUser(id: author.value!.id, isAuthor: true);
        } else {
          getIt<FirebaseManager>()
              .unFollowUser(id: author.value!.id, isSource: true);
        }
      } else {
        // AppUtil.showToast(
        //     message: LocalizationString.noInternet, isSuccess: true);
      }
    });

    update();
  }

  reportAuthor() {
    if (getIt<UserProfileManager>().isLogin() == false) {
      Get.to(() => const AskForLogin());
      return;
    }
    getIt<FirebaseManager>()
        .reportAbuse(author.value!.id, author.value!.name, DataType.author)
        .then((value) {
      // AppUtil.showToast(
      //     message: LocalizationString.sourceReported, isSuccess: true);
    });
  }
}
