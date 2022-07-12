import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class NewsSourceDetail extends StatefulWidget {
  final String userId;

  const NewsSourceDetail({Key? key, required this.userId}) : super(key: key);

  @override
  State<NewsSourceDetail> createState() => _NewsSourceDetailState();
}

class _NewsSourceDetailState extends State<NewsSourceDetail> {
  final PostCardController postCardController = Get.find();
  final SourceController sourceController = Get.find();

  @override
  void initState() {
    // TODO: implement initState

    sourceController.getSourceDetail(id: widget.userId);
    sourceController.getSourceCategories(id: widget.userId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          GetBuilder<SourceController>(
              init: sourceController,
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
                            sourceController.reporter.value?.name ?? '',
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
                  ),
                );
              }),
          GetBuilder<SourceController>(
              init: sourceController,
              builder: (context) {
                return creatorInfo().p16;
              }),
          divider(context: context).vP8,
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  GetBuilder<SourceController>(
                      init: sourceController,
                      builder: (ctx) {
                        return HorizontalMenuBar(
                          // padding: const EdgeInsets.only(top: 20),
                          selectedIndex:
                              sourceController.selectedCategoryIndex.value,
                          onSegmentChange: (segment) {
                            sourceController.selectCategory(segment);
                          },
                          menus: sourceController.categories
                              .map((element) => element.name)
                              .toList(),
                        );
                      }),
                  GetBuilder<SourceController>(
                      init: sourceController,
                      builder: (ctx) {
                        return SizedBox(
                          height: (sourceController.posts.length * 150) +
                              (sourceController.posts.length * 40),
                          child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(top: 10),
                              itemBuilder: (BuildContext context, index) {
                                return GetBuilder<PostCardController>(
                                    init: postCardController,
                                    builder: (ctx) {
                                      return PostTile(
                                        model: sourceController.posts[index],
                                      );
                                    });
                              },
                              separatorBuilder: (BuildContext context, index) {
                                return const SizedBox(
                                  height: 40,
                                );
                              },
                              itemCount: sourceController.posts.length),
                        );
                      }),
                ]))
              ],
            ),
          )
        ],
      ).hP16,
    );
  }

  Widget creatorInfo() {
    return sourceController.isLoading == true
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: sourceController.reporter.value!.image,
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
                  Text(sourceController.reporter.value!.name,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      sourceController.reporter.value!.totalPosts > 0
                          ? Text('${sourceController.reporter.value!.totalPosts} ${LocalizationString.posts},',
                                  style: Theme.of(context).textTheme.bodyMedium)
                              .rP8
                          : Container(),
                      sourceController.reporter.value!.totalFollowers > 0
                          ? Text('${sourceController.reporter.value!.totalFollowers} ${LocalizationString.followers},',
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
                    text: sourceController.reporter.value!.isFollowing()
                        ? LocalizationString.following
                        : LocalizationString.follow,
                    backgroundColor:
                        sourceController.reporter.value!.isFollowing()
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).backgroundColor,
                    textStyle: sourceController.reporter.value!.isFollowing()
                        ? Theme.of(context).textTheme.titleMedium
                        : Theme.of(context).textTheme.titleMedium,
                    onPress: () {
                      sourceController.followUnfollowUser();
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
                  sourceController.reportSource();
                }
              },
            ));
  }
}
