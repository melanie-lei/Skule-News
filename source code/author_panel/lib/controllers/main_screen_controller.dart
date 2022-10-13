import 'package:get/get.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';

class MainScreenContainer extends GetxController{
  Rx<MenuType> menuType = MenuType.dashboard.obs;

  selectMenu(MenuType menu){
    menuType.value = menu;
    update();
  }
}
