import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class SeeAllPosts extends StatefulWidget {
  final PostSearchParamModel postSearchQuery;

  const SeeAllPosts({Key? key, required this.postSearchQuery})
      : super(key: key);

  @override
  _SeeAllPostsState createState() => _SeeAllPostsState();
}

class _SeeAllPostsState extends State<SeeAllPosts> {
  final controller = PageController(viewportFraction: 0.90, keepPage: true);
  final SeeAllPostsController seeAllPostController = Get.find();
  final PostCardController postCardController = Get.find();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    seeAllPostController.clear();
    if (getIt<UserProfileManager>().user!.savedPost.isNotEmpty) {
      seeAllPostController.loadPosts(widget.postSearchQuery);
    }
    super.initState();
  }

  loadData() {
    if (getIt<UserProfileManager>().user!.savedPost.isNotEmpty) {
      seeAllPostController.loadPosts(widget.postSearchQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: BackNavigationBar(
        centerTitle: true,
        title: '',
        backTapHandler: () {
          Get.back();
        },
      ),
      body: GetBuilder<SeeAllPostsController>(
          init: seeAllPostController,
          builder: (ctx) {
            return seeAllPostController.isLoading.value
                ? SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: const HomeScreenShimmer())
                : ListView.separated(
                    padding: const EdgeInsets.only(left: 16,right: 16,top: 25),
                    itemBuilder: (BuildContext context, index) {
                      return GetBuilder<PostCardController>(
                          init: postCardController,
                          builder: (ctx) {
                            return PostTile(
                              model: seeAllPostController.posts[index],
                            );
                          });
                    },
                    separatorBuilder: (BuildContext context, index) {
                      return divider(context: context, height: 0.5).vp(50);
                    },
                    itemCount: seeAllPostController.posts.length);
          }),
    );
  }
}
