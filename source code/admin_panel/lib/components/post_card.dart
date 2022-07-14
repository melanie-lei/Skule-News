import 'package:flutter/material.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class PostCard extends StatefulWidget {
  final BlogPostModel model;

  const PostCard({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
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
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    width: double.infinity,
                    height: double.infinity,
                  ).round(10),
                  Positioned(
                      left: 0,
                      top: 0,
                      right: 0,
                      bottom: 0,
                      child: widget.model.isVideoBlog() == true
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
                            ).round(10)
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
        Text(widget.model.content,
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
                      ).p4,
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
    return FutureBuilder<AuthorsModel>(
      future: loadSourceInfo(widget.model.authorId),
      // a previously-obtained Future<String> or null
      builder: (BuildContext ctx, AsyncSnapshot<AuthorsModel> snapshot) {
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

  Future<AuthorsModel> loadSourceInfo(String id) async {
    AuthorsModel? detail;
    await getIt<FirebaseManager>().getSourceDetail(id).then((value) {
      detail = value!;
    });
    return detail!;
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
      const Spacer(),
      widget.model.totalSaved > 0
          ? Text('${widget.model.totalSaved}',
              style: Theme.of(context).textTheme.bodyMedium)
          : Container(),
      const SizedBox(
        width: 10,
      ),
    ]);
  }

  void openComments() {
    Get.to(() => CommentsScreen(
      postId: widget.model.id,
    ));
  }

  void openProfile(String id) async {
    //Get.to(() => NewsSourceDetail(userId: id));
  }
}
