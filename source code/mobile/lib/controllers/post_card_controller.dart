import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class PostCardController extends GetxController {
  RxInt currentIndex = 0.obs;

  updateGallerySlider(int index) {
    currentIndex.value = index;
  }

  // titleTextTapped({required String text, required PostModel post}) {
  //   if (text.startsWith('#')) {
  //     Get.to(() => Posts(hashTag: text.replaceAll('#', ''),source: PostSource.posts));
  //   } else {
  //     String userTag = text.replaceAll('@', '');
  //     if (post.mentionedUsers
  //         .where((element) => element.name == userTag)
  //         .isNotEmpty) {
  //       int mentionedUserId = post.mentionedUsers
  //           .where((element) => element.name == userTag)
  //           .first
  //           .id;
  //       Get.to(() => OtherUserProfile(userId: mentionedUserId));
  //     }
  //   }
  // }

  void likeUnlikePost(NewsModel model) {
    if (getIt<UserProfileManager>().isLogin() == false) {
      Get.to(() => const AskForLogin());
      return;
    }

    bool isLiked = false;

    if (model.isLiked() == true) {
      getIt<UserProfileManager>().user!.likedPost.remove(model.id);
      model.totalLikes -= 1;
      isLiked = false;
    } else {
      getIt<UserProfileManager>().user!.likedPost.add(model.id);
      model.totalLikes += 1;
      isLiked = true;
    }

    update();

    AppUtil.checkInternet().then((value) async {
      if (value) {
        if (isLiked) {
          getIt<FirebaseManager>().likePost(model.id);
        } else {
          getIt<FirebaseManager>().unlikePost(model.id);
        }
      } else {
        // AppUtil.showToast(
        //     message: LocalizationString.noInternet, isSuccess: true);
      }
    });

    update();
  }

  void saveOrDeletePost(NewsModel model) {
    if (getIt<UserProfileManager>().isLogin() == false) {
      Get.to(() => const AskForLogin());
      return;
    }
    bool isSaved = false;

    if (model.isSaved() == true) {
      getIt<UserProfileManager>().user!.savedPost.remove(model.id);
      model.totalSaved -= 1;
      isSaved = false;
    } else {
      getIt<UserProfileManager>().user!.savedPost.add(model.id);
      model.totalSaved += 1;
      isSaved = true;
    }

    update();

    AppUtil.checkInternet().then((value) async {
      if (value) {
        if (isSaved) {
          getIt<FirebaseManager>().savePost(model.id);
        } else {
          getIt<FirebaseManager>().removeSavedPost(model.id);
        }
      } else {
        // AppUtil.showToast(
        //     message: LocalizationString.noInternet, isSuccess: true);
      }
    });

    update();
  }

  reportPost(NewsModel post) {
    if (getIt<UserProfileManager>().isLogin() == false) {
      Get.to(() => const AskForLogin());
      return;
    }
    getIt<FirebaseManager>()
        .reportAbuse(post.id, post.title, DataType.news)
        .then((value) {
      // AppUtil.showToast(
      //     message: LocalizationString.newsReported, isSuccess: true, context: null);
    });
  }

}
