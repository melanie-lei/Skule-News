import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class CategoryPosts extends StatefulWidget {
  final CategoryModel category;

  const CategoryPosts({Key? key, required this.category}) : super(key: key);

  @override
  _CategoryPostsState createState() => _CategoryPostsState();
}

class _CategoryPostsState extends State<CategoryPosts> {
  final controller = PageController(viewportFraction: 0.90, keepPage: true);
  final DashboardController dashboardController = Get.find();
  final PostCardController postCardController = Get.find();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final CategoryController categoryController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    dashboardController.clearPosts();
    loadData();
    super.initState();
  }

  loadData() {
    dashboardController.prepareSearchQueryWithCategoryId(widget.category.id);
    dashboardController.loadPosts(callBack: () {
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          SizedBox(
            height: 220,
            width: double.infinity,
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.category.image!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  height: double.infinity,
                  width: double.infinity,
                ),
                Container(
                  color: Colors.black45,
                ),
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: Center(
                      child: Text(
                        widget.category.name,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    )),
                Positioned(
                    left: 20,
                    top: 50,
                    child: const ThemeIconWidget(
                      ThemeIcon.backArrow,
                      color: Colors.white,
                    ).ripple(() {
                      Get.back();
                    })),
                Positioned(
                  left: 320,
                  top: 180,
                  child: Container(
                    child: categoryController.selectedCategories
                            .contains(widget.category)
                        ? Icon(Icons.check)
                        : Icon(Icons.check_box_outline_blank),
                  ).ripple(() {
                    setState(() {
                      categoryController.selectCategory(
                          category: widget.category);
                      categoryController.updateInterest(() {
                        getIt<UserProfileManager>().refreshProfile();
                      });
                    });
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: GetBuilder<DashboardController>(
                init: dashboardController,
                builder: (ctx) {
                  return ListView.separated(
                          padding: const EdgeInsets.only(top: 25),
                          itemBuilder: (BuildContext context, index) {
                            return GetBuilder<PostCardController>(
                                init: postCardController,
                                builder: (ctx) {
                                  return PostTile(
                                    model: dashboardController.posts[index],
                                  );
                                });
                          },
                          separatorBuilder: (BuildContext context, index) {
                            return const SizedBox(
                              height: 40,
                            );
                          },
                          itemCount: dashboardController.posts.length)
                      .hP16
                      .addPullToRefresh(
                          refreshController: _refreshController,
                          onRefresh: loadData,
                          onLoading: () {});
                }),
          ),
        ],
      ),
    );
  }
}
