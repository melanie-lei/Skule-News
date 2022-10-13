// import 'package:get/get.dart';
// import 'package:skule_news_mobile/helper/common_import.dart';
//
// class LocationController extends GetxController {
//   List sections = [].obs;
//   RxList<NewsModel> posts = <NewsModel>[].obs;
//   Rx<NewsLocation?> location = Rx<NewsLocation?>(null);
//
//   clearPosts() {
//     posts.value = [];
//   }
//
//   setCurrentLocation(NewsLocation value) {
//     location.value = value;
//   }
//
//   loadPosts(
//       {bool? isVideo,
//       String? searchText,
//       String? categoryId,
//       String? artistId,
//       String? locationId,
//       List<String>? hashtag,
//       List<String>? postIds}) {
//     getIt<FirebaseManager>()
//         .searchPosts(
//             isVideo: isVideo,
//             searchText: searchText,
//             categoryId: categoryId,
//             reporterId: artistId,
//             locationId: locationId,
//             hashtag: hashtag,
//             postIds: postIds)
//         .then((result) {
//       posts.value = result;
//       update();
//     });
//   }
//
//   followUnfollowLocation(NewsLocation location) {
//     if (getIt<UserProfileManager>().isLogin() == false) {
//       Get.to(() => const AskForLogin());
//       return;
//     }
//     bool isFollowing = false;
//
//     if (location.isFollowing() == true) {
//       getIt<UserProfileManager>().user!.followingLocations.remove(location.id);
//       location.totalFollowers -= 1;
//       isFollowing = false;
//     } else {
//       getIt<UserProfileManager>().user!.followingLocations.add(location.id);
//       location.totalFollowers += 1;
//       isFollowing = true;
//     }
//
//     update();
//
//     AppUtil.checkInternet().then((value) async {
//       if (value) {
//         if (isFollowing) {
//           getIt<FirebaseManager>().followLocation(id: location.id);
//         } else {
//           getIt<FirebaseManager>().unFollowLocation(id: location.id);
//         }
//       } else {
//         // AppUtil.showToast(
//         //     message: LocalizationString.noInternet, isSuccess: true);
//       }
//     });
//
//     update();
//   }
// }
