import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class PendingBlogPostTile extends StatelessWidget {
  final BlogPostModel model;

  final FirebaseManager manager = FirebaseManager();

  PendingBlogPostTile({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            CachedNetworkImage(
              imageUrl: model.thumbnailImage,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const CircularProgressIndicator().p25,
              errorWidget: (context, url, error) => const Icon(Icons.error),
              height: 120,
              width: 120,
            ),
            model.isVideoBlog() == true
                ? Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            color: Colors.black12,
                          ),
                        ),
                        const Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: ThemeIconWidget(
                              ThemeIcon.play,
                              size: 70,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  )
                : Container()
          ],
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(model.title.toUpperCase(),
                maxLines: 1, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(
              height: 10,
            ),
            Container(
                width: model.categoryName.length * 12,
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Text(model.categoryName.toUpperCase(),
                          style: AppTheme.configTheme.textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.w600))
                      .p4,
                )).round(5),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}

class PostTile extends StatelessWidget {
  final BlogPostModel model;
  final BlogsController blogsController = Get.find();

  PostTile({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: model.thumbnailImage,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const CircularProgressIndicator().p25,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                height: 120,
                width: 120,
              ),
              model.isVideoBlog() == true
                  ? Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              color: Colors.black12,
                            ),
                          ),
                          const Positioned(
                              left: 0,
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: ThemeIconWidget(
                                ThemeIcon.play,
                                size: 70,
                                color: Colors.white,
                              )),
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
          Expanded(
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Text(model.title.toUpperCase(),
                        maxLines: 1,
                        style: Theme.of(context).textTheme.titleLarge),
                    const Spacer(),
                    Row(
                      children: [
                        Row(
                          children: [
                            AvatarView(
                              url: model.authorPicture,
                              size: 25,
                            ),
                            Text(model.authorName,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge)
                                .hP8,
                          ],
                        ),
                        Container(
                            width: model.categoryName.length * 12,
                            color: Theme.of(context).primaryColor,
                            child: Center(
                              child: Text(model.categoryName.toUpperCase(),
                                      style: AppTheme
                                          .configTheme.textTheme.bodyMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w600))
                                  .p4,
                            )).round(5),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const ThemeIconWidget(
                          ThemeIcon.clock,
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Text(model.date,
                            style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(width: 15),
                        Container(
                          height: 30,
                          width: 30,
                          color: Theme.of(context).primaryColor,
                          child: ThemeIconWidget(
                            ThemeIcon.reveal,
                            size: 15,
                            color: CommonConfig.buttonTextColor,
                          ).p4,
                        ).round(8).ripple(() {
                          Get.to(() => BlogPreview(
                                model: model,
                              ));
                        }),
                        const SizedBox(width: 15),
                        Container(
                          height: 30,
                          width: 30,
                          color: Theme.of(context).primaryColor,
                          child: ThemeIconWidget(
                            ThemeIcon.edit,
                            size: 15,
                            color: CommonConfig.buttonTextColor,
                          ).p4,
                        ).round(8).ripple(() {
                          Get.to(() => AddBlog(
                                post: model,
                              ));
                        }),
                        const SizedBox(width: 15),
                        Container(
                          height: 30,
                          width: 30,
                          color: Theme.of(context).primaryColor,
                          child: ThemeIconWidget(
                            ThemeIcon.message,
                            size: 15,
                            color: CommonConfig.buttonTextColor,
                          ).p4,
                        ).round(8).ripple(() {
                          Get.to(() => CommentsScreen(postId: model.id));
                        }),
                        const SizedBox(width: 15),
                      ],
                    ).vP8
                  ],
                ),
                // const Spacer(),
              ],
            ).hP16,
          )
        ],
      ),
    ).round(10);
  }
}
