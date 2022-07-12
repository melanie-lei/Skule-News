import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class TrendingHashtagController extends GetxController {
  RxList<Hashtag> hashTags = <Hashtag>[].obs;
  bool isLoading = false;

  loadHashTags() {
    isLoading = true;
    getIt<FirebaseManager>().searchHashtags().then((result) {
      isLoading = false;
      hashTags.value = result;
    });
  }
}
