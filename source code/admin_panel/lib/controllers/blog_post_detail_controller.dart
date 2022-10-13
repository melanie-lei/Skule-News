import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class BlogPostDetailController extends GetxController {
  RxList<BlogPostModel> similarNews = <BlogPostModel>[].obs;
  Rx<BlogPostModel?> model = Rx<BlogPostModel?>(null);
  bool isLoading = false;

  setCurrentBlogPost(BlogPostModel post) {
    model.value = post;
  }

}
