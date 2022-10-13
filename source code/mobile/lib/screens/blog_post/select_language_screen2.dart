// import 'package:flutter/material.dart';
// import 'package:skule_news_mobile/helper/common_import.dart';
//
// class SelectLanguageScreen2 extends StatefulWidget {
//   const SelectLanguageScreen2({Key? key}) : super(key: key);
//
//   @override
//   _SelectLanguageScreen2State createState() => _SelectLanguageScreen2State();
// }
//
// class _SelectLanguageScreen2State extends State<SelectLanguageScreen2> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           const SizedBox(height: 80),
//           Image.asset(
//             'assets/images/language.png',
//             height: 50,
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Text(
//             LocalizationString.selectLangauge,
//             style: Theme.of(context).textTheme.titleMedium.bold,
//           ),
//           const SizedBox(
//             height: 25,
//           ),
//           Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   languageBox('English'),
//                   languageBox('Turkish'),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   languageBox('Portuguese'),
//                   languageBox('Japanese'),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   languageBox('	Russian'),
//                   languageBox('	Korean'),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   languageBox('French'),
//                   languageBox('Vietnamese'),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   languageBox('Italian'),
//                   languageBox('Indonesian'),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   languageBox('Polish'),
//                   languageBox('Greek'),
//                 ],
//               )
//             ],
//           ).hP25,
//           const SizedBox(
//             height: 50,
//           ),
//           Text(
//             LocalizationString.canChangeLangFromSetting,
//             style: Theme.of(context).textTheme.bodySmall.extraLight,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget languageBox(String language) {
//     return SizedBox(
//             width: 120,
//             height: 35,
//             child: Center(
//               child: Text(
//                 language,
//                 style: Theme.of(context).textTheme.bodySmall,
//               ),
//             ).borderWithRadius(value: 0.2, radius: 10))
//
//         .bP8;
//   }
// }
