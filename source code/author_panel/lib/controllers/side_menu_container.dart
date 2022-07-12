import 'package:get/get.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';

class SideMenuContainer extends GetxController{
  Rx<MenuType> selectedMenu = MenuType.dashboard.obs;

  selectMenu(MenuType menu){
    selectedMenu.value = menu;
    update();
  }
}
