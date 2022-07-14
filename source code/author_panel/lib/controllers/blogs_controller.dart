import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class BlogsController extends GetxController {
  RxList<BlogPostModel> activeBlogs = <BlogPostModel>[].obs;
  RxList<BlogPostModel> pendingApprovalBlogs = <BlogPostModel>[].obs;

  Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);
  String? searchText;

  searchTextChanged(String text) {
    searchText = text;
  }

  selectCategory(CategoryModel category) {
    selectedCategory.value = category;
  }

  getLatestBlogs() {
    getIt<FirebaseManager>()
        .searchPosts(searchModel: BlogPostSearchParamModel(isRecent: true,approvedStatus: 1))
        .then((response) {
      activeBlogs.value = response;
      update();
    });
  }

  getActiveBlogs() {
    BlogPostSearchParamModel searchParamModel = BlogPostSearchParamModel();
    searchParamModel.categoryId = selectedCategory.value?.id;
    searchParamModel.searchText =
        (searchText ?? '').isNotEmpty ? searchText : null;
    searchParamModel.approvedStatus = 1;
    searchParamModel.status = 1;

    getIt<FirebaseManager>()
        .searchPosts(
      searchModel: searchParamModel,
    )
        .then((result) {
      activeBlogs.value = result;
      update();
    });
  }

  getDeActivatedBlogs() {
    BlogPostSearchParamModel searchParamModel = BlogPostSearchParamModel();
    searchParamModel.categoryId = selectedCategory.value?.id;
    searchParamModel.searchText =
        (searchText ?? '').isNotEmpty ? searchText : null;
    // searchParamModel.approved = true;
    searchParamModel.status = 0;

    getIt<FirebaseManager>()
        .searchPosts(
      searchModel: searchParamModel,
    )
        .then((result) {
      activeBlogs.value = result;
      update();
    });
  }

  getPendingBlogs() {
    BlogPostSearchParamModel searchParamModel = BlogPostSearchParamModel();
    searchParamModel.categoryId = selectedCategory.value?.id;
    searchParamModel.searchText =
        (searchText ?? '').isNotEmpty ? searchText : null;
    searchParamModel.approvedStatus = 0;
    searchParamModel.status = 1;

    getIt<FirebaseManager>()
        .searchPosts(
      searchModel: searchParamModel,
    )
        .then((result) {
      pendingApprovalBlogs.value = result;
      update();
    });
  }

  getFeaturedBlogs() {
    BlogPostSearchParamModel searchParamModel = BlogPostSearchParamModel();
    searchParamModel.categoryId = selectedCategory.value?.id;
    searchParamModel.searchText =
        (searchText ?? '').isNotEmpty ? searchText : null;
    searchParamModel.approvedStatus = 1;
    searchParamModel.status = 1;
    searchParamModel.featured = true;

    getIt<FirebaseManager>()
        .searchPosts(
      searchModel: searchParamModel,
    )
        .then((result) {
      activeBlogs.value = result;
      update();
    });
  }

  getReportedBlogs() {
    EasyLoading.show(status: LocalizationString.loading);
    getIt<FirebaseManager>().getAllReportedBlogs().then((result) {
      EasyLoading.dismiss();
      activeBlogs.value = result;
      update();
    });
  }

  addOrRemoveFeaturedBlog(BlogPostModel blogPost) {
    BlogPostModel model = activeBlogs.where((e) => e.id == blogPost.id).first;

    model.isFeatured = !model.isFeatured;

    getIt<FirebaseManager>().addOrRemoveFromFeature(blogPost);
    update();
  }

  addOrRemovePremiumBlog(BlogPostModel blogPost) {
    BlogPostModel model = activeBlogs.where((e) => e.id == blogPost.id).first;

    model.isPremium = !model.isPremium;

    getIt<FirebaseManager>().addOrRemoveFromPremium(blogPost);
    update();
  }
}
