import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class VideosDashboardScreen extends StatefulWidget {
  const VideosDashboardScreen({Key? key}) : super(key: key);

  @override
  _VideosDashboardScreenState createState() => _VideosDashboardScreenState();
}

class _VideosDashboardScreenState extends State<VideosDashboardScreen> {
  final controller = PageController(viewportFraction: 0.90, keepPage: true);
  final CategoryController categoryController = Get.find();
  final DashboardController dashboardController = Get.find();
  final PostCardController postCardController = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      categoryController.clear();
      categoryController.loadCategories(
          needDefaultCategory: true,
          callBack: () {
            categoryController.handleCategoryTap(index: 0, isVideo: false);
          });

      // InterstitialAds(
      //   onCompletion: () {
      //
      //   },
      // ).loadInterstitialAd();
    });

    super.initState();
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
      appBar: CustomNavigationBar(
        child: appBar(),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
            GetBuilder<CategoryController>(
                init: categoryController,
                builder: (ctx) {
                  return HorizontalMenuBar(
                    // padding: const EdgeInsets.only(left: 16),
                    selectedIndex:
                        categoryController.selectedCategoryIndex.value,
                    onSegmentChange: (segment) {
                      categoryController.handleCategoryTap(
                          index: segment, isVideo: true);
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
                          height: (dashboardController.posts.length * 150) +
                              (dashboardController.posts.length * 100),
                          child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(top: 40),
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
                                return divider(context: context, height: 0.5)
                                    .vp(50);
                              },
                              itemCount: dashboardController.posts.length),
                        );
                }),
          ]))
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
