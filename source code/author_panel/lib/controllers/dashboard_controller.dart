import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';

class DashboardController extends GetxController{
  RxList<BlogPostModel> blogs = <BlogPostModel>[].obs;
  Rx<RecordCounterModel?> recordCounter = Rx<RecordCounterModel?>(null);



  getCounter() {
    getIt<FirebaseManager>().getCounter().then((result) {
      recordCounter.value = result;
      update();
    });
  }

}