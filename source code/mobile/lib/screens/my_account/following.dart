import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class Following extends StatefulWidget {
  const Following({
    Key? key,
  }) : super(key: key);

  @override
  _FollowingState createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  List<String> filters = [
    LocalizationString.authors,
    LocalizationString.hashTags,
  ];

  final FollowingController followingController = Get.find();

  @override
  void initState() {
    // TODO: implement initState

    followingController.searchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: BackNavigationBar(
        centerTitle: true,
        title: LocalizationString.following,
        backTapHandler: () {
          Get.back();
        },
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            HorizontalSegmentBar(
                selectedTextStyle: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).primaryColor,fontWeight: FontWeight.w600),
                textStyle: Theme.of(context).textTheme.titleMedium,
                onSegmentChange: (segment) {
                  followingController.segmentChanged(segment);
                },
                segments: filters),
            Expanded(child: loadView())
          ],
        ),
      ),
    );
  }

  Widget loadView() {
    return GetBuilder<FollowingController>(
        init: followingController,
        builder: (context) {
          if (followingController.selectedSegment.value == 0) {
            return sourceView();
          } else if (followingController.selectedSegment.value == 1) {
            return hashtagView();
          } else {
            return sourceView();
          }
        });
  }

  Widget sourceView() {
    return GetBuilder<FollowingController>(
        init: followingController,
        builder: (ctx) {
          return followingController.isLoadingSource.value
              ? const ShimmerUsers().hP16
              : ListView.separated(
                  padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                  itemBuilder: (BuildContext context, index) {
                    return AuthorTile(
                      model: followingController.sources[index],
                      actionCallback: () {
                        followingController.followUnfollowSourceAndUser(
                            newsSource: followingController.sources[index],
                            isSource: true);
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, index) {
                    return const SizedBox(
                      height: 20,
                    );
                  },
                  itemCount: followingController.sources.length);
        });
  }

  // Widget locationView() {
  //   return GetBuilder<FollowingController>(
  //       init: followingController,
  //       builder: (ctx) {
  //         return followingController.isLoadingLocations.value
  //             ? const ShimmerUsers().hP16
  //             : ListView.separated(
  //                 padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
  //                 itemBuilder: (BuildContext context, index) {
  //                   return LocationTile(
  //                     model: followingController.locations[index],
  //                     actionCallback: () {
  //                       followingController.followUnfollowLocation(
  //                         followingController.locations[index],
  //                       );
  //                     },
  //                   );
  //                 },
  //                 separatorBuilder: (BuildContext context, index) {
  //                   return const SizedBox(
  //                     height: 40,
  //                   );
  //                 },
  //                 itemCount: followingController.locations.length);
  //       });
  // }

  Widget hashtagView() {
    return GetBuilder<FollowingController>(
        init: followingController,
        builder: (ctx) {
          return followingController.isLoadingHashtags.value
              ? const ShimmerUsers().hP16
              : ListView.separated(
                  padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                  itemBuilder: (BuildContext context, index) {
                    return HashtagTile(
                      model: followingController.hashtags[index],
                      actionCallback: () {
                        followingController.followUnfollowHashtag(
                          followingController.hashtags[index],
                        );
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, index) {
                    return const SizedBox(
                      height: 20,
                    );
                  },
                  itemCount: followingController.hashtags.length);
        });
  }
}
