import 'package:skule_news_admin_panel/helper/common_import.dart';
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

  void getAllCategories() async {
    categories.clear();
    if (statusType == 1) {
      var responses = await Future.wait([
        // getAuthorCategories(),
        getAdminCategories(),
      ]);

      categories.addAll(responses[0]);
      // categories.addAll(responses[1]);
    } else {
      var responses = await Future.wait([
        // getAuthorCategories(),
      ]);

      // categories.addAll(responses[0]);
    }
    update();
  }

  Future<List<CategoryModel>> getAuthorCategories() async {
    List<CategoryModel> list = [];
    await AppUtil.checkInternet().then((value) async {
      if (value) {
        await getIt<FirebaseManager>()
            .searchAuthorCategories(status: statusType)
            .then((result) {
          list = result;
        });
      } else {}
    });
    return list;
  }

  Future<List<CategoryModel>> getAdminCategories() async {
    List<CategoryModel> list = [];

    await AppUtil.checkInternet().then((value) async {
      if (value) {
        await getIt<FirebaseManager>().searchAdminCategories().then((result) {
          list = result;
        });
      } else {}
    });
    return list;
  }
}
