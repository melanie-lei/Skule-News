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

  /// Selects all post in a category created by the author.
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

  /// Loads the information of an author. Results are stored in [author.value].
  getSourceDetail({required String id}) {
    isLoading = true;
    getIt<FirebaseManager>().getSourceDetail(id).then((result) {
      author.value = result;

      isLoading = false;
      update();
    });
  }

  /// Loads an author's categories. Results are stored in [categories.value].
  /// 
  /// Author categories are deprecated. This will almost certainly not work.
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

  /// Loads the posts by an author. Results are stored in [posts.value].
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

  /// Loads all active or inactive authors based on a search term. Results are 
  /// stored in [authors.value].
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

  /// Deletes an author from the database.
  /// 
  /// Does not actually remove the author from the databse, but "deactivates" it.
  deleteUser(AuthorsModel model) {
    getIt<FirebaseManager>().deleteAuthor(model);
    authors.remove(model);
    update();
  }

  /// Loads all reported authors. Results are stored in [authors.value].
  getReportedAuthors() {
    EasyLoading.show(status: LocalizationString.loading);
    getIt<FirebaseManager>().getAllReportedAuthors().then((result) {
      EasyLoading.dismiss();
      authors.value = result;
      update();
    });
  }

  /// Deletes all reports for an author.
  deleteRequestForAuthor(AuthorsModel model) {
    authors.removeWhere((element) => element.id == model.id);
    update();

    getIt<FirebaseManager>().deleteAuthorReport(model).then((value) {});
    update();
  }

  /// Deactivates the author.
  deactivateAuthor(AuthorsModel model) {
    authors.removeWhere((element) => element.id == model.id);

    update();

    getIt<FirebaseManager>().deleteAuthor(model).then((value) {
      deleteRequestForAuthor(model);
    });
    update();
  }

  reactivateAuthor(AuthorsModel model) {
    getIt<FirebaseManager>().reactivateAuthor(model);
    authors.removeWhere((element) => element.id == model.id);
    update();
  }
}
