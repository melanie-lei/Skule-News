// import 'package:flutter/material.dart';
// import 'package:music_streaming_mobile/helper/common_import.dart';
//
// class TwitterCard extends StatelessWidget {
//   final NewsModel model;
//   final VoidCallback shareBtnCallBack;
//   final VoidCallback likeBtnCallBack;
//   final VoidCallback messageBtnCallBack;
//   final VoidCallback profileCallBack;
//   final VoidCallback itemCallBack;
//
//   const TwitterCard({
//     Key? key,
//     required this.model,
//     required this.shareBtnCallBack,
//     required this.likeBtnCallBack,
//     required this.messageBtnCallBack,
//     required this.profileCallBack,
//     required this.itemCallBack,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 400,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               AvatarView(
//                 url: AppConfig.dummyProfilePictureUrl,
//                 size: 40,
//               ).ripple(() {
//                 profileCallBack();
//               }),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(model.authorName, style: Theme.of(context).textTheme.bodySmall),
//                   // Text(model.authorUserName,
//                   //     style: Theme.of(context).textTheme.subtitle1),
//                 ],
//               ).lP8,
//               const Spacer(),
//             ],
//           ),
//           Text(model.shortContent,
//               maxLines: 2, style: Theme.of(context).textTheme.bodyMedium)
//               .vP16,
//           Expanded(
//             child: Image.network(
//               model.coverImage,
//               fit: BoxFit.cover,
//               width: double.infinity,
//             ).round(5).ripple(() {
//               itemCallBack();
//             }),
//           ),
//           Text(model.date,
//               maxLines: 2, style: Theme.of(context).textTheme.subtitle1)
//               .tP16,
//           divider(height: 0.2).vP16,
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               const ThemeIconWidget(ThemeIcon.fav).rP4.ripple(() {
//                 likeBtnCallBack();
//               }),
//               const SizedBox(
//                 width: 20,
//               ),
//               Row(
//                 children: [
//                   const ThemeIconWidget(ThemeIcon.message).rP4,
//                   Text(
//                     LocalizationString.reply,
//                     style: Theme.of(context).textTheme.subtitle1,
//                   )
//                 ],
//               ).ripple(() {
//                 messageBtnCallBack();
//               }),
//               const SizedBox(
//                 width: 20,
//               ),
//               Row(
//                 children: [
//                   const ThemeIconWidget(ThemeIcon.share).rP4,
//                   Text(
//                     LocalizationString.shareTweet,
//                     style: Theme.of(context).textTheme.subtitle1,
//                   )
//                 ],
//               ).ripple(() {
//                 shareBtnCallBack();
//               }),
//             ],
//           )
//         ],
//       ),
//     ).p16.shadowWithBorder(radius: 10, borderWidth: 0.5);
//   }
// }
