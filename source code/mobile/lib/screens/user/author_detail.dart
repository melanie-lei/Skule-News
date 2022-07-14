import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
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

    authorController.getAuthorDetail(id: widget.userId);
    authorController.getAuthorCategories(id: widget.userId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          GetBuilder<AuthorController>(
              init: authorController,
              builder: (ctx) {
                return Container(
                  height: 90,
                  color: Theme.of(context).backgroundColor.withOpacity(0.5),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ThemeIconWidget(ThemeIcon.backArrow,
                                  size: AppTheme.iconSize,
                                  color: Theme.of(context).iconTheme.color)
                              .ripple(() {
                            Get.back();
                            // Navigator.of(context).pop();
                          }),
                          const Spacer(),
                          Text(
                            authorController.author.value?.name ?? '',
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ).ripple(() {
                            Get.back();
                            //Navigator.of(context).pop();
                          }),
                          const Spacer(),
                          ThemeIconWidget(ThemeIcon.more,
                                  size: AppTheme.iconSize,
                                  color: Theme.of(context).iconTheme.color)
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
          divider(context: context).vP16,
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
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
                              padding: const EdgeInsets.only(top: 10,left: 16,right: 16),
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
                                return const SizedBox(
                                  height: 40,
                                );
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
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: authorController.author.value!.image,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                height: 80,
                width: 80,
              )
              .circular,
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(authorController.author.value!.name,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      authorController.author.value!.totalPosts > 0
                          ? Text('${authorController.author.value!.totalPosts} ${LocalizationString.posts},',
                                  style: Theme.of(context).textTheme.bodyMedium)
                              .rP8
                          : Container(),
                      authorController.author.value!.totalFollowers > 0
                          ? Text('${authorController.author.value!.totalFollowers} ${LocalizationString.followers},',
                                  style: Theme.of(context).textTheme.bodyMedium)
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
              )
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
