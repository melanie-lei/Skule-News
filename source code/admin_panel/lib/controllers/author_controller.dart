import 'package:get/get.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';

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

  getSourceDetail({required String id}) {
    isLoading = true;
    getIt<FirebaseManager>().getSourceDetail(id).then((result) {
      author.value = result;

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
    BlogPostSearchParamModel searchParamModel =
        BlogPostSearchParamModel(userId: reporterId, approvedStatus: 1);
    getIt<FirebaseManager>()
        .searchPosts(
      searchModel: searchParamModel,
    )
        .then((result) {
      posts.value = result;
      update();
    });
  }

  getAllUsers() {
    getIt<FirebaseManager>()
        .searchAuthorProfiles(
            searchText: (searchText ?? '').isNotEmpty ? searchText : null,
            type: accountStatusType == AccountStatusType.active ? 1 : 0)
        .then((result) {
      authors.value = result;
      update();
    });
  }

  deleteUser(AuthorsModel model) {
    getIt<FirebaseManager>().deleteAuthor(model);
    authors.remove(model);
    update();
  }

  getReportedAuthors() {
    EasyLoading.show(status: LocalizationString.loading);
    getIt<FirebaseManager>().getAllReportedAuthors().then((result) {
      EasyLoading.dismiss();
      authors.value = result;
      update();
    });
  }

  deleteRequestForAuthor(AuthorsModel modal) {
    authors.removeWhere((element) => element.id == modal.id);
    update();

    getIt<FirebaseManager>().deleteAuthorReport(modal).then((value) {});
    update();
  }

  deactivateAuthor(AuthorsModel modal) {
    authors.removeWhere((element) => element.id == modal.id);

    update();

    getIt<FirebaseManager>().deleteAuthor(modal).then((value) {
      deleteRequestForAuthor(modal);
    });
    update();
  }
}
