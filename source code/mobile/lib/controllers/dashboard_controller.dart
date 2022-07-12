import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:music_streaming_mobile/model/post_search_parameter_model.dart';

class DashboardController extends GetxController {
  List sections = [].obs;
  RxList<NewsModel> posts = <NewsModel>[].obs;
  RxList<NewsModel> featuredPosts = <NewsModel>[].obs;

  RxBool isLoading = true.obs;

  PostSearchParamModel postSearchParamModel = PostSearchParamModel();

  queryWithFollowers() {
    List<String> followingProfiles =
        getIt<UserProfileManager>().user?.followingProfiles ?? [];
    if (followingProfiles.isNotEmpty) {
      if (followingProfiles.length > 9) {
        postSearchParamModel.userIds = followingProfiles.sublist(0, 9);
      } else {
        postSearchParamModel.userIds = followingProfiles;
      }
    }
  }

  queryWithFollowedCategories() {
    List<String> followingCategories =
        getIt<UserProfileManager>().user?.followingCategories ?? [];
    if (followingCategories.isNotEmpty) {
      if (followingCategories.length > 9) {
        postSearchParamModel.categoryIds = followingCategories.sublist(0, 9);
      } else {
        postSearchParamModel.categoryIds = followingCategories;
      }
    }
  }

  queryWithFollowedHashtags() {
    List<String> followingHashtags =
        getIt<UserProfileManager>().user?.followingHashtags ?? [];

    if (followingHashtags.isNotEmpty) {
      if (followingHashtags.length > 9) {
        postSearchParamModel.hashtags = followingHashtags.sublist(0, 9);
      } else {
        postSearchParamModel.hashtags = followingHashtags;
      }
    }
  }

  prepareSearchQueryWithCategoryId(String categoryId) {
    postSearchParamModel = PostSearchParamModel();
    postSearchParamModel.categoryId = categoryId;
  }

  prepareSearchQuery() {
    queryWithFollowedCategories();
    queryWithFollowedHashtags();
    queryWithFollowers();
  }

  clearPosts() {
    posts.value = [];
  }

  loadFeaturedPosts({required VoidCallback callBack}) {
    isLoading.value = true;
    update();
    getIt<FirebaseManager>().getFeaturedPosts().then((result) {
      featuredPosts.value = result;
      isLoading.value = false;
      callBack();
      update();
    });
  }

  loadPosts({required VoidCallback callBack}) {
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
