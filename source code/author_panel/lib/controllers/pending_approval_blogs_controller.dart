import 'package:music_streaming_admin_panel/helper/common_import.dart';
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

  getPendingBlogs(BlogStatusType statusType) {
    BlogPostSearchParamModel searchParamModel = BlogPostSearchParamModel();
    searchParamModel.categoryId = selectedCategory.value?.id;
    searchParamModel.searchText =
        (searchText ?? '').isNotEmpty ? searchText : null;
    searchParamModel.approvedStatus =
        statusType == BlogStatusType.pending ? 0 : -1;
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
}
