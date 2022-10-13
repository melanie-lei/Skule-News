import 'package:get/get.dart';
import 'package:skule_news_mobile/helper/common_import.dart';

class MainScreenController extends GetxController {
  MenuType? lastMenuType;
  MenuType? menuType;
  String? searchText;

  setMenu(MenuType menu){
    menuType = menu;
    update();
  }

  searchTextChange(String text) {
    if (text.isEmpty) {
      menuType = lastMenuType!;
    } else {
      if (menuType != MenuType.search) {
        lastMenuType = menuType;
        menuType = MenuType.search;
      }
    }
    searchText = text;
    update();
  }
}