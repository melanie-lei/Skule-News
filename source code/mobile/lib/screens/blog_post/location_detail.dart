// import 'package:flutter/material.dart';
// import 'package:skule_news_mobile/helper/common_import.dart';
// import 'package:get/get.dart';
//
// class LocationDetail extends StatefulWidget {
//   final NewsLocation location;
//
//   const LocationDetail({Key? key, required this.location}) : super(key: key);
//
//   @override
//   State<LocationDetail> createState() => _LocationDetailState();
// }
//
// class _LocationDetailState extends State<LocationDetail> {
//   final PostCardController postCardController = Get.find();
//   final LocationController locationController = Get.find();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       locationController.setCurrentLocation(widget.location);
//       locationController.loadPosts(locationId: widget.location.id);
//     });
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Theme.of(context).backgroundColor,
//       child: Column(
//         children: [
//           BackNavBar(
//             title: widget.location.name,
//             // centerTitle: true,
//             backTapHandler: () {
//               Get.back();
//             },
//           ),
//           Expanded(
//             child: CustomScrollView(
//               slivers: [
//                 SliverList(
//                     delegate: SliverChildListDelegate([
//                       GetBuilder<LocationController>(
//                           init: locationController,
//                           builder: (context) {
//                             return creatorInfo().vP16;
//                           }),
//                       divider(context: context).tP16,
//                       loadPosts()
//                     ]))
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget loadPosts() {
//     return GetBuilder<LocationController>(
//         init: locationController,
//         builder: (context) {
//           return SizedBox(
//             height: locationController.posts.length * 540,
//             child: ListView.separated(
//                 physics: const NeverScrollableScrollPhysics(),
//                 padding:  EdgeInsets.zero,
//                 itemBuilder: (BuildContext context, index) {
//                   return GetBuilder<PostCardController>(
//                       init: postCardController,
//                       builder: (ctx) {
//                         return PostTile(
//                           model: locationController.posts[index],
//                         );
//                       });
//                 },
//                 separatorBuilder: (BuildContext context, index) {
//                   return const SizedBox(
//                     height: 40,
//                   );
//                 },
//                 itemCount: locationController.posts.length),
//           );
//         });
//   }
//
//   Widget creatorInfo() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Image.network(
//           widget.location.image,
//           height: 300,
//           width: MediaQuery.of(context).size.width,
//           fit: BoxFit.cover,
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(widget.location.name, style: Theme.of(context).textTheme.titleMedium),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     widget.location.totalPosts > 0
//                         ? Text('${widget.location.totalPosts} ${LocalizationString.posts},',
//                         style: Theme.of(context).textTheme.bodyMedium)
//                         .rP8
//                         : Container(),
//                     widget.location.totalFollowers > 0
//                         ? Text('${widget.location.totalFollowers} ${LocalizationString.followers},',
//                         style: Theme.of(context).textTheme.bodyMedium)
//                         .rP8
//                         : Container(),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(
//               width: 10,
//             ),
//             SizedBox(
//               height: 40,
//               width: 120,
//               child: Obx(() => BorderButtonType1(
//                   text: locationController.location.value?.isFollowing()
//                       ? LocalizationString.following
//                       : LocalizationString.follow,
//                   backgroundColor:
//                   locationController.location.value?.isFollowing()
//                       ? Theme.of(context).primaryColor
//                       : Theme.of(context).backgroundColor,
//                   textStyle: locationController.location.value?.isFollowing()
//                       ? Theme.of(context).textTheme.bodyMedium
//                       : Theme.of(context).textTheme.bodyMedium,
//                   onPress: () {
//                     locationController.followUnfollowLocation(
//                         locationController.location.value!);
//                   })),
//             )
//           ],
//         ).hP16,
//       ],
//     );
//   }
// }
