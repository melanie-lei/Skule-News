import 'package:get/get.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';

class UsersController extends GetxController {
  RxList<UserModel> users = <UserModel>[].obs;
  bool isLoading = false;

  String? searchText;
  AccountStatusType accountStatusType = AccountStatusType.active;

  searchTextChanged(String text) {
    searchText = text;
  }

  setStatusType(AccountStatusType type) {
    accountStatusType = type;
  }

  getAllUsers() {
    getIt<FirebaseManager>()
        .searchUserProfiles(
        searchText: (searchText ?? '').isNotEmpty ? searchText : null,
        type: accountStatusType == AccountStatusType.active ? 1 : 0)
        .then((result) {
      users.value = result;
      update();
    });
  }

  deleteUser(UserModel model){
    getIt<FirebaseManager>().deleteUser(model);
    users.remove(model);
    update();
  }

}
