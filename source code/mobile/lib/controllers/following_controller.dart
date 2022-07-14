import 'package:get/get.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class FollowingController extends GetxController {
  RxList<AuthorModel> sources = <AuthorModel>[].obs;
  RxList<Hashtag> hashtags = <Hashtag>[].obs;
  RxList<NewsLocation> locations = <NewsLocation>[].obs;

  RxBool isLoadingSource = false.obs;
  RxBool isLoadingHashtags = false.obs;
  RxBool isLoadingLocations = false.obs;

  RxInt selectedSegment = 0.obs;

  clear() {
    sources.clear();
    hashtags.clear();
    locations.clear();
    selectedSegment.value = 0;
    isLoadingSource.value = false;
    isLoadingHashtags.value = false;
    isLoadingLocations.value = false;
  }

  segmentChanged(int index) {
    selectedSegment.value = index;
    searchData();
    update();
  }

  searchData() {
    if (selectedSegment.value == 0) {
      loadSources();
    } else if (selectedSegment.value == 1) {
      loadHashtags();
    } else if (selectedSegment.value == 2) {
      // loadLocations();
    }
    update();
  }

  loadSources() {
    if (getIt<UserProfileManager>().user!.followingProfiles.isNotEmpty) {
      isLoadingSource.value = true;
      getIt<FirebaseManager>()
          .searchSources(
              sourceIds: getIt<UserProfileManager>().user!.followingProfiles)
          .then((result) {
        sources = RxList(result);
        isLoadingSource.value = false;
        update();
      });
    }
  }

  // loadLocations() {
  //   if (getIt<UserProfileManager>().user!.followingLocations.isNotEmpty) {
  //     isLoadingLocations.value = true;
  //     getIt<FirebaseManager>()
  //         .searchLocations(
  //             locationIds: getIt<UserProfileManager>().user!.followingLocations)
  //         .then((result) {
  //       locations = RxList(result);
  //       isLoadingLocations.value = false;
  //       update();
  //     });
  //   }
  // }

  loadHashtags() {
    if (getIt<UserProfileManager>().user!.followingHashtags.isNotEmpty) {
      isLoadingHashtags.value = true;
      getIt<FirebaseManager>()
          .searchHashtags(
              hashtags: getIt<UserProfileManager>().user!.followingHashtags)
          .then((result) {
        hashtags = RxList(result);
        isLoadingHashtags.value = false;
        update();
      });
    }
  }

  void followUnfollowSourceAndUser(
      {AuthorModel? newsSource, UserModel? user, required bool isSource}) {
    if (getIt<UserProfileManager>().isLogin() == false) {
      Get.to(() => const AskForLogin());
      return;
    }

    bool isFollowing = false;
    String objectId = '';
    if (newsSource != null) {
      if (newsSource.isFollowing() == true) {
        getIt<UserProfileManager>().user!.followingProfiles.remove(newsSource.id);
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
          getIt<FirebaseManager>().followUser(id: objectId, isAuthor: isSource);
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
      getIt<UserProfileManager>().user!.followingHashtags.remove(hashtag.name);
      hashtag.totalFollowers -= 1;
      isFollowing = false;
    } else {
      getIt<UserProfileManager>().user!.followingHashtags.add(hashtag.name);
      hashtag.totalFollowers += 1;
      isFollowing = true;
    }

    update();

    AppUtil.checkInternet().then((value) async {
      if (value) {
        if (isFollowing) {
          getIt<FirebaseManager>().followHashtag(hashtag: hashtag);
        } else {
          getIt<FirebaseManager>().unFollowHashtag(hashtag: hashtag);
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
}
