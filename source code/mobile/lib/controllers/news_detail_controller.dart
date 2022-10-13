import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class NewsDetailController extends GetxController {
  RxList<BlogPostModel> similarNews = <BlogPostModel>[].obs;
  Rx<BlogPostModel?> model = Rx<BlogPostModel?>(null);
  bool isLoading = false;

  setCurrentNewsPost(BlogPostModel post) {
    model.value = post;
  }

  loadSimilarPosts({
    String? categoryId,
    List<String>? hashtags,
  }) {
    isLoading = true;

    PostSearchParamModel postSearchModel =
        PostSearchParamModel(categoryId: categoryId, hashtags: hashtags);
    getIt<FirebaseManager>()
        .searchPosts(
      searchModel: postSearchModel,
    )
        .then((response) {
      isLoading = false;
      similarNews.value = response.result as List<BlogPostModel>;

      update();
    });
  }

  void saveOrDeletePost() {
    if (getIt<UserProfileManager>().isLogin() == false) {
      Get.to(() => const AskForLogin());
      return;
    }
    bool isSaved = false;

    if (model.value!.isSaved() == true) {
      getIt<UserProfileManager>().user!.savedPost.remove(model.value!.id);
      model.value!.totalSaved -= 1;
      isSaved = false;
    } else {
      getIt<UserProfileManager>().user!.savedPost.add(model.value!.id);
      model.value!.totalSaved += 1;
      isSaved = true;
    }

    model.refresh();

    AppUtil.checkInternet().then((value) async {
      if (value) {
        if (isSaved) {
          getIt<FirebaseManager>().savePost(model.value!.id);
        } else {
          getIt<FirebaseManager>().removeSavedPost(model.value!.id);
        }
      } else {
        // AppUtil.showToast(
        //     message: LocalizationString.noInternet, isSuccess: true);
      }
    });
  }

  reportPost(BlogPostModel post) {
    if (getIt<UserProfileManager>().isLogin() == false) {
      Get.to(() => const AskForLogin());
      return;
    }
    getIt<FirebaseManager>()
        .reportAbuse(post.id, post.title, DataType.blogPost)
        .then((value) {
      // AppUtil.showToast(
      //     message: LocalizationString.newsReported, isSuccess: true, context: null);
    });
  }
}
