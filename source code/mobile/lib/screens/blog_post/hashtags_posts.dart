// import 'package:flutter/material.dart';
// import 'package:music_streaming_mobile/helper/common_import.dart';
// import 'package:get/get.dart';
//
// class HashtagsPosts extends StatefulWidget {
//   final String hashtag;
//
//   const HashtagsPosts({Key? key, required this.hashtag}) : super(key: key);
//
//   @override
//   _HashtagsPostsState createState() => _HashtagsPostsState();
// }
//
// class _HashtagsPostsState extends State<HashtagsPosts> {
//   final controller = PageController(viewportFraction: 0.90, keepPage: true);
//   final HashtagController hashtagPostsController = Get.find();
//   final PostCardController postCardController = Get.find();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     hashtagPostsController.clearPosts();
//     hashtagPostsController.loadPosts(widget.hashtag);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).backgroundColor,
//       // appBar: BackNavigationBar(
//       //   title: widget.hashtag,
//       //   centerTitle: true,
//       //   backTapHandler: () {
//       //     Get.back();
//       //   },
//       // ),
//       body: Column(
//         children: [
//           SizedBox(
//             height: 220,
//             width: double.infinity,
//             child: Stack(
//               children: [
//                 Center(
//                   child: Text(
//                     '#${widget.hashtag}',
//                     style: Theme.of(context).textTheme.displayLarge,
//                   ),
//                 ),
//                 Container(
//                   color: Colors.black12,
//                 ),
//                 Positioned(
//                     left: 20,
//                     top: 50,
//                     child: const ThemeIconWidget(
//                       ThemeIcon.backArrow,
//                       color: Colors.white,
//                     ).ripple(() {
//                       Get.back();
//                     }))
//               ],
//             ),
//           ),
//           Expanded(
//             child: GetBuilder<HashtagController>(
//                 init: hashtagPostsController,
//                 builder: (ctx) {
//                   return ListView.separated(
//                       padding: const EdgeInsets.only(top: 25),
//                       itemBuilder: (BuildContext context, index) {
//                         return GetBuilder<PostCardController>(
//                             init: postCardController,
//                             builder: (ctx) {
//                               return PostTile(
//                                 model: hashtagPostsController.posts[index],
//                               );
//                             });
//                       },
//                       separatorBuilder: (BuildContext context, index) {
//                         return divider(context: context,height: 0.5).vp(50);
//                       },
//                       itemCount: hashtagPostsController.posts.length).hP16;
//                 }),
//           ),
//         ],
//       ),
//     );
//   }
// }
