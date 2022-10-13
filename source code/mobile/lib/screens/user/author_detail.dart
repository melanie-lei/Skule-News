import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class AuthorDetail extends StatefulWidget {
  final String userId;

  const AuthorDetail({Key? key, required this.userId}) : super(key: key);

  @override
  State<AuthorDetail> createState() => _AuthorDetailState();
}

class _AuthorDetailState extends State<AuthorDetail> {
  final PostCardController postCardController = Get.find();
  final AuthorController authorController = Get.find();

  @override
  void initState() {
    // TODO: implement initState

    authorController.clear();
    authorController.getAuthorDetail(id: widget.userId);
    // authorController.getAllCategories(id: widget.userId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          Stack(
            children: [
              Obx(() => authorController.author.value == null
                  ? Container()
                  : CachedNetworkImage(
                      height: 350,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: authorController.author.value!.coverImage)),
              Container(
                color: Colors.black.withOpacity(0.7),
                height: 350,
                width: double.infinity,
              ),
              Column(
                children: [
                  GetBuilder<AuthorController>(
                      init: authorController,
                      builder: (ctx) {
                        return SizedBox(
                          height: 90,
                          // color: Theme.of(context)
                          //     .backgroundColor
                          //     .withOpacity(0.5),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ThemeIconWidget(ThemeIcon.backArrow,
                                          size: AppTheme.iconSize,
                                          color: Colors.white)
                                      .ripple(() {
                                    Get.back();
                                    // Navigator.of(context).pop();
                                  }),
                                  const Spacer(),
                                  Text(
                                    authorController.author.value?.name ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ).ripple(() {
                                    Get.back();
                                    //Navigator.of(context).pop();
                                  }),
                                  const Spacer(),
                                  ThemeIconWidget(ThemeIcon.more,
                                          size: AppTheme.iconSize,
                                          color: Colors.white)
                                      .ripple(() {
                                    showActionSheet();
                                  }),
                                ],
                              ).tp(55),
                            ],
                          ).hP16,
                        );
                      }),
                  GetBuilder<AuthorController>(
                      init: authorController,
                      builder: (context) {
                        return creatorInfo().p16;
                      }),
                ],
              ),
            ],
          ),

          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(
                        height: 20,
                      ),
                  GetBuilder<AuthorController>(
                      init: authorController,
                      builder: (ctx) {
                        return HorizontalMenuBar(
                          // padding: const EdgeInsets.only(top: 20),
                          selectedIndex:
                              authorController.selectedCategoryIndex.value,
                          onSegmentChange: (segment) {
                            authorController.selectCategory(segment);
                          },
                          menus: authorController.categories
                              .map((element) => element.name)
                              .toList(),
                        );
                      }),
                  GetBuilder<AuthorController>(
                      init: authorController,
                      builder: (ctx) {
                        return SizedBox(
                          height: (authorController.posts.length * 150) +
                              (authorController.posts.length * 40),
                          child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(
                                  top: 10, left: 16, right: 16),
                              itemBuilder: (BuildContext context, index) {
                                return GetBuilder<PostCardController>(
                                    init: postCardController,
                                    builder: (ctx) {
                                      return PostTile(
                                        model: authorController.posts[index],
                                      );
                                    });
                              },
                              separatorBuilder: (BuildContext context, index) {
                                return divider(
                                    context: context,
                                    height: 1,
                                    color: Theme.of(context)
                                        .dividerColor
                                        .lighten(0.3))
                                    .setPadding(bottom: 20, top: 10);
                              },
                              itemCount: authorController.posts.length),
                        );
                      }),
                ]))
              ],
            ),
          )
        ],
      ),
    );
  }


  Widget creatorInfo() {
    return authorController.isLoading == true
        ? Container() 
        : Container(
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  AvatarView(
                    url: authorController.author.value!.image,
                    size: 80,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                  height: 35,
                  width: 120,
                  child: Obx(() => BorderButtonType1(
                      text: authorController.author.value!.isFollowing()
                          ? LocalizationString.following
                          : LocalizationString.follow,
                      backgroundColor:
                          authorController.author.value!.isFollowing()
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).backgroundColor,
                      textStyle: authorController.author.value!.isFollowing()
                          ? Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w600)
                          : Theme.of(context).textTheme.titleMedium,
                      onPress: () {
                        authorController.followUnfollowUser();
                      })),
                ),
                ]
              ),
              const SizedBox(width: 40),
              Expanded(
                child: Column(
                  children: [
                    Row (
                      children: [
                        Expanded(
                          child: Text(authorController.author.value!.name,
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                color: Colors.white, fontWeight: FontWeight.w900),
                          ),
                        )
                      ]
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                              Text('${authorController.author.value!.totalPosts} ${LocalizationString.posts}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900)).rP8,
                              Text('${authorController.author.value!.totalFollowers} ${LocalizationString.followers}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900)).rP8,
                        ],
                      ),
                    const SizedBox(
                      height: 10
                    ),
                    Row(
                      children: [
                        authorController.author.value!.bio != null
                            ? Text('${authorController.author.value!.bio}',
                              maxLines: 5,
                              overflow: TextOverflow.clip,
                              style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400))
                              .rP8
                            : Container()
                      ],
                    ),
                  ],
                )
              )
            ]
          ),
        );
  }

  Widget creatorInfoOld() {
    return authorController.isLoading == true
        ? Container()
      
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AvatarView(
                url: authorController.author.value!.image,
                size: 80,
              ),
              // CachedNetworkImage(
              //   imageUrl: authorController.author.value!.image,
              //   fit: BoxFit.cover,
              //   placeholder: (context, url) =>
              //       const CircularProgressIndicator(),
              //   errorWidget: (context, url, error) => const Icon(Icons.error),
              //   height: 80,
              //   width: 80,
              // ).circular,
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(authorController.author.value!.name,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w900)),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      authorController.author.value!.totalPosts > 0
                          ? Text('${authorController.author.value!.totalPosts} ${LocalizationString.posts}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900))
                              .rP8
                          : Container(),
                      // const SizedBox(
                      //   width: 10,
                      // ),
                      authorController.author.value!.totalFollowers > 0
                          ? Text('${authorController.author.value!.totalFollowers} ${LocalizationString.followers}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900))
                              .rP8
                          : Container(),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 35,
                width: 120,
                child: Obx(() => BorderButtonType1(
                    text: authorController.author.value!.isFollowing()
                        ? LocalizationString.following
                        : LocalizationString.follow,
                    backgroundColor:
                        authorController.author.value!.isFollowing()
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).backgroundColor,
                    textStyle: authorController.author.value!.isFollowing()
                        ? Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w600)
                        : Theme.of(context).textTheme.titleMedium,
                    onPress: () {
                      authorController.followUnfollowUser();
                    })),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                child: authorController.author.value!.bio != null
                    ? Text('${authorController.author.value!.bio}',
                      style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.w400))
                      .rP8
                    : Container()
              ),
              const SizedBox(
                height: 40
              ),
            ],
          );
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
                  Navigator.of(context).pop();
                  Timer(const Duration(milliseconds: 100), () {
                    authorController.reportAuthor();
                  });
                }
              },
            ));
  }
}
