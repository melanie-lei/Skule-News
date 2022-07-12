import 'package:flutter/material.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class BlogPreview extends StatefulWidget {
  final BlogPostModel model;

  const BlogPreview({Key? key, required this.model}) : super(key: key);

  @override
  _BlogPreviewState createState() => _BlogPreviewState();
}

class _BlogPreviewState extends State<BlogPreview>
    with TickerProviderStateMixin {
  final controller = PageController(viewportFraction: 1, keepPage: true);
  final BlogPostDetailController newsDetailController = Get.find();
  final AuthorController sourceController = Get.find();

  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    loadData(widget.model);
    super.initState();
  }

  loadData(BlogPostModel model) {
    newsDetailController.setCurrentBlogPost(model);
    newsDetailController.loadSimilarPosts(
        categoryId: model.categoryId, hashtags: model.hashtags);
    sourceController.getSourceDetail(id: model.authorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        bottom: false,
        top: false,
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  imagesView(),
                  sourceInfo(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      contentInfo(),
                      divider(height: 0.1, context: context).vP16,
                      hashtagsView(),
                      divider(height: 0.1, context: context).vP16,
                    ],
                  )
                ]))
              ],
            ),
            Positioned(left: 0, right: 0, top: 0, child: appBar())
          ],
        ),
      ),
    );
  }

  Widget imagesView() {
    return SizedBox(
      height: 380,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                PageView.builder(
                  controller: controller,
                  itemCount: 1, //widget.model.images.length,
                  itemBuilder: (_, index) {
                    return CachedNetworkImage(
                      imageUrl: widget.model.thumbnailImage,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                    );
                  },
                ),
                widget.model.isVideoBlog() == true
                    ? Positioned(
                        left: 0,
                        top: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          color: Theme.of(context)
                              .primaryColorDark
                              .withOpacity(0.5),
                          child: const Center(
                            child: ThemeIconWidget(
                              ThemeIcon.play,
                              size: 100,
                              color: Colors.white,
                            ),
                          ),
                        ).ripple(() {
                          // play video
                          Get.to(() => VideoPlayer(videoObject: widget.model));
                        }))
                    : Container(),
                Positioned(
                  bottom: 15,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            constraints: const BoxConstraints(maxWidth: 100),
                            color: Theme.of(context).primaryColor,
                            child: Center(
                              child: Text(
                                      widget.model.categoryName.toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: Colors.white))
                                  .p8,
                            )).round(5),
                        Text(widget.model.title.toUpperCase(),
                                maxLines: 2,
                                style:
                                    Theme.of(context).textTheme.headlineSmall)
                            .vP8,
                        Row(
                          children: [
                            Text(widget.model.date,
                                style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ],
                    ).hP8,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget contentInfo() {
    return HtmlWidget(
      widget.model.content,
      textStyle: Theme.of(context).textTheme.titleMedium,
    ).hP16.vP16;
  }

  Widget sourceInfo() {
    return GetBuilder<AuthorController>(
        init: sourceController,
        builder: (ctx) {
          return Container(
            color: Theme.of(context).dividerColor.withOpacity(0.2),
            height: 70,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AvatarView(
                  url: widget.model.authorPicture,
                  size: 35,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.model.authorName,
                        style: Theme.of(context).textTheme.bodyLarge),
                    Text(
                        '${sourceController.author.value?.totalPosts ?? 0} ${LocalizationString.posts.toLowerCase()}',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                const Spacer(),
                Container(
                  height: 35,
                  color: Theme.of(context).iconTheme.color,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.chat,
                            color: Theme.of(context).backgroundColor),
                        const SizedBox(width: 5),
                        Text(LocalizationString.comments,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: Colors.white))
                            .ripple(() {
                          Get.to(() => CommentsScreen(
                                postId: widget.model.id,
                              ));
                        }),
                      ],
                    ),
                  ).hP16,
                ).round(5).ripple(() {
                  // NavigationService.instance.navigateToRoute(
                  //     MaterialPageRoute(builder: (context) => CommentsScreen()));
                }),
              ],
            ).hP16,
          );
        });
  }

  Widget hashtagsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalizationString.hashTags,
          style: Theme.of(context).textTheme.titleMedium,
        ).bP16,
        widget.model.hashtags.isNotEmpty
            ? Wrap(
                spacing: 5,
                children: [
                  for (String hashTag in widget.model.hashtags)
                    Container(
                            color:
                                Theme.of(context).primaryColorLight.darken(0.1),
                            child: Text(
                              '#$hashTag',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ).p4)
                        .round(5),
                ],
              )
            : Container()
      ],
    ).p16;
  }

  Widget appBar() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.bottomRight, stops: const [
        0.1,
        0.9
      ], colors: [
        Colors.black.withOpacity(.4),
        Colors.black.withOpacity(.8)
      ])),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const ThemeIconWidget(
            ThemeIcon.backArrow,
            color: Colors.white,
          ).ripple(() {
            Get.back();
          }),
          const Spacer(),
        ],
      ).setPadding(top: 50, left: 16, right: 16),
    );
  }
}
