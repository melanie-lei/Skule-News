import 'package:get/get.dart';
import 'package:skule_news_mobile/helper/common_import.dart';

class HashtagController extends GetxController {
  List sections = [].obs;
  RxList<BlogPostModel> posts = <BlogPostModel>[].obs;

  Rx<Hashtag?> hashtag = Rx<Hashtag?>(null);

  clearPosts() {
    posts.value = [];
  }

  setCurrentHashtag(Hashtag value) {
    hashtag.value = value;
  }

  loadHashtagDetail(String hashtagName){
    getIt<FirebaseManager>().getHashtagDetail(hashtagName).then((value) {
      hashtag.value = value;
    });
  }

  loadPosts(String? hashtagName) {
    getIt<FirebaseManager>()
        .searchPosts(
            searchModel: PostSearchParamModel(
                hashtags: [hashtagName ?? hashtag.value!.name]))
        .then((response) {
      posts.value = response.result as List<BlogPostModel>;
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
}
