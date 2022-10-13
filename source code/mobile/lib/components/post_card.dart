import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class BlogPostCard extends StatefulWidget {
  final BlogPostModel model;

  const BlogPostCard({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  State<BlogPostCard> createState() => _BlogPostCardState();
}

class _BlogPostCardState extends State<BlogPostCard> {
  final PostCardController postcardController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'post tile',
      child: SizedBox(
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // user info
            userInfo(),

            Expanded(
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.model.thumbnailImage,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    width: double.infinity,
                    height: double.infinity,
                  ).round(10).ripple(() {
                    Get.to(() => BlogPostFullDetail(model: widget.model));
                  }),
                  Positioned(
                      left: 0,
                      top: 0,
                      right: 0,
                      bottom: 0,
                      child: widget.model.isVideoNews() == true
                          ? Container(
                        color: Theme.of(context)
                            .primaryColorDark
                            .withOpacity(0.5),
                        child: Center(
                          child: ThemeIconWidget(
                            ThemeIcon.play,
                            size: 100,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      ).round(10).ripple(() {
                        Get.to(() => BlogPostFullDetail(model: widget.model));
                      })
                          : Container()),
                ],
              ),
            ),
            postInfo(),
            divider(context: context).vP16,
            commentAndLikeWidget(),
          ],
        ),
      ).p16.shadowWithoutRadius(context: context),
    );
  }

  Widget postInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.model.title,
            maxLines: 2, style: Theme.of(context).textTheme.bodyLarge)
            .vP16,
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
            : Container(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ThemeIconWidget(
              ThemeIcon.clock,
              size: 15,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(widget.model.date,
                maxLines: 2, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ).tP16,
      ],
    );
  }

  Widget userInfo() {
    return FutureBuilder<AuthorModel>(
      future: loadSourceInfo(widget.model.authorId),
      // a previously-obtained Future<String> or null
      builder: (BuildContext ctx, AsyncSnapshot<AuthorModel> snapshot) {
        if (snapshot.hasData) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AvatarView(
                url: snapshot.data!.image,
                size: 35,
              ).ripple(() {
                openProfile(snapshot.data!.id);
              }),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.model.authorName,
                      style: Theme.of(context).textTheme.bodyLarge),
                  Text(
                      '${snapshot.data!.totalFollowers} ${LocalizationString.followers.toLowerCase()}',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ).lP8.ripple(() {
                openProfile(snapshot.data!.id);
              }),
              const Spacer(),
              const ThemeIconWidget(ThemeIcon.more).ripple(() {
                showActionSheet(widget.model);
              })
            ],
          ).bP16;
        } else if (snapshot.hasError) {
          return Text(LocalizationString.loading,
              style: Theme.of(context).textTheme.bodyMedium);
        } else {
          return SizedBox(
            height: 50,
            child: Text('', style: Theme.of(context).textTheme.bodyMedium),
          );
        }
      },
    );
  }

  Future<AuthorModel> loadSourceInfo(String id) async {
    AuthorModel? detail;
    await getIt<FirebaseManager>().getAuthorDetail(id).then((value) {
      detail = value!;
    });
    return detail!;
  }

  showActionSheet(BlogPostModel news) {
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
              postcardController.reportPost(news);
            }
          },
        ));
  }

  Widget commentAndLikeWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      InkWell(
          onTap: () => openComments(),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            ThemeIconWidget(
              ThemeIcon.message,
              color: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(
              width: 5,
            ),
            widget.model.totalComments > 0
                ? Text('${widget.model.totalComments}',
                style: Theme.of(context).textTheme.bodyMedium)
                .ripple(() {
              openComments();
            })
                : Container(),
          ])),
      const SizedBox(
        width: 10,
      ),
      InkWell(
          onTap: () {
            postcardController.likeUnlikePost(widget.model);
          },
          child: ThemeIconWidget(
            widget.model.isLiked() ? ThemeIcon.favFilled : ThemeIcon.fav,
            color: widget.model.isLiked()
                ? Theme.of(context).errorColor
                : Theme.of(context).iconTheme.color,
          )),
      const SizedBox(
        width: 5,
      ),
      widget.model.totalLikes > 0
          ? Text('${widget.model.totalLikes}',
          style: Theme.of(context).textTheme.bodyMedium)
          : Container(),
      const Spacer(),
      widget.model.totalSaved > 0
          ? Text('${widget.model.totalSaved}',
          style: Theme.of(context).textTheme.bodyMedium)
          : Container(),
      const SizedBox(
        width: 10,
      ),
      InkWell(
        onTap: () {
          postcardController.saveOrDeletePost(widget.model);
        },
        child: ThemeIconWidget(
          widget.model.isSaved()
              ? ThemeIcon.bookMark
              : ThemeIcon.bookMarkOutlined,
          color: widget.model.isSaved()
              ? Theme.of(context).errorColor
              : Theme.of(context).iconTheme.color,
        ),
      )
    ]);
  }

  void openComments() {
    if (getIt<UserProfileManager>().isLogin()) {
      Get.to(() => CommentsScreen(
        postId: widget.model.id,
      ));
    } else {
      Get.to(() => const AskForLogin());
    }
  }

  void openProfile(String id) async {
    Get.to(() => AuthorDetail(userId: id));
  }
}
