import 'package:get/get.dart';

class SearchController extends GetxController {
  Rx<int> selectedTab = 0.obs;

  changeTab(int index) {
    selectedTab = Rx(index);
    update();
  }
}