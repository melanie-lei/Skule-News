import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class SeeAllPostsController extends GetxController {
  RxList<BlogPostModel> posts = <BlogPostModel>[].obs;
  RxBool isLoading = false.obs;

  clear() {
    posts.clear();
    isLoading.value = false;
  }

  loadPosts(PostSearchParamModel searchModel) {
    isLoading.value = true;

    getIt<FirebaseManager>()
        .searchPosts(
      searchModel: searchModel,
    )
        .then((response) {
      isLoading.value = false;
      posts.value = response.result as List<BlogPostModel>;

      update();
    });
  }
}
