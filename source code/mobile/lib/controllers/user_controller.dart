import 'package:get/get.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:image_picker/image_picker.dart' as image_picker;

class UserController extends GetxController {
  final image_picker.ImagePicker _picker = image_picker.ImagePicker();

  RxList<NewsModel> posts = <NewsModel>[].obs;
  Rx<UserModel?> reporter = (null).obs;

  Rx<int> selectedTab = 0.obs;
  bool isLoading = false;
  RxString imagePath = ''.obs;

  setProfileImagePath() {
    if (getIt<UserProfileManager>().user!.image != null) {
      imagePath.value = getIt<UserProfileManager>().user!.image!;
      update();
    }
  }

  changeTab(int index) {
    selectedTab = Rx(index);
    update();
  }

  getReporterDetail({required String id}) {
    isLoading = true;
    getIt<FirebaseManager>().getUser(id).then((result) {
      reporter = Rx(result!);
      isLoading = false;

      update();
    });
  }

  loadPosts({bool? isVideo,
    String? searchText,
    String? categoryId,
    String? reporterId,
    List<String>? postIds}) {
    PostSearchParamModel searchParamModel = PostSearchParamModel(
        userId: reporterId, categoryId: categoryId);
    getIt<FirebaseManager>()
        .searchPosts(
      searchModel: searchParamModel,
    )
        .then((result) {
      posts.value = result;
      update();
    });
  }

  void followUnfollowUser() {
    bool isFollowing = false;
    if (reporter.value!.isFollowing() == true) {
      getIt<UserProfileManager>()
          .user!
          .followingProfiles
          .remove(reporter.value!.id);
      reporter.value!.totalFollowers -= 1;
      isFollowing = false;
    } else {
      getIt<UserProfileManager>()
          .user!
          .followingProfiles
          .add(reporter.value!.id);
      reporter.value!.totalFollowers += 1;
      isFollowing = true;
    }

    update();

    AppUtil.checkInternet().then((value) async {
      if (value) {
        if (isFollowing) {
          getIt<FirebaseManager>()
              .followUser(id: reporter.value!.id, isSource: false);
        } else {
          getIt<FirebaseManager>()
              .unFollowUser(id: reporter.value!.id, isSource: false);
        }
      } else {
        // AppUtil.showToast(
        //     message: LocalizationString.noInternet, isSuccess: true);
      }
    });

    update();
  }

  updateUser({String? name, String? bio}) {
    EasyLoading.show(status: LocalizationString.loading);
    getIt<UserProfileManager>().user!.name = name;
    getIt<UserProfileManager>().user!.bio = bio;

    getIt<FirebaseManager>().updateUser(name: name, bio: bio).then((value) {
      EasyLoading.dismiss();
      Get.back();
    });
  }

  uploadProfileImage() async {
    final image_picker.XFile? image =
    await _picker.pickImage(source: image_picker.ImageSource.gallery);

    if (image != null) {
      getIt<FirebaseManager>()
          .updateProfileImage(File(image.path))
          .then((value) {
        imagePath.value = value;
        update();
      });
    }
  }
}
