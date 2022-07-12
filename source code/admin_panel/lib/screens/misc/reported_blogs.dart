import 'package:flutter/material.dart';
import 'package:music_streaming_admin_panel/controllers/reported_blogs_controller.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class ReportedRingtones extends StatefulWidget {
  const ReportedRingtones({Key? key}) : super(key: key);

  @override
  _ReportedRingtonesState createState() => _ReportedRingtonesState();
}

class _ReportedRingtonesState extends State<ReportedRingtones> {
  final BlogsController blogsController = Get.find();
  final ReportedBlogsController reportedBlogsController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    blogsController.getReportedBlogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          TitleBar(title: LocalizationString.reportedBlogs),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: GetBuilder<BlogsController>(
                init: blogsController,
                builder: (ctx) {
                  return ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: blogsController.activeBlogs.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return SizedBox(
                        height: 120,
                        child: Row(
                          children: [
                            Expanded(
                              child: PostTile(
                                model: blogsController.activeBlogs[index],
                              ),
                            ),
                            Container(
                              color: Theme.of(context).primaryColorLight,
                              height: 100,
                              width: 100,
                              child: Center(
                                child: Text(
                                  LocalizationString.deleteRequest,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ).p8,
                            ).round(10).ripple(() {
                              reportedBlogsController.deleteRequestForBlog(
                                  reportedBlogsController.blogs[index]);
                            }),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              color: Theme.of(context).errorColor,
                              height: 100,
                              width: 100,
                              child: Center(
                                child: Text(
                                  LocalizationString.deActivateAlbum,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ).p8,
                            ).round(10).ripple(() {
                              reportedBlogsController.deactivateBlog(
                                  reportedBlogsController.blogs[index]);
                            }),
                            const SizedBox(
                              width: 20,
                            )
                          ],
                        ),
                      ).borderWithRadius(
                          value: 1, radius: 10, context: context);
                    },
                    separatorBuilder: (BuildContext ctx, int index) {
                      return const SizedBox(
                        height: 20,
                      );
                    },
                  ).hP25;
                }),
          ),
        ],
      ).p25,
    );
  }
}