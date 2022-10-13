import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class PendingBlogsController extends GetxController {
  RxList<BlogPostModel> pendingApprovalBlogs = <BlogPostModel>[].obs;

  Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);
  String? searchText;

  searchTextChanged(String text) {
    searchText = text;
  }

  selectCategory(CategoryModel category) {
    selectedCategory.value = category;
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

  approveBlog(BlogPostModel model) {
    EasyLoading.show(status: LocalizationString.loading);
    FirebaseManager().approveBlogPost(model).then((value) {
      EasyLoading.dismiss();
      getPendingBlogs();
    });
  }

  rejectBlog(BlogPostModel model) {
    EasyLoading.show(status: LocalizationString.loading);
    FirebaseManager().rejectBlogPost(model).then((value) {
      EasyLoading.dismiss();
      getPendingBlogs();
    });
  }
}
