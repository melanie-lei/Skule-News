import 'package:get/get.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class RecommendationController extends GetxController {
  RxList<NewsModel> posts = <NewsModel>[].obs;
  RxList<NewsSourceModel> sources = <NewsSourceModel>[].obs;

  // RxList<UserModel> profiles = <UserModel>[].obs;
  RxList<Hashtag> hashtags = <Hashtag>[].obs;
  RxList<NewsLocation> locations = <NewsLocation>[].obs;

  RxBool isLoadingSource = false.obs;
  RxBool isLoadingLocations = false.obs;
  RxBool isLoadingHashtags = false.obs;
  RxBool isLoadingPosts = false.obs;

  bool isSearching = false;
  RxString searchText = ''.obs;
  RxInt selectedSegment = 0.obs;

  clear() {
    posts.clear();
    sources.clear();
    hashtags.clear();
    locations.clear();
    selectedSegment.value = 0;

    isLoadingSource.value = false;
    isLoadingLocations.value = false;
    isLoadingHashtags.value = false;
    isLoadingPosts.value = false;
  }

  loadSources({String? searchText}) {
    isLoadingSource.value = true;
    getIt<FirebaseManager>()
        .searchSources(searchText: searchText)
        .then((result) {
      sources = RxList(result);
      isLoadingSource.value = false;
      update();
    });
  }

  loadPosts({
    String? searchText,
  }) {
    isLoadingPosts.value = true;
    PostSearchParamModel searchParamModel =
        PostSearchParamModel(searchText: searchText);
    getIt<FirebaseManager>()
        .searchPosts(
      searchModel: searchParamModel,
    )
        .then((result) {
      posts.value = result;
      isLoadingPosts.value = false;
      update();
    });
  }

  // loadLocations({String? searchText}) {
  //   isLoadingLocations.value = true;
  //   getIt<FirebaseManager>()
  //       .searchLocations(searchText: searchText)
  //       .then((result) {
  //     locations = RxList(result);
  //     isLoadingLocations.value = false;
  //     update();
  //   });
  // }

  loadHashtags({String? searchText}) {
    isLoadingHashtags.value = true;
    getIt<FirebaseManager>()
        .searchHashtags(searchText: searchText)
        .then((result) {
      hashtags = RxList(result);
      isLoadingHashtags.value = false;
      update();
    });
  }

  void followUnfollowSourceAndUser(
      {NewsSourceModel? newsSource, UserModel? user, required bool isSource}) {
    if (getIt<UserProfileManager>().isLogin() == false) {
      Get.to(() => const AskForLogin());
      return;
    }

    bool isFollowing = false;
    String objectId = '';
    if (newsSource != null) {
      if (newsSource.isFollowing() == true) {
        getIt<UserProfileManager>()
            .user!
            .followingProfiles
            .remove(newsSource.id);
        newsSource.totalFollowers -= 1;
        isFollowing = false;
      } else {
        getIt<UserProfileManager>().user!.followingProfiles.add(newsSource.id);
        newsSource.totalFollowers += 1;
        isFollowing = true;
      }

      objectId = newsSource.id;
    } else {
      if (user!.isFollowing() == true) {
        getIt<UserProfileManager>().user!.followingProfiles.remove(user.id);
        user.totalFollowers -= 1;
        isFollowing = false;
      } else {
        getIt<UserProfileManager>().user!.followingProfiles.add(user.id);
        user.totalFollowers += 1;
        isFollowing = true;
      }
      objectId = user.id;
    }

    update();

    AppUtil.checkInternet().then((value) async {
      if (value) {
        if (isFollowing) {
          getIt<FirebaseManager>().followUser(id: objectId, isSource: isSource);
        } else {
          getIt<FirebaseManager>()
              .unFollowUser(id: objectId, isSource: isSource);
        }
      } else {
        // AppUtil.showToast(
        //     message: LocalizationString.noInternet, isSuccess: true);
      }
    });

    update();
  }

  followUnfollowHashtag(Hashtag hashtag) {
    if (getIt<UserProfileManager>().isLogin() == false) {
      Get.to(() => const AskForLogin());
      return;
    }

    bool isFollowing = false;

    if (hashtag.isFollowing() == true) {
      getIt<UserProfileManager>().user!.followingHashtags.remove(hashtag.id);
      hashtag.totalFollowers -= 1;
      isFollowing = false;
    } else {
      getIt<UserProfileManager>().user!.followingHashtags.add(hashtag.id);
      hashtag.totalFollowers += 1;
      isFollowing = true;
    }

    update();

    AppUtil.checkInternet().then((value) async {
      if (value) {
        if (isFollowing) {
          getIt<FirebaseManager>().followHashtag(id: hashtag.id);
        } else {
          getIt<FirebaseManager>().unFollowHashtag(id: hashtag.id);
        }
      } else {
        // AppUtil.showToast(
        //     message: LocalizationString.noInternet, isSuccess: true);
      }
    });

    update();
  }

  // followUnfollowLocation(NewsLocation location) {
  //   if (getIt<UserProfileManager>().isLogin() == false) {
  //     Get.to(() => const AskForLogin());
  //     return;
  //   }
  //
  //   bool isFollowing = false;
  //
  //   if (location.isFollowing() == true) {
  //     getIt<UserProfileManager>().user!.followingLocations.remove(location.id);
  //     location.totalFollowers -= 1;
  //     isFollowing = false;
  //   } else {
  //     getIt<UserProfileManager>().user!.followingLocations.add(location.id);
  //     location.totalFollowers += 1;
  //     isFollowing = true;
  //   }
  //
  //   update();
  //
  //   AppUtil.checkInternet().then((value) async {
  //     if (value) {
  //       if (isFollowing) {
  //         getIt<FirebaseManager>().followLocation(id: location.id);
  //       } else {
  //         getIt<FirebaseManager>().unFollowLocation(id: location.id);
  //       }
  //     } else {
  //       // AppUtil.showToast(
  //       //     message: LocalizationString.noInternet, isSuccess: true);
  //     }
  //   });
  //
  //   update();
  // }

  startSearch() {
    // isSearching = true;
    update();
  }

  closeSearch() {
    clear();
    searchText.value = '';
    selectedSegment.value = 0;
    update();
  }

  searchTextChanged(String text) {
    clear();
    searchText.value = text;
    if (text.isEmpty) {
      // loadLocations();
      loadHashtags();
      loadSources();
      update();
    } else {
      searchData();
    }
  }

  searchData() {
    if (searchText.isNotEmpty) {
      if (selectedSegment.value == 0) {
        loadPosts(searchText: searchText.value);
      } else if (selectedSegment.value == 1) {
        loadSources(searchText: searchText.value);
      } else if (selectedSegment.value == 2) {
        loadHashtags(searchText: searchText.value);
      } else if (selectedSegment.value == 3) {
        // loadLocations(searchText: searchText.value);
      }
      update();
    } else {
      closeSearch();
    }
  }

  segmentChanged(int index) {
    selectedSegment.value = index;
    searchData();
    update();
  }

  searchedPostOpened(NewsModel model) {
    getIt<FirebaseManager>().increasePostSearchCount(model);
  }

  searchedSourceOpened(NewsSourceModel model) {
    getIt<FirebaseManager>().increaseSourceSearchCount(model);
  }
}
