import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class HashtagDetail extends StatefulWidget {
  final Hashtag hashTag;

  const HashtagDetail({Key? key, required this.hashTag}) : super(key: key);

  @override
  State<HashtagDetail> createState() => _HashtagDetailState();
}

class _HashtagDetailState extends State<HashtagDetail> {
  final PostCardController postCardController = Get.find();
  final HashtagController hashtagController = Get.find();

  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      hashtagController.setCurrentHashtag(widget.hashTag);
      hashtagController.loadPosts();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: [
          BackNavBar(
            title: widget.hashTag.name,
            // centerTitle: true,
            backTapHandler: () {
              Get.back();
            },
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  GetBuilder<HashtagController>(
                      init: hashtagController,
                      builder: (context) {
                        return creatorInfo().vP16;
                      }),
                  divider(context: context).tP16,
                  loadPosts()
                ]))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget loadPosts() {
    return GetBuilder<HashtagController>(
        init: hashtagController,
        builder: (context) {
          return SizedBox(
            height: hashtagController.posts.length * 540,
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 25),
                itemBuilder: (BuildContext context, index) {
                  return GetBuilder<PostCardController>(
                      init: postCardController,
                      builder: (ctx) {
                        return PostTile(
                          model: hashtagController.posts[index],
                        );
                      });
                },
                separatorBuilder: (BuildContext context, index) {
                  return const SizedBox(
                    height: 40,
                  );
                },
                itemCount: hashtagController.posts.length).hP16,
          );
        });
  }

  Widget creatorInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CachedNetworkImage(
          imageUrl: widget.hashTag.image,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
          const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          height: 300,
          width: MediaQuery.of(context).size.width,
        )
        ,
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.hashTag.name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    widget.hashTag.totalPosts > 0
                        ? Text('${widget.hashTag.totalPosts} ${LocalizationString.posts},',
                                style: Theme.of(context).textTheme.bodyMedium)
                            .rP8
                        : Container(),
                    widget.hashTag.totalFollowers > 0
                        ? Text('${widget.hashTag.totalFollowers} ${LocalizationString.followers},',
                                style: Theme.of(context).textTheme.bodyMedium)
                            .rP8
                        : Container(),
                  ],
                ),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              height: 40,
              width: 120,
              child: Obx(() => BorderButtonType1(
                  text: hashtagController.hashtag.value!.isFollowing()
                      ? LocalizationString.following
                      : LocalizationString.follow,
                  backgroundColor:
                      hashtagController.hashtag.value!.isFollowing()
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).backgroundColor,
                  textStyle: hashtagController.hashtag.value!.isFollowing()
                      ? Theme.of(context).textTheme.bodyMedium
                      : Theme.of(context).textTheme.bodyMedium,
                  onPress: () {
                    hashtagController.followUnfollowHashtag(
                        hashtagController.hashtag.value!);
                  })),
            )
          ],
        ).hP16,
      ],
    );
  }
}
