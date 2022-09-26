import 'package:flutter/material.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class PendingBlogPostTile extends StatelessWidget {
  final BlogPostModel model;
  final VoidCallback approvedCallback;
  final VoidCallback rejectedCallback;
  final VoidCallback viewCallback;

  final FirebaseManager manager = FirebaseManager();

  PendingBlogPostTile(
      {Key? key,
      required this.model,
        required this.viewCallback,
        required this.approvedCallback,
      required this.rejectedCallback})
      : super(key: key);

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
        ).ripple((){
          viewCallback();
        }),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              model.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                width: model.categoryName.length * 10,
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Text(model.categoryName.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600))
                      .p4,
                )).round(5),
            const SizedBox(
              width: 10,
            ),
          ],
        ).ripple((){
          viewCallback();
        }),
        const Spacer(),
        Container(
          width: 100,
          color: Theme.of(context).primaryColor,
          child: Column(
            children: [
              ThemeIconWidget(
                ThemeIcon.checkMark,
                color: Theme.of(context).primaryColorLight,
                size: 25,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(LocalizationString.approve,
                  style: Theme.of(context).textTheme.bodyLarge)
            ],
          ).p16,
        ).round(5).ripple(() {
          approvedCallback();
        }),
        const SizedBox(
          width: 20,
        ),
        Container(
          width: 100,
          color: Theme.of(context).errorColor,
          child: Column(
            children: [
              ThemeIconWidget(
                ThemeIcon.close,
                color: Theme.of(context).primaryColorLight,
                size: 25,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(LocalizationString.reject,
                  style: Theme.of(context).textTheme.bodyLarge)
            ],
          ).p16,
        ).round(5).ripple(() {
          rejectedCallback();
        })
      ],
    );
  }
}

class PostTile extends StatelessWidget {
  final BlogPostModel model;

  final BlogsController blogsController = Get.find();

  PostTile(
      {Key? key,
      required this.model,
      })
      : super(key: key);

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
                    const SizedBox(height: 8,),
                    Text(model.title.toUpperCase(),
                        maxLines: 1,
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8,),
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
                            width: model.categoryName.length * 10,
                            color: Theme.of(context).primaryColor,
                            child: Center(
                              child: Text(model.categoryName.toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600))
                                  .p4,
                            )).round(5),
                      ],
                    ),
                    const SizedBox(height: 8,),
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
                          child: const ThemeIconWidget(
                            ThemeIcon.reveal,
                            size: 15,
                            color: Colors.white,
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
                          child: const ThemeIconWidget(
                            ThemeIcon.edit,
                            size: 15,
                            color: Colors.white,
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
                          child: const ThemeIconWidget(
                            ThemeIcon.message,
                            size: 15,
                            color: Colors.white,
                          ).p4,
                        ).round(8).ripple(() {
                          Get.to(() => CommentsScreen(postId: model.id));
                        }),
                        const SizedBox(width: 15),
                        model.isFeatured == true
                            ? Container(
                                height: 30,
                                color: Colors.yellow.darken(0.2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const ThemeIconWidget(
                                      ThemeIcon.delete,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      LocalizationString.removeFromFeatured,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ).hP16,
                              ).round(8).ripple(() {
                                // featuredCallback(false);
                                featureBlog(context);
                              })
                            : Container(
                                height: 30,
                                color: Theme.of(context).primaryColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const ThemeIconWidget(
                                      ThemeIcon.add,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      LocalizationString.markAsFeatured,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ).hP16,
                              ).round(8).ripple(() {
                                // featuredCallback(true);
                                featureBlog(context);
                              }),
                        const SizedBox(width: 15),
                        model.isPremium == true
                            ? Container(
                                height: 30,
                                color: Colors.yellow.darken(0.2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const ThemeIconWidget(
                                      ThemeIcon.delete,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      LocalizationString.removeFromPremium,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ).hP16,
                              ).round(8).ripple(() {
                                // premiumCallback(false);
                                premiumBlog(context);
                              })
                            : Container(
                                height: 30,
                                color: Theme.of(context).primaryColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const ThemeIconWidget(
                                      ThemeIcon.add,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      LocalizationString.markAsPremium,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ).hP16,
                              ).round(8).ripple(() {
                                // premiumCallback(true);
                                premiumBlog(context);
                              }),
                      ],
                    )
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

  featureBlog(BuildContext context) {
    AppUtil.popupAction(
        cxt: context,
        title: LocalizationString.areYourSure,
        subTitle: model.isFeatured
            ? LocalizationString.wantToRemoveFromFeatured
            : LocalizationString.wantToAddToFeatured,
        yesHandler: () {
          blogsController.addOrRemoveFeaturedBlog(model);
        });
  }

  premiumBlog(BuildContext context) {
    AppUtil.popupAction(
        cxt: context,
        title: LocalizationString.areYourSure,
        subTitle: model.isPremium
            ? LocalizationString.wantToRemoveFromPremium
            : LocalizationString.wantToAddToPremium,
        yesHandler: () {
          blogsController.addOrRemovePremiumBlog(model);
        });
  }
}
