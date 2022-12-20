import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class RecommendedSourceSection extends StatefulWidget {
  final List<AuthorModel> items;

  const RecommendedSourceSection({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  _RecommendedSourceSectionState createState() =>
      _RecommendedSourceSectionState();
}

class _RecommendedSourceSectionState extends State<RecommendedSourceSection> {
  final RecommendationController recommendationController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headingType6(
                    title: LocalizationString.recommendedSources,
                    subTitle: LocalizationString.recommendedSourcesInfo,
                    context: context)
                .hP16,
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.separated(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return authorCard(widget.items[index], index);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      width: 10,
                    );
                  }),
            ),
          ],
        ));
  }

  Widget authorCard(AuthorModel item, int index) {
    return SizedBox(
      height: double.infinity,
      width: 125,
      child: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl: item.image,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ).circular.p8.ripple(() {
                Get.to(() => AuthorDetail(userId: item.id));
              }),
            ),
          ),
          Text(
            item.name,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ).hP4.vP4.ripple(() {
            //onItemCallBack(item,index);
          }),
          SizedBox(
            height: 30,
            width: 90,
            child: BorderButtonType1(
              cornerRadius: 5,
              text: item.isFollowing()
                  ? LocalizationString.following
                  : LocalizationString.follow,
              textStyle: !item.isFollowing()
                  ? AppTheme.configTheme.textTheme.bodyLarge
                  : Theme.of(context).textTheme.bodyLarge,
              backgroundColor: !item.isFollowing()
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).backgroundColor,
              onPress: () {
                //followCallBack(LocalizationString.follow,index);
                recommendationController.followUnfollowSourceAndUser(
                    newsSource: item, isSource: true);
              },
            ),
          ).tP4
        ],
      ).vP8,
    ).borderWithRadius(value: 0.2, radius: 0, context: context);
  }
}

class RecommendedProfilesSection extends StatefulWidget {
  final List<UserModel> items;

  const RecommendedProfilesSection({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  _RecommendedProfilesSectionState createState() =>
      _RecommendedProfilesSectionState();
}

class _RecommendedProfilesSectionState
    extends State<RecommendedProfilesSection> {
  final RecommendationController recommendationController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headingType6(
                    title: LocalizationString.recommendedForYou,
                    subTitle: LocalizationString.recommendedProfile,
                    context: context)
                .hP16,
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.separated(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return profileCard(widget.items[index], index);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      width: 10,
                    );
                  }),
            ),
          ],
        ));
  }

  Widget profileCard(UserModel item, int index) {
    return SizedBox(
      height: double.infinity,
      width: 125,
      child: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl: item.image!,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ).circular.p8.ripple(() {
                Get.to(() => UserDetail(userId: item.id));
              }),
            ),
          ),
          Text(
            item.name!,
            style: Theme.of(context).textTheme.titleMedium,
          ).vP4.ripple(() {
            //onItemCallBack(item,index);
          }),
          SizedBox(
            height: 30,
            width: 90,
            child: BorderButtonType1(
              cornerRadius: 5,
              text: item.isFollowing()
                  ? LocalizationString.following
                  : LocalizationString.follow,
              textStyle: !item.isFollowing()
                  ? AppTheme.configTheme.textTheme.bodyLarge
                  : Theme.of(context).textTheme.bodyLarge,
              backgroundColor: !item.isFollowing()
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).backgroundColor,
              onPress: () {
                //followCallBack(LocalizationString.follow,index);
                recommendationController.followUnfollowSourceAndUser(
                    user: item, isSource: false);
              },
            ),
          ).tP4
        ],
      ).vP8,
    ).borderWithRadius(value: 0.2, radius: 5, context: context);
  }
}

class RecommendedHashtagSection extends StatefulWidget {
  final List<Hashtag> items;

  const RecommendedHashtagSection({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  _RecommendedHashtagSectionState createState() =>
      _RecommendedHashtagSectionState();
}

class _RecommendedHashtagSectionState extends State<RecommendedHashtagSection> {
  final RecommendationController recommendationController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headingType6(
                    title: LocalizationString.recommendedHashtags,
                    subTitle: LocalizationString.recommendedHashtagsForYou,
                    context: context)
                .hP16,
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.separated(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return hashtagCard(widget.items[index], index);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      width: 10,
                    );
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ));
  }

  Widget hashtagCard(Hashtag item, int index) {
    return SizedBox(
      height: double.infinity,
      width: 125,
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: 60,
            child: Center(
              child: Text(
                '#${item.name}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600),
              ).hP4,
            ),
          ).ripple(() {
            Get.to(() => HashtagDetail(hashTag: item));
          }),
          SizedBox(
            height: 30,
            width: 90,
            child: BorderButtonType1(
              cornerRadius: 5,
              text: item.isFollowing()
                  ? LocalizationString.following
                  : LocalizationString.follow,
              textStyle: !item.isFollowing()
                  ? AppTheme.configTheme.textTheme.bodyLarge
                  : Theme.of(context).textTheme.bodyLarge,
              backgroundColor: !item.isFollowing()
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).backgroundColor,
              onPress: () {
                //followCallBack(LocalizationString.follow,index);
                recommendationController.followUnfollowHashtag(item);
              },
            ),
          ).vP8
        ],
      ),
    ).borderWithRadius(value: 0.2, radius: 5, context: context);
  }
}

// class RecommendedLocationSection extends StatefulWidget {
//   final List<NewsLocation> items;
//
//   const RecommendedLocationSection({
//     Key? key,
//     required this.items,
//   }) : super(key: key);
//
//   @override
//   _RecommendedLocationSectionState createState() =>
//       _RecommendedLocationSectionState();
// }
//
// class _RecommendedLocationSectionState
//     extends State<RecommendedLocationSection> {
//   final RecommendationController recommendationController = Get.find();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//         height: 220,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             headingType6(
//               title: LocalizationString.recomendedLocation,
//               subTitle: LocalizationString.recommendedLocationsForYou,
//               context: context
//             ),
//             const SizedBox(height: 10,),
//             Expanded(
//               child: ListView.separated(
//                   padding: EdgeInsets.zero,
//                   scrollDirection: Axis.horizontal,
//                   itemCount: widget.items.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return locationCard(widget.items[index], index);
//                   },
//                   separatorBuilder: (BuildContext context, int index) {
//                     return const SizedBox(
//                       width: 10,
//                     );
//                   }),
//             ),
//           ],
//         )).hP16;
//   }
//
//   Widget locationCard(NewsLocation item, int index) {
//     return SizedBox(
//       height: double.infinity,
//       width: 120,
//       child: Column(
//         children: [
//           Expanded(
//             child: Stack(
//               children: [
//                 Container(
//                   width: 320.0,
//                   height: 180.0,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: NetworkImage(
//                         item.image,
//                       ),
//                       fit: BoxFit.cover,
//                       colorFilter: ColorFilter.mode(
//                           Colors.black.withOpacity(0.4), BlendMode.hardLight),
//                     ),
//                   ),
//                 ).round(5),
//                 Positioned(
//                   bottom: 10,
//                   left: 5,
//                   right: 5,
//                   child: Text(
//                     item.name,
//                     textAlign: TextAlign.center,
//                     style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
//                   ),
//                 )
//               ],
//             ).ripple(() {
//               //Get.to(() => LocationDetail(location: item));
//               // onItemCallBack(item,index);
//             }),
//           ),
//           SizedBox(
//             height: 30,
//             width: double.infinity,
//             child: BorderButtonType1(
//               cornerRadius: 5,
//               text: item.isFollowing()
//                   ? LocalizationString.following
//                   : LocalizationString.follow,
//               textStyle: Theme.of(context).textTheme.bodyLarge,
//               backgroundColor: item.isFollowing()
//                   ? Theme.of(context).primaryColor
//                   : Theme.of(context).backgroundColor,
//               onPress: () {
//                 recommendationController.followUnfollowLocation(item);
//               },
//             ),
//           ).tP4
//         ],
//       ).vP8,
//     );
//   }
//}
