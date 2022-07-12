import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class CommentsController extends GetxController {
  RxList<CommentModel> comments = <CommentModel>[].obs;

  void getComments(String postId) {
    AppUtil.checkInternet().then((value) async {
      if (value) {
        getIt<FirebaseManager>().getComments().then((result) {
          comments.value = result;
          update();
        });
      } else {
        // AppUtil.showToast(
        //     message: LocalizationString.noInternet, isSuccess: true);
      }
    });
  }

  void postCommentsApiCall(
      {required String commentText, required String postId}) {
    String id = getRandString(15);

    var comment = {
      'id': id,
      'postId': postId,
      'comment': commentText,
      // 'createdAt': FieldValue.serverTimestamp(),
      'userId': getIt<UserProfileManager>().user!.id,
      'userName': getIt<UserProfileManager>().user!.name,
      'userPicture': getIt<UserProfileManager>().user!.image,
      'status': 1
    };

    CommentModel commentModel = CommentModel.fromJson(comment);

    comments.add(commentModel);
    comments.refresh();

    update();
    getIt<FirebaseManager>().sendComment(commentModel);
  }
}
