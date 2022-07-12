import 'package:get/get.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';

class AuthorController extends GetxController {
  RxList<BlogPostModel> posts = <BlogPostModel>[].obs;
  Rx<AuthorsModel?> author = Rx<AuthorsModel?>(null);
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxList<AuthorsModel> authors = <AuthorsModel>[].obs;

  Rx<int> selectedTab = 0.obs;
  bool isLoading = false;
  RxInt selectedCategoryIndex = 0.obs;

  String? searchText;
  AccountStatusType accountStatusType = AccountStatusType.active;

  setAuthor(){
    author.value = getIt<UserProfileManager>().user!;
    update();
  }

  searchTextChanged(String text) {
    searchText = text;
  }

  setStatusType(AccountStatusType type) {
    accountStatusType = type;
  }

  selectCategory(int index) {
    if (selectedCategoryIndex.value != index) {
      posts.value = [];
      selectedCategoryIndex.value = index;
      loadSourcePosts(
          reporterId: author.value!.id, categoryId: categories[index].id);
      update();
    }
  }

  changeTab(int index) {
    selectedTab.value = index;
    update();
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
    BlogPostSearchParamModel searchParamModel =
        BlogPostSearchParamModel(userId: reporterId);
    getIt<FirebaseManager>()
        .searchPosts(
      searchModel: searchParamModel,
    )
        .then((result) {
      posts.value = result;
      update();
    });
  }

}
