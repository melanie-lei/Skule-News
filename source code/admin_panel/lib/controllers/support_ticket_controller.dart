import 'package:get/get.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';

class SupportTicketController extends GetxController {
  markAsClosed(SupportModel model) async {
    EasyLoading.show(status: 'loading...');

    getIt<FirebaseManager>()
        .markRequestAsClosed(ticketId: model.id)
        .then((response) {
      EasyLoading.dismiss();
      if (response.status == true) {
        showMessage(LocalizationString.messageSent, true);
      } else {
        showMessage(response.message ?? '', true);
      }
    });
  }

  showMessage(String message, bool isError) {
    AppUtil.showToast(message: message, isSuccess: !isError);
  }
}
