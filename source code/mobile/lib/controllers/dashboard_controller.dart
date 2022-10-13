import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skule_news_mobile/helper/common_import.dart';

class DashboardController extends GetxController {
  List sections = [].obs;
  RxList<BlogPostModel> posts = <BlogPostModel>[].obs;
  RxList<BlogPostModel> featuredPosts = <BlogPostModel>[].obs;

  RxBool isLoading = true.obs;

  PostSearchParamModel postSearchParamModel = PostSearchParamModel();

  queryWithFollowers() {
    clearPosts();
    postSearchParamModel = PostSearchParamModel();
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
    clearPosts();
    postSearchParamModel = PostSearchParamModel();
    postSearchParamModel.categoryId = categoryId;
  }

  prepareSearchQueryWithFeaturedPosts() {
    clearPosts();
    postSearchParamModel = PostSearchParamModel();
    postSearchParamModel.isFeatured = true;
  }

  prepareSearchQueryWithFollowers() {
    queryWithFollowers();
  }

  prepareSearchQuery() {
    clearPosts();
    postSearchParamModel = PostSearchParamModel();
    queryWithFollowedCategories();
    queryWithFollowedHashtags();
    // queryWithFollowers();
  }

  clearPosts() {
    posts.value = [];
  }

  loadFeaturedPosts({required VoidCallback callBack}) {
    isLoading.value = true;
    update();
    getIt<FirebaseManager>()
        .getFeaturedPosts(postSearchParamModel)
        .then((result) {
      featuredPosts.addAll(result.result as List<BlogPostModel>);
      isLoading.value = false;
      // postSearchParamModel.startsAt = result.lastDoc;
      callBack();
      update();
    });
  }

  loadFollowingUsersPosts({required VoidCallback callBack}) {
    if ((postSearchParamModel.userIds ?? []).isEmpty) {
      posts.value = [];
      update();
      return;
    }
    isLoading.value = true;
    update();

    getIt<FirebaseManager>()
        .followingUsersPosts(searchModel: postSearchParamModel)
        .then((result) {
      posts.addAll(result.result as List<BlogPostModel>);
      isLoading.value = false;
      // postSearchParamModel.startsAt = result.lastDoc;
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
      try {
        posts.addAll(result.result as List<BlogPostModel>);
      } catch (e) {}
      isLoading.value = false;
      // postSearchParamModel.startsAt = result.lastDoc;

      callBack();
      update();
    });
  }
}
