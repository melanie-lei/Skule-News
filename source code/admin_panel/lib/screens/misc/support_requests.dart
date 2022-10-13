import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class SupportRequests extends StatefulWidget {
  const SupportRequests({Key? key}) : super(key: key);

  @override
  _SupportRequestsState createState() => _SupportRequestsState();
}

class _SupportRequestsState extends State<SupportRequests> {
  final SupportRequestsController supportRequestsController = Get.find();

  @override
  void initState() {
    // TODO: implement initState

    supportRequestsController.getAllSupportTickets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          TitleBar(title: LocalizationString.supportRequest),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: GetBuilder<SupportRequestsController>(
                init: supportRequestsController,
                builder: (ctx) {
                  return supportRequestsController.supportRequests.isNotEmpty ? ListView.separated(
                    itemCount: supportRequestsController.supportRequests.length,
                    itemBuilder: (ctx, index) {
                      return Container(
                        color: Theme.of(context).backgroundColor.lighten(),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${LocalizationString.supportId} ${supportRequestsController.supportRequests[index].id}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .errorColor)),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(LocalizationString.raisedBy,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .errorColor)),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          supportRequestsController
                                              .supportRequests[index].name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    supportRequestsController
                                        .supportRequests[index].message,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    maxLines: 2,
                                  ),
                                ],
                              ).p16.ripple(() {
                                Get.to(() => SupportDetail(
                                    supportDetail: supportRequestsController
                                        .supportRequests[index]));
                              }),
                            ),
                            supportRequestsController
                                        .supportRequests[index].status ==
                                    1
                                ? Container()
                                : Container(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .lighten(),
                                    child: Column(
                                      children: [
                                        ThemeIconWidget(
                                          ThemeIcon.checkMark,
                                          color: Theme.of(context)
                                              .primaryColor
                                              .lighten(),
                                          size: 25,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(LocalizationString.replied,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge)
                                      ],
                                    ).p16,
                                  ).round(5),
                            const SizedBox(width: 10)
                          ],
                        ),
                      ).round(10);
                    },
                    separatorBuilder: (ctx, index) {
                      return Container(
                        height: 1,
                        width: double.infinity,
                        color: Theme.of(context).dividerColor,
                      ).vP16;
                    },
                  ) : noDataFound(context);
                }),
          )
        ],
      ).p25,
    );
  }
}
