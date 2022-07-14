import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class SavedPostsController extends GetxController {
  RxList<BlogPostModel> posts = <BlogPostModel>[].obs;
  RxBool isLoading = true.obs;
  PostSearchParamModel postSearchParamModel = PostSearchParamModel();

  List<String> postIds = [];

  setAllSavedPosts() {
    postIds = List.from(getIt<UserProfileManager>().user?.savedPost ?? []);
  }

  clear(){
    // posts.clear();
    // setAllSavedPosts();
  }

  loadPosts({required VoidCallback callBack}) {
    List<String> firstTenPostIds = [];

    if (postIds.length > 10) {
      firstTenPostIds = List.from(postIds.sublist(0, 10));
      postIds.removeRange(0, 10);
    } else if (postIds.isNotEmpty) {
      firstTenPostIds = List.from(postIds.sublist(0, postIds.lastIndex));
      postIds.clear();
    }

    if (firstTenPostIds.isNotEmpty) {
      postSearchParamModel.postIds = firstTenPostIds;
      isLoading.value = true;
      update();
      getIt<FirebaseManager>()
          .searchPosts(searchModel: postSearchParamModel)
          .then((response) {
        posts.addAll(response.result as List<BlogPostModel>);
        isLoading.value = false;
        callBack();
        update();
      });
    } else {
      callBack();
      update();
    }
  }
}
