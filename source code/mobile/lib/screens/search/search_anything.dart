import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class SearchAnything extends StatefulWidget {
  const SearchAnything({
    Key? key,
  }) : super(key: key);

  @override
  _SearchAnythingState createState() => _SearchAnythingState();
}

class _SearchAnythingState extends State<SearchAnything> {
  List<String> filters = [
    LocalizationString.posts,
    LocalizationString.authors,
    LocalizationString.hashTags,
  ];

  final RecommendationController recommendationController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: [
          SizedBox(
            height: 60,
            child: HorizontalSegmentBar(
                selectedTextStyle: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600),
                textStyle: Theme.of(context).textTheme.titleMedium,
                onSegmentChange: (segment) {
                  recommendationController.segmentChanged(segment);
                },
                segments: filters),
          ),
          Expanded(child: loadView())
        ],
      ),
    );
  }

  Widget loadView() {
    return GetBuilder<RecommendationController>(
        init: recommendationController,
        builder: (context) {
          if (recommendationController.selectedSegment.value == 0) {
            return postsView();
          } else if (recommendationController.selectedSegment.value == 1) {
            return sourceView();
          } else if (recommendationController.selectedSegment.value == 2) {
            return hashtagView();
          }
          // else if (recommendationController.selectedSegment.value == 3) {
          //   return locationView();
          // }
          else {
            return postsView();
          }
        });
  }

  Widget postsView() {
    return GetBuilder<RecommendationController>(
        init: recommendationController,
        builder: (ctx) {
          return recommendationController.isLoadingPosts.value
              ? const HomeScreenShimmer()
              : ListView.separated(
                      padding: const EdgeInsets.only(top: 25),
                      itemBuilder: (BuildContext context, index) {
                        return PostTile(
                          model: recommendationController.posts[index],
                          tapHandler: () {
                            recommendationController.searchedPostOpened(
                                recommendationController.posts[index]);
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, index) {
                        return const SizedBox(
                          height: 40,
                        );
                      },
                      itemCount: recommendationController.posts.length)
                  .hP16;
        });
  }

  Widget sourceView() {
    return GetBuilder<RecommendationController>(
        init: recommendationController,
        builder: (ctx) {
          return recommendationController.isLoadingSource.value
              ? const ShimmerUsers().hP16
              : ListView.separated(
                  padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                  itemBuilder: (BuildContext context, index) {
                    return AuthorTile(
                      model: recommendationController.sources[index],
                      actionCallback: () {
                        recommendationController.followUnfollowSourceAndUser(
                            newsSource: recommendationController.sources[index],
                            isSource: true);
                      },
                      tapHandler: () {
                        recommendationController.searchedPostOpened(
                            recommendationController.posts[index]);
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, index) {
                    return const SizedBox(
                      height: 40,
                    );
                  },
                  itemCount: recommendationController.sources.length);
        });
  }

  // Widget locationView() {
  //   return GetBuilder<RecommendationController>(
  //       init: recommendationController,
  //       builder: (ctx) {
  //         return recommendationController.isLoadingLocations.value
  //             ? const ShimmerUsers().hP16
  //             : ListView.separated(
  //                 padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
  //                 itemBuilder: (BuildContext context, index) {
  //                   return LocationTile(
  //                     model: recommendationController.locations[index],
  //                     actionCallback: () {
  //                       recommendationController.followUnfollowLocation(
  //                         recommendationController.locations[index],
  //                       );
  //                     },
  //                   );
  //                 },
  //                 separatorBuilder: (BuildContext context, index) {
  //                   return const SizedBox(
  //                     height: 40,
  //                   );
  //                 },
  //                 itemCount: recommendationController.locations.length);
  //       });
  // }

  Widget hashtagView() {
    return GetBuilder<RecommendationController>(
        init: recommendationController,
        builder: (ctx) {
          return recommendationController.isLoadingHashtags.value
              ? const ShimmerUsers().hP16
              : ListView.separated(
                  padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                  itemBuilder: (BuildContext context, index) {
                    return HashtagTile(
                      model: recommendationController.hashtags[index],
                      actionCallback: () {
                        recommendationController.followUnfollowHashtag(
                          recommendationController.hashtags[index],
                        );
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, index) {
                    return const SizedBox(
                      height: 20,
                    );
                  },
                  itemCount: recommendationController.hashtags.length);
        });
  }
}
