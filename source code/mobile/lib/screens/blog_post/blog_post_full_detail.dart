import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class BlogPostFullDetail extends StatefulWidget {
  BlogPostModel model;

  BlogPostFullDetail({Key? key, required this.model}) : super(key: key);

  @override
  _BlogPostFullDetailState createState() => _BlogPostFullDetailState();
}

class _BlogPostFullDetailState extends State<BlogPostFullDetail>
    with TickerProviderStateMixin {
  final controller = PageController(viewportFraction: 1, keepPage: true);
  NewsDetailController newsDetailController = Get.find();
  AuthorController sourceController = Get.find();
  SubscriptionPackageController subscriptionPackageController = Get.find();

  late TabController tabController;
  int selectedSegment = 0;

  @override
  void initState() {
    // TODO: implement initState
    loadData(widget.model);
    super.initState();
  }

  loadData(BlogPostModel model) {
    setState(() {
      widget.model = model;
      newsDetailController.setCurrentNewsPost(model);
      newsDetailController.loadSimilarPosts(
          categoryId: model.categoryId, hashtags: model.hashtags);
      sourceController.getAuthorDetail(id: model.authorId);
    });
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
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          contentInfo(),
                          divider(height: 0.1, context: context).vP16,
                          hashtagsView(),
                          divider(height: 0.1, context: context).vP16,
                          similarNews(),
                          const SizedBox(
                            height: 100,
                          )
                        ],
                      ),
                      widget.model.isLocked
                          ? Stack(
                              children: [
                                BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    color: Colors.black.withOpacity(1),
                                  ),
                                ),
                                Center(
                                  child: Column(
                                    children: [
                                      ThemeIconWidget(
                                        ThemeIcon.lock,
                                        size: 150,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      Text(
                                        LocalizationString.thisIsPremiumBlog,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ).vP16,
                                      SizedBox(
                                        width: 280,
                                        child: BorderButtonType1(
                                            borderColor:
                                                Theme.of(context).primaryColor,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w900),
                                            cornerRadius: 25,
                                            text: LocalizationString.unlock,
                                            onPress: () {
                                              Get.to(
                                                  () => const Subscription());
                                            }),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          : Container()
                    ],
                  )
                ]))
              ],
            ),
            const Positioned(left: 0, right: 0, bottom: 0, child: BannerAds()),
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
                widget.model.isVideoNews() == true
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
                            color:
                                Theme.of(context).primaryColor.withOpacity(.5),
                            child: Center(
                              child: Text(widget.model.category.toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium)
                                  .p8,
                            )).round(5),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(
                              bottom: 8.0, left: 10.0, right: 10.0),
                          color: Colors.white.withOpacity(.5),
                          child: Column(children: [
                            Text(
                              widget.model.title.toUpperCase(),
                              maxLines: 2,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(color: Colors.black),
                              textAlign: TextAlign.center,
                            ).vP8,
                            Text(widget.model.date,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontSize: 12)),
                          ]),
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
      // note: if things act up with whitespace, remove replaceAll()
      widget.model.content.replaceAll('\n', '<br>'),
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
                ).ripple(() {
                  print('going');
                  Get.to(() => AuthorDetail(
                      userId: sourceController.author.value?.id ?? ''));
                }),
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
                                    .bodyLarge)
                            .ripple(() {
                          if (getIt<UserProfileManager>().isLogin() == false) {
                            Get.to(() => const AskForLogin());
                            return;
                          } else {
                            Get.to(() => CommentsScreen(
                                  postId: widget.model.id,
                                ));
                          }
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
                      color: Theme.of(context).primaryColorLight.darken(0.1),
                      child: Text(
                        '#$hashTag',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ).p4.ripple(() {
                        Get.to(() => HashtagDetail(hashTagName: hashTag));
                      }),
                    ).round(5),
                ],
              )
            : Container()
      ],
    ).p16;
  }

  Widget similarNews() {
    return GetBuilder<NewsDetailController>(
        init: newsDetailController,
        builder: (ctx) {
          return Column(
            children: [
              headingType5(
                  title: LocalizationString.similar,
                  seeAllPress: () async {
                    PostSearchParamModel query = PostSearchParamModel();
                    query.categoryId = widget.model.categoryId;
                    // query.locationId = widget.model.locationId;
                    query.hashtags = widget.model.hashtags;

                    var mod =
                        await Get.to(() => SeeAllPosts(postSearchQuery: query));
                    loadData(mod);
                    // NavigationService.instance.navigateToRoute(
                    //     MaterialPageRoute(builder: (ctx) => const AllNewsScreen()));
                  },
                  context: context),
              SizedBox(
                height: 120,
                child: ListView.separated(
                    padding: const EdgeInsets.only(top: 10),
                    // physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: newsDetailController.similarNews.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width - 32,
                        child: BlogPostTile(
                                model: newsDetailController.similarNews[index])
                            .ripple(() {
                          print(newsDetailController.similarNews[index].title);
                          loadData(newsDetailController.similarNews[index]);
                        }),
                      );
                    },
                    separatorBuilder: (BuildContext ctx, int index) {
                      return const SizedBox(
                        width: 10,
                      );
                    }),
              ).vP16,
            ],
          );
        }).p16;
  }

  showActionSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ActionSheet(
              items: [
                GenericItem(
                    id: '1',
                    title: LocalizationString.report,
                    icon: ThemeIcon.report),
                GenericItem(
                    id: '2',
                    title: LocalizationString.cancel,
                    icon: ThemeIcon.close),
              ],
              itemCallBack: (item) {
                if (item.id == '1') {
                  newsDetailController.reportPost(widget.model);
                }
              },
            ));
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
          Obx(() {
            return ThemeIconWidget(
              newsDetailController.model.value!.isSaved()
                  ? ThemeIcon.bookMark
                  : ThemeIcon.bookMarkOutlined,
              color: newsDetailController.model.value!.isSaved()
                  ? Theme.of(context).errorColor
                  : Colors.white,
            );
          }).rP16.ripple(() {
            newsDetailController.saveOrDeletePost();
          }),
          const ThemeIconWidget(
            ThemeIcon.moreVertical,
            color: Colors.white,
          ).ripple(() {
            showActionSheet();
          })
        ],
      ).setPadding(top: 50, left: 16, right: 16),
    );
  }
}
