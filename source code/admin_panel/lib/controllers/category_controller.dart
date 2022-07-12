import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  String? searchText;
  int statusType = 1;

  searchTextChanged(String text) {
    searchText = text;
  }

  setStatusType(int type) {
    statusType = type;
  }

  void getCategories() {
    AppUtil.checkInternet().then((value) async {
      if (value) {
        getIt<FirebaseManager>()
            .getAllCategoriesBy(status: statusType, searchKeyword: searchText)
            .then((result) {
          categories.value = result;
          update();
        });
      } else {}
    });
  }

}
