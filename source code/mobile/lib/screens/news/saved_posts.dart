import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/controllers/saved_posts_controller.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class Saved extends StatefulWidget {
  const Saved({Key? key}) : super(key: key);

  @override
  _SavedState createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  final controller = PageController(viewportFraction: 0.90, keepPage: true);
  final SavedPostsController savedPostController = Get.find();
  final PostCardController postCardController = Get.find();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });

    super.initState();
  }

  loadData() {
    if (getIt<UserProfileManager>().user?.savedPost.isNotEmpty ?? false) {
      savedPostController.loadPosts(
          postIds: getIt<UserProfileManager>().user!.savedPost,
          callBack: () {
            _refreshController.refreshCompleted();
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: BackNavigationBar(
        centerTitle: true,
        title: LocalizationString.saved,
        backTapHandler: () {
          Get.back();
        },
      ),
      body: GetBuilder<SavedPostsController>(
          init: savedPostController,
          builder: (ctx) {
            return savedPostController.isLoading.value
                ? SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: const HomeScreenShimmer())
                : ListView.separated(
                        padding: const EdgeInsets.only(top: 40),
                        itemBuilder: (BuildContext context, index) {
                          return GetBuilder<PostCardController>(
                              init: postCardController,
                              builder: (ctx) {
                                return PostTile(
                                  model: savedPostController.posts[index],
                                );
                              });
                        },
                        separatorBuilder: (BuildContext context, index) {
                          return divider(context: context, height: 0.5).vp(50);
                        },
                        itemCount: savedPostController.posts.length)
                    .hP16
                    .addPullToRefresh(
                        refreshController: _refreshController,
                        onRefresh: loadData);
          }),
    );
  }

  Widget appBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          LocalizationString.saved,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
