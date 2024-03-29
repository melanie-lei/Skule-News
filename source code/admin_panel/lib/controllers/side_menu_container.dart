import 'package:get/get.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';

class SideMenuContainer extends GetxController{
  Rx<MenuType> selectedMenu = MenuType.dashboard.obs;

  selectMenu(MenuType menu){
    selectedMenu.value = menu;
    update();
  }
}
