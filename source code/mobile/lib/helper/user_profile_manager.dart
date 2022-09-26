import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class UserProfileManager {
  final FirebaseAuth auth = FirebaseAuth.instance;

  UserModel? user;

  bool isLogin() {
    return user != null;
  }

  loginAnonymously() {
    getIt<FirebaseManager>().loginAnonymously(() {
      Get.offAll(() => const MainScreen());
    });
  }

  logout() {
    user = null;
    getIt<FirebaseManager>().logout();
    getIt<FirebaseManager>().loginAnonymously(() {});
  }

  refreshProfile() async {
    if (auth.currentUser == null) {
      User? firebaseUser = await FirebaseAuth.instance.authStateChanges().first;
      if (firebaseUser != null && firebaseUser.isAnonymous == false) {
        user = await getIt<FirebaseManager>().getCurrentUser(firebaseUser.uid);
      } else {
        await getIt<FirebaseManager>().loginAnonymously(() {});
      }
    } else {
      if (auth.currentUser!.isAnonymous == false) {
        user = await getIt<FirebaseManager>()
            .getCurrentUser(auth.currentUser!.uid);
      }
    }
  }

// forceRefreshProfile() async {
//   if (auth.currentUser != null && auth.currentUser?.isAnonymous == false) {
//     user = await getIt<FirebaseManager>().getUser(auth.currentUser!.uid);
//   }
// }
}
