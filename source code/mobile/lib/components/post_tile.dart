import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class PostTile extends StatefulWidget {
  final NewsModel model;
  final VoidCallback? tapHandler;

  const PostTile({
    Key? key,
    required this.model,
    this.tapHandler
  }) : super(key: key);

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  final PostCardController postcardController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: postInfo()),

              const SizedBox(
                width: 10,
              ),

              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.model.coverImage,
                    fit: BoxFit.cover,
                    // placeholder: (context, url) =>
                    // const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    width: 100,
                    height: 80,
                  ).round(5),
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
                              child: const Center(
                                child: ThemeIconWidget(
                                  ThemeIcon.play,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            ).round(5)
                          : Container()),
                ],
              ),
              // divider(context: context).vP16,
            ],
          ).ripple(() {
            Get.to(() => NewsFullDetail(model: widget.model));
            if(widget.tapHandler != null){
              widget.tapHandler!();
            }
          }),
          divider(context: context).vP16,
          bottomBar(),
        ],
      ),
    ); //.p16.shadowWithoutRadius(context: context),
  }

  Widget bottomBar() {
    return Row(
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
        const Spacer(),

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
      ],
    );
  }

  Widget postInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        userInfo(),
        Text(widget.model.shortContent,
            maxLines: 2, style: Theme.of(context).textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget userInfo() {
    return FutureBuilder<NewsSourceModel>(
      future: loadSourceInfo(widget.model.authorId),
      builder: (BuildContext ctx, AsyncSnapshot<NewsSourceModel> snapshot) {
        if (snapshot.hasData) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AvatarView(
                url: snapshot.data!.image,
                size: 20,
              ).ripple(() {
                openProfile(snapshot.data!.id);
              }),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.model.authorName,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600)),
                  Text(
                      '${snapshot.data!.totalFollowers} ${LocalizationString.followers.toLowerCase()}',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ).lP8.ripple(() {
                openProfile(snapshot.data!.id);
              }),
              const Spacer(),
            ],
          ).bP8;
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

  Future<NewsSourceModel> loadSourceInfo(String id) async {
    NewsSourceModel? detail;
    await getIt<FirebaseManager>().getSourceDetail(id).then((value) {
      detail = value!;
    });
    return detail!;
  }

  void openProfile(String id) async {
    Get.to(() => NewsSourceDetail(userId: id));
  }
}
