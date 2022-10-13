import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class ReportedBlogsController extends GetxController {
  final BlogsController blogsController = Get.find();

  RxList<BlogPostModel> blogs = <BlogPostModel>[].obs;

  Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);
  String? searchText;

  searchTextChanged(String text) {
    searchText = text;
  }

  selectCategory(CategoryModel category) {
    selectedCategory.value = category;
  }

  deleteRequestForBlog(BlogPostModel modal) {
    blogsController.activeBlogs
        .removeWhere((element) => element.id == modal.id);
    blogsController.update();

    getIt<FirebaseManager>().deleteBlogReport(modal).then((value) {});
    blogs.remove(modal);
    update();
  }

  deactivateBlog(BlogPostModel modal) {
    blogsController.activeBlogs
        .removeWhere((element) => element.id == modal.id);
    blogsController.update();

    getIt<FirebaseManager>().deactivateBlog(modal).then((value) {
      deleteRequestForBlog(modal);
    });
    blogs.remove(modal);
    update();
  }

  addOrRemoveFeaturedBlog(BlogPostModel blogPost) {
    getIt<FirebaseManager>().addOrRemoveFromFeature(blogPost);
    update();
  }

  addOrRemovePremiumBlog(BlogPostModel blogPost) {
    getIt<FirebaseManager>().addOrRemoveFromPremium(blogPost);
    update();
  }
}
