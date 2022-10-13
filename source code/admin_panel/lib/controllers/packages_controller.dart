import 'package:get/get.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';

class PackageController extends GetxController {
  RxList<PackageModel> packages = <PackageModel>[].obs;

  getAllPackages() {
    getIt<FirebaseManager>().getAllPackages().then((result) {
      packages.value = result;
      update();
    });
  }

  deletePackage(PackageModel model) {
    getIt<FirebaseManager>().deletePackage(model);
    packages.remove(model);
    update();
  }
}
