import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class Saved extends StatefulWidget {
  const Saved({Key? key}) : super(key: key);

  @override
  _SavedState createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  final SavedPostsController savedPostController = Get.find();
  final PostCardController postCardController = Get.find();
  late ScrollController scrollController;

  @override
  void initState() {
    // TODO: implement initState
    scrollController = ScrollController()..addListener(loadData);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      savedPostController.setAllSavedPosts();
      loadData();
    });

    super.initState();
  }

  loadData() {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      print('loading data');
      savedPostController.loadPosts(callBack: () {});
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
            return ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.only(top: 40),
                    itemBuilder: (BuildContext context, index) {
                      return GetBuilder<PostCardController>(
                          init: postCardController,
                          builder: (ctx) {
                            print('posts');
                            print(savedPostController.posts);
                            return PostTile(
                              model: savedPostController.posts[index],
                            );
                          });
                    },
                    separatorBuilder: (BuildContext context, index) {
                      return divider(context: context, height: 0.5).vp(50);
                    },
                    itemCount: savedPostController.posts.length)
                .hP16;
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
