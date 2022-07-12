import 'package:flutter/material.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

// class PostTile extends StatefulWidget {
//   final PostModel model;
//   final VoidCallback? tapHandler;
//
//   const PostTile({Key? key, required this.model, this.tapHandler})
//       : super(key: key);
//
//   @override
//   State<PostTile> createState() => _PostTileState();
// }
//
// class _PostTileState extends State<PostTile> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 150,
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Expanded(child: postInfo()),
//
//               const SizedBox(
//                 width: 10,
//               ),
//
//               Stack(
//                 children: [
//                   CachedNetworkImage(
//                     imageUrl: widget.model.thumbnailImage,
//                     fit: BoxFit.cover,
//                     // placeholder: (context, url) =>
//                     // const CircularProgressIndicator(),
//                     errorWidget: (context, url, error) =>
//                         const Icon(Icons.error),
//                     width: 100,
//                     height: 80,
//                   ).round(5),
//                   Positioned(
//                       left: 0,
//                       top: 0,
//                       right: 0,
//                       bottom: 0,
//                       child: widget.model.isVideoNews() == true
//                           ? Container(
//                               color: Theme.of(context)
//                                   .primaryColorDark
//                                   .withOpacity(0.5),
//                               child: const Center(
//                                 child: ThemeIconWidget(
//                                   ThemeIcon.play,
//                                   size: 50,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ).round(5)
//                           : Container()),
//                 ],
//               ),
//               // divider(context: context).vP16,
//             ],
//           )
//           //     .ripple(() {
//           //   Get.to(() => NewsFullDetail(model: widget.model));
//           //   if(widget.tapHandler != null){
//           //     widget.tapHandler!();
//           //   }
//           // })
//           ,
//           divider(context: context).vP16,
//           bottomBar(),
//         ],
//       ),
//     ); //.p16.shadowWithoutRadius(context: context),
//   }
//
//   Widget bottomBar() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         const ThemeIconWidget(
//           ThemeIcon.clock,
//           size: 15,
//         ),
//         const SizedBox(
//           width: 5,
//         ),
//         Text(widget.model.date,
//             maxLines: 2, style: Theme.of(context).textTheme.bodyMedium),
//         const Spacer(),
//       ],
//     );
//   }
//
//   Widget postInfo() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         userInfo(),
//         Text(widget.model.content,
//             maxLines: 2,
//             style: Theme.of(context)
//                 .textTheme
//                 .titleMedium!
//                 .copyWith(fontWeight: FontWeight.w600)),
//       ],
//     );
//   }
//
//   Widget userInfo() {
//     return FutureBuilder<NewsSourceModel>(
//       future: loadSourceInfo(widget.model.authorId),
//       builder: (BuildContext ctx, AsyncSnapshot<NewsSourceModel> snapshot) {
//         if (snapshot.hasData) {
//           return Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               AvatarView(
//                 url: snapshot.data!.image,
//                 size: 20,
//               ).ripple(() {
//                 openProfile(snapshot.data!.id);
//               }),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(widget.model.authorName,
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodyMedium!
//                           .copyWith(fontWeight: FontWeight.w600)),
//                   Text(
//                       '${snapshot.data!.totalFollowers} ${LocalizationString.followers.toLowerCase()}',
//                       style: Theme.of(context).textTheme.bodySmall),
//                 ],
//               ).lP8.ripple(() {
//                 openProfile(snapshot.data!.id);
//               }),
//               const Spacer(),
//             ],
//           ).bP8;
//         } else if (snapshot.hasError) {
//           return Text(LocalizationString.loading,
//               style: Theme.of(context).textTheme.bodyMedium);
//         } else {
//           return SizedBox(
//             height: 50,
//             child: Text('', style: Theme.of(context).textTheme.bodyMedium),
//           );
//         }
//       },
//     );
//   }
//
//   Future<NewsSourceModel> loadSourceInfo(String id) async {
//     NewsSourceModel? detail;
//     await getIt<FirebaseManager>().getSourceDetail(id).then((value) {
//       detail = value!;
//     });
//     return detail!;
//   }
//
//   void openProfile(String id) async {
//     // Get.to(() => NewsSourceDetail(userId: id));
//   }
// }

class PendingBlogPostTile extends StatelessWidget {
  final BlogPostModel model;
  final VoidCallback viewCallback;

  final VoidCallback approvedCallback;
  final VoidCallback rejectedCallback;

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
        Image.network(
          model.thumbnailImage,
          height: Responsive.isMobile(context) ? 70 : 100,
          width: Responsive.isMobile(context) ? 70 : 100,
          fit: BoxFit.cover,
        ).round(10).ripple(() {
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
              color: Theme.of(context).primaryColor,
              child: Text(
                model.categoryName.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium,
              ).p4,
            ).round(5),
            const SizedBox(
              width: 10,
            ),
          ],
        ).ripple(() {
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
                ThemeIcon.checkMark,
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
