import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class ReportedAuthors extends StatefulWidget {
  const ReportedAuthors({Key? key}) : super(key: key);

  @override
  _ReportedAuthorsState createState() => _ReportedAuthorsState();
}

class _ReportedAuthorsState extends State<ReportedAuthors> {
  final AuthorController authorController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    authorController.getReportedAuthors();
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
            child: GetBuilder<AuthorController>(
                init: authorController,
                builder: (ctx) {
                  return authorController.authors.isNotEmpty
                      ? ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: authorController.authors.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            return SizedBox(
                              height: 120,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: AuthorTile(
                                      model: authorController.authors[index],
                                    ),
                                  ),
                                  Container(
                                    color: Theme.of(context).primaryColorLight,
                                    height: 100,
                                    width: 100,
                                    child: Center(
                                      child: Text(
                                        LocalizationString.deleteRequest,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        textAlign: TextAlign.center,
                                      ),
                                    ).p8,
                                  ).round(10).ripple(() {
                                    authorController.deleteRequestForAuthor(
                                        authorController.authors[index]);
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
                                        LocalizationString.deActivateAuthor,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        textAlign: TextAlign.center,
                                      ),
                                    ).p8,
                                  ).round(10).ripple(() {
                                    authorController.deactivateAuthor(
                                        authorController.authors[index]);
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
                        ).hP25
                      : noDataFound(context);
                }),
          ),
        ],
      ).p25,
    );
  }
}
