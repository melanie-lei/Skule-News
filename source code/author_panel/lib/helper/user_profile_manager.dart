import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class UserProfileManager {
  AuthorsModel? user;
  final FirebaseAuth auth = FirebaseAuth.instance;

  logout() {
    user = null;
    getIt<FirebaseManager>().logout();
  }

  refreshProfile() async {
    if (auth.currentUser != null) {
      user =
      await getIt<FirebaseManager>().getCurrentUser(auth.currentUser!.uid);
    }
  }
}
