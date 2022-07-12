import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class BlogPostDetailController extends GetxController {
  RxList<BlogPostModel> similarNews = <BlogPostModel>[].obs;
  Rx<BlogPostModel?> model = Rx<BlogPostModel?>(null);
  bool isLoading = false;

  setCurrentBlogPost(BlogPostModel post) {
    model.value = post;
  }

  loadSimilarPosts({
    String? categoryId,
    List<String>? hashtags,
  }) {
    isLoading = true;

    BlogPostSearchParamModel postSearchModel =
    BlogPostSearchParamModel(categoryId: categoryId, hashtags: hashtags);
    getIt<FirebaseManager>()
        .searchPosts(
      searchModel: postSearchModel,
    )
        .then((result) {
      isLoading = false;
      similarNews.value = result;
      update();
    });
  }

}
