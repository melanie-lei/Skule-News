// import 'package:flutter/material.dart';
// import 'package:skule_news_admin_panel/helper/common_import.dart';
//
// class HomeSlidersScreen extends StatefulWidget {
//   const HomeSlidersScreen({Key? key}) : super(key: key);
//
//   @override
//   _HomeSlidersScreenState createState() => _HomeSlidersScreenState();
// }
//
// class _HomeSlidersScreenState extends State<HomeSlidersScreen> {
//   TextEditingController search = TextEditingController();
//   List<BannerModel> sliders = [];
//   FirebaseManager manager = FirebaseManager();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     getAllHomeSliders();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.singleton.primaryBackgroundColor,
//       body: SizedBox(
//         height: double.infinity,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TitleBar(title: LocalizationString.categories),
//             const SizedBox(
//               height: 20,
//             ),
//             Row(
//               children: [
//                 Text(
//                   '${sliders.length} ${LocalizationString.sliders}',
//                   style: TextStyles.body.lightColor.bold,
//                 ),
//                 const Spacer(),
//
//                 const SizedBox(
//                   width: 10,
//                 ),
//
//               ],
//             ),
//             const Divider(
//               height: 50,
//             ),
//             Expanded(
//               child: Container(
//                 color: AppTheme.singleton.themeColor.withOpacity(0.05),
//                 child: GridView.builder(
//                   shrinkWrap: true,
//                   padding: EdgeInsets.zero,
//                   itemCount: sliders.length,
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisSpacing: 20,
//                       mainAxisSpacing: 20,
//                       crossAxisCount: Responsive.isDesktop(context)
//                           ? 5
//                           : Responsive.isTablet(context)
//                           ? 4
//                           : 3),
//                   itemBuilder: (BuildContext context, int index) {
//                     return HomeSliderTile(homeSlider: sliders[index]).ripple(() {
//                       NavigationService.instance.navigateToRoute(
//                           MaterialPageRoute(
//                               builder: (ctx) =>
//                                   AddNewBanner(banner: sliders[index])));
//                     });
//                   },
//                 ).p25,
//               ).round(20),
//             ),
//           ],
//         ),
//       ).p25,
//     );
//   }
//
//   getAllHomeSliders() {
//     manager.getAllSliderBy(status: 1).then((result) {
//       sliders = result;
//       setState(() {});
//     });
//   }
// }
