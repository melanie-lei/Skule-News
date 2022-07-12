import 'package:get/get.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';

class SupportRequestsController extends GetxController {
  RxList<SupportModel> supportRequests = <SupportModel>[].obs;

  getAllSupportTickets() {
    getIt<FirebaseManager>().getAllSupportMessages().then((result) {
      supportRequests.value = result;
      update();
    });
  }
}
