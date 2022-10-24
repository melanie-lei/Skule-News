import 'package:skule_news_admin_panel/helper/common_import.dart';

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
          await getIt<FirebaseManager>().getSourceDetail(auth.currentUser!.uid);
    }
  }
}
