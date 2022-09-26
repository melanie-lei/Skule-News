import 'package:flutter/material.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DashboardController dashboardController = Get.find();
  final BlogsController blogsController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    dashboardController.getCounter();
    blogsController.getLatestBlogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          cardsGrid(),
          const SizedBox(height: 25),
          Expanded(
              child: Responsive.isDesktop(context)
                  ? dashboardInfoGrid()
                  : SingleChildScrollView(child: dashboardInfoGrid()))
        ],
      ).p25,
    );
  }

  Widget cardsGrid() {
    return GetBuilder<DashboardController>(
        init: dashboardController,
        builder: (ctx) {
          return GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: 4,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: Responsive.isDesktop(context)
                    ? 1.8
                    : Responsive.isTablet(context)
                        ? 3.2
                        : 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                crossAxisCount: Responsive.isDesktop(context) ? 4 : 2),
            itemBuilder: (BuildContext context, int index) {
              switch (index) {
                case 0:
                  return cardItem(
                      '${dashboardController.recordCounter.value?.blogs ?? 0}',
                      LocalizationString.blogs,
                      ThemeIcon.book,
                      Colors.grey.lighten(0.25));
                case 1:
                  return cardItem(
                      '${dashboardController.recordCounter.value?.readers ?? 0}',
                      LocalizationString.users,
                      ThemeIcon.account,
                      Colors.yellow.lighten(0.25));
                case 2:
                  return cardItem(
                      '${dashboardController.recordCounter.value?.authors ?? 0}',
                      LocalizationString.authors,
                      ThemeIcon.author,
                      Colors.red.lighten(0.35));
                case 3:
                  return cardItem(
                      '${dashboardController.recordCounter.value?.featured ?? 0}',
                      LocalizationString.featured,
                      ThemeIcon.featured,
                      Colors.green.lighten(0.4));
              }
              return cardItem(
                  '${dashboardController.recordCounter.value?.blogs ?? 0}',
                  LocalizationString.blogs,
                  ThemeIcon.book,
                  Colors.grey.darken(0.2));
            },
          );
        });
  }

  Widget dashboardInfoGrid() {
    return blogsList(
            width: MediaQuery.of(context).size.width, height: double.infinity)
        .vP25;
  }

  Widget cardItem(String title, String subTitle, ThemeIcon icon, Color color) {
    return Container(
      color: color.withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              // const SizedBox(height: 5),
              Text(
                subTitle,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontWeight: FontWeight.w900),
              )
            ],
          ),
          ThemeIconWidget(icon,
              size: Responsive.isDesktop(context)
                  ? 100
                  : Responsive.isTablet(context)
                      ? 70
                      : 60)
        ],
      ).p(Responsive.isDesktop(context)
          ? 16
          : Responsive.isTablet(context)
              ? 8
              : 5),
    ).round(10);
  }

  Widget blogsList({required double width, required double height}) {
    return Container(
      color: Theme.of(context).backgroundColor.darken(0.04),
      width: width,
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocalizationString.recentBlogs,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                height: 5,
                width: 100,
                color: Theme.of(context).primaryColor,
              ).round(5)
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: GetBuilder<BlogsController>(
                init: blogsController,
                builder: (ctx) {
                  return blogsController.activeBlogs.isNotEmpty
                      ? ListView.separated(
                          itemCount: blogsController.activeBlogs.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            return Container(
                                color:
                                    Theme.of(context).backgroundColor.darken(),
                                child: PostTile(
                                  model: blogsController.activeBlogs[index],
                                )).round(10);
                          },
                          separatorBuilder: (BuildContext ctx, int index) {
                            return const SizedBox(height: 10);
                          })
                      : noDataFound(context);
                }),
          ),
        ],
      ).p25,
    ).round(20);
  }
}
