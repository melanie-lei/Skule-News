// import 'package:flutter/material.dart';
// import 'package:skule_news_mobile/helper/common_import.dart';
// import 'package:get/get.dart';
//
// class TrendingHashtags extends StatefulWidget {
//   const TrendingHashtags({Key? key}) : super(key: key);
//
//   @override
//   _TrendingHashtagsState createState() => _TrendingHashtagsState();
// }
//
// class _TrendingHashtagsState extends State<TrendingHashtags> {
//
//   final TrendingHashtagController trendingHashtagController = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Theme.of(context).backgroundColor,
//         body: CustomScrollView(
//           slivers: [
//             SliverList(
//                 delegate: SliverChildListDelegate([
//               Row(
//                 children: [
//                   ThemeIconWidget(
//                     ThemeIcon.backArrow,
//                     color: Theme.of(context).iconTheme.color,
//                     size: 30,
//                   ).ripple(() {
//                     Get.back();
//                   }),
//                   Expanded(
//                     child: SearchBarType3(
//                         showSearchIocn: true,
//                         iconColor: Theme.of(context).primaryColor,
//                         onSearchCompleted: (searchTerm) {}),
//                   ),
//                 ],
//               ).setPadding(left: 16, right: 16, top: 25, bottom: 20),
//               // category view
//               Container(
//                 height: 0.5,
//                 color: Theme.of(context).dividerColor,
//               ),
//
//               trendingHashTagsSection(),
//             ]))
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget trendingHashTagsSection() {
//     return GetBuilder<TrendingHashtagController>(
//         init: trendingHashtagController,
//         builder: (ctx) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 LocalizationString.trendingAtTwitter,
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ).bP16,
//               for (int i = 0;
//                   i < trendingHashtagController.hashTags.length;
//                   i++)
//                 Row(
//                   children: [
//                     Container(
//                         color: Theme.of(context).primaryColor,
//                         height: 25,
//                         width: 25,
//                         child: Center(
//                           child: Text(
//                             '$i',
//                             style: Theme.of(context).textTheme.bodySmall,
//                           ),
//                         )).circular,
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Text(trendingHashtagController.hashTags[i].name,
//                         style: Theme.of(context).textTheme.bodySmall)
//                   ],
//                 ).vP8
//             ],
//           );
//         }).p16.ripple(() {
//       //const TrendingOnTwitter()
//     });
//   }
// }
