import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';
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
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const SizedBox(height: 25),
          Container(
            child: Text(
              CommonConfig.schoolName,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.w900),
            ),
          ),
          blogsList(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 102)
              .p25,
        ]));
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
                style: AppTheme.configTheme.textTheme.titleLarge!.copyWith(
                    fontSize: FontSizes.sizeXl, fontWeight: FontWeight.w600),
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
