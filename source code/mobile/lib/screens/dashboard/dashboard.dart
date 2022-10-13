import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class Section {
  Section({required this.heading, required this.items, required this.dataType});

  String heading;
  List<dynamic> items = [];
  DataType dataType = DataType.wallpapers;
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final controller = PageController(viewportFraction: 0.90, keepPage: true);
  final CategoryController categoryController = Get.find();
  final DashboardController dashboardController = Get.find();
  final PostCardController postCardController = Get.find();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadInitialData();
    });
    super.initState();
  }

  loadInitialData() {
    dashboardController.prepareSearchQuery();
    categoryController.clear();
    categoryController.loadCategories(
        needDefaultCategory: true,
        callBack: () {
          categoryController.handleCategoryTap(index: 0, isVideo: false);
        });
  }

  void refreshData() async {
    dashboardController.clearPosts();
    dashboardController.loadPosts(callBack: () {
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    categoryController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          Container(
            height: 120,
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ThemeIconWidget(
                      ThemeIcon.book,
                      color: Theme.of(context).primaryColor.lighten(),
                      size: 30,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      AppConfig.projectName,
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontWeight: FontWeight.w900),
                    ),
                  ],
                ).p16,
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  const SizedBox(
                    height: 20,
                  ),
                  GetBuilder<CategoryController>(
                      init: categoryController,
                      builder: (ctx) {
                        return HorizontalMenuBar(
                          // padding: const EdgeInsets.only(left: 16),
                          selectedIndex:
                              categoryController.selectedCategoryIndex.value,
                          onSegmentChange: (segment) {
                            categoryController.handleCategoryTap(
                                index: segment, isVideo: false);
                          },
                          menus: categoryController.categories
                              .map((element) => element.name)
                              .toList(),
                        );
                      }),
                  GetBuilder<DashboardController>(
                      init: dashboardController,
                      builder: (ctx) {
                        return dashboardController.isLoading.value
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: const HomeScreenShimmer())
                            : SizedBox(
                                height:
                                    (dashboardController.posts.length * 160) +
                                        (dashboardController.posts.length * 30),
                                child: ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.only(top: 40),
                                    itemBuilder: (BuildContext context, index) {
                                      return GetBuilder<PostCardController>(
                                          init: postCardController,
                                          builder: (ctx) {
                                            return PostTile(
                                              model: dashboardController
                                                  .posts[index],
                                            );
                                          });
                                    },
                                    separatorBuilder:
                                        (BuildContext context, index) {
                                      return divider(
                                              context: context,
                                              height: 1,
                                              color: Theme.of(context)
                                                  .dividerColor
                                                  .lighten(0.3))
                                          .setPadding(bottom: 20, top: 10);
                                    },
                                    itemCount:
                                        dashboardController.posts.length),
                              ).hP16;
                      }),
                ]))
              ],
            ).addPullToRefresh(
                refreshController: _refreshController,
                onRefresh: refreshData,
                onLoading: () {}),
          ),
        ],
      ),
    );
  }

  Widget appBar() {
    return Text(
      AppConfig.projectName,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}
