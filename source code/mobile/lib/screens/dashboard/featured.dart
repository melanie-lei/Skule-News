import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class FeaturedPosts extends StatefulWidget {
  const FeaturedPosts({Key? key}) : super(key: key);

  @override
  _FeaturedPostsState createState() => _FeaturedPostsState();
}

class _FeaturedPostsState extends State<FeaturedPosts> {
  final controller = PageController(viewportFraction: 0.90, keepPage: true);
  final DashboardController dashboardController = Get.find();
  final PostCardController postCardController = Get.find();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('loads data');
      loadData();
    });

    super.initState();

    InterstitialAds().loadInterstitialAd();
  }

  loadData() {
    dashboardController.prepareSearchQueryWithFeaturedPosts();
    dashboardController.loadFeaturedPosts(callBack: () {
      _refreshController.refreshCompleted();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
                    Container(
                      width: 5,
                      height: 25,
                      color: Theme.of(context).primaryColor.darken(),
                    ).round(10),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      LocalizationString.featured,
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
            child: GetBuilder<DashboardController>(
                init: dashboardController,
                builder: (ctx) {
                  return dashboardController.isLoading.value
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: const HomeScreenShimmer())
                      : ListView.separated(
                              // physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(top: 50),
                              itemBuilder: (BuildContext context, index) {
                                return GetBuilder<PostCardController>(
                                    init: postCardController,
                                    builder: (ctx) {
                                      return PostTile(
                                        model: dashboardController
                                            .featuredPosts[index],
                                      );
                                    });
                              },
                              separatorBuilder: (BuildContext context, index) {
                                return divider(context: context, height: 0.5)
                                    .vp(40);
                              },
                              itemCount:
                                  dashboardController.featuredPosts.length)
                          .addPullToRefresh(
                              refreshController: _refreshController,
                              onRefresh: loadData,
                              onLoading: () {})
                          .hP16;
                }),
          )
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
