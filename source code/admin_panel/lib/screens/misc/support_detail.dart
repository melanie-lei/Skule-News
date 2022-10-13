import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class SupportDetail extends StatefulWidget {
  final SupportModel supportDetail;

  const SupportDetail({Key? key, required this.supportDetail})
      : super(key: key);

  @override
  _SupportDetailState createState() => _SupportDetailState();
}

class _SupportDetailState extends State<SupportDetail> {
  final SupportTicketController supportTicketController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackNavigationBar(title: LocalizationString.supportRequest),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userInfo(),
            const SizedBox(
              height: 20,
            ),
            replyView(),
            const SizedBox(
              height: 20,
            ),
            widget.supportDetail.status == 1
                ? SizedBox(
                    height: 50,
                    width: 200,
                    child: FilledButtonType1(
                      text: LocalizationString.markAsClosed,
                      onPress: () {
                        supportTicketController
                            .markAsClosed(widget.supportDetail);
                      },
                    ),
                  )
                : Container()
          ],
        ).p25,
      ),
    );
  }

  Widget userInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ThemeIconWidget(
              ThemeIcon.name,
              color: Theme.of(context).primaryColorLight,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.supportDetail.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            ThemeIconWidget(
              ThemeIcon.email,
              color: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.supportDetail.email,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        widget.supportDetail.phone != null
            ? Column(
                children: [
                  Row(
                    children: [
                      ThemeIconWidget(
                        ThemeIcon.mobile,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.supportDetail.phone!,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  )
                ],
              )
            : Container()
      ],
    );
  }

  Widget replyView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ThemeIconWidget(
              ThemeIcon.message,
              color: Theme.of(context).primaryColorLight,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.supportDetail.message,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
