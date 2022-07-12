import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:music_streaming_mobile/model/post_search_parameter_model.dart';

class SavedPostsController extends GetxController {
  RxList<NewsModel> posts = <NewsModel>[].obs;
  RxBool isLoading = true.obs;
  PostSearchParamModel postSearchParamModel = PostSearchParamModel();

  loadPosts({required List<String> postIds, required VoidCallback callBack}) {
    isLoading.value = true;
    update();
    getIt<FirebaseManager>()
        .searchPosts(searchModel: postSearchParamModel)
        .then((result) {
      posts.value = result;
      isLoading.value = false;
      callBack();
      update();
    });
  }
}
