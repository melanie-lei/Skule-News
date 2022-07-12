import 'package:get/get.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class HashtagController extends GetxController {
  List sections = [].obs;
  RxList<NewsModel> posts = <NewsModel>[].obs;

  Rx<Hashtag?> hashtag = Rx<Hashtag?>(null);

  clearPosts() {
    posts.value = [];
  }

  setCurrentHashtag(Hashtag value) {
    hashtag.value = value;
  }

  loadPosts() {
    getIt<FirebaseManager>()
        .searchPosts(
            searchModel: PostSearchParamModel(hashtags: [hashtag.value!.name]))
        .then((result) {
      posts.value = result;
      update();
    });
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
}
