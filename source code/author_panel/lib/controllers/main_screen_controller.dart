import 'package:get/get.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';

class MainScreenContainer extends GetxController{
  Rx<MenuType> menuType = MenuType.dashboard.obs;

  selectMenu(MenuType menu){
    menuType.value = menu;
    update();
  }
}
