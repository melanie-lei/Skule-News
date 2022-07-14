import 'package:flutter/material.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class CustomNavigationBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final Widget child;
  final bool? showSeparator;
  final Color? backgroundColor;

  const CustomNavigationBar(
      {Key? key, required this.child, this.showSeparator, this.backgroundColor})
      : preferredSize = const Size.fromHeight(60.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: preferredSize,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: backgroundColor ?? Theme.of(context).backgroundColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 50, child: child).tp(50),
                    const Spacer(),
                  ],
                ).hP16,
              ),
            ),
            showSeparator == true
                ? Divider(height: 1, color: Theme.of(context).dividerColor)
                : Container()
          ],
        ));
  }
}

class BackNavigationBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String? title;
  final bool? showDivider;
  final bool? centerTitle;

  const BackNavigationBar(
      {Key? key, this.title, this.showDivider, this.centerTitle})
      : preferredSize = const Size.fromHeight(80.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: preferredSize,
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: [
              Row(
                children: [
                  ThemeIconWidget(ThemeIcon.backArrow,
                          size: 20, color: Theme.of(context).iconTheme.color)
                      .ripple(() {
                    Get.back();
                  }),
                  centerTitle == true ? const Spacer() : Container(),
                  centerTitle != true ? Container(width: 20) : Container(),
                  title != null
                      ? Text(title!, style: Theme.of(context).textTheme.bodyLarge).ripple(() {
                          Get.back();
                        })
                      : Container(),
                  centerTitle == true ? const Spacer() : Container(),
                  const SizedBox(width: 20)
                ],
              ).setPadding(top: 40, left: 16, right: 16),
              const Spacer(),
              // showDivider == true
              //     ?
              divider(context: context, height: 1)
              // : Container()
            ],
          ),
        ));
  }
}

class NavigationBarWithCloseBtn extends StatelessWidget
    with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String? title;
  final bool? showDivider;
  final bool? centerTitle;

  const NavigationBarWithCloseBtn(
      {Key? key, this.title, this.showDivider, this.centerTitle})
      : preferredSize = const Size.fromHeight(60.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: preferredSize,
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: [
              Row(
                children: [
                  const ThemeIconWidget(ThemeIcon.close,
                          size: 20)
                      .ripple((){
                        Get.back();
                  }),
                  centerTitle == true ? const Spacer() : Container(),
                  centerTitle != true ? Container(width: 20) : Container(),
                  title != null
                      ? Text(title!, style: Theme.of(context).textTheme.bodyLarge).ripple(() {
                          Get.back();
                        })
                      : Container(),
                  centerTitle == true ? const Spacer() : Container(),
                  Container(width: 20)
                ],
              ).tp(55).hP16,
              const Spacer(),
              showDivider == true
                  ? Divider(height: 1, color: Theme.of(context).dividerColor)
                  : Container()
            ],
          ),
        ));
  }
}

class TitleNavigationBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String? title;
  final bool? showDivider;

  const TitleNavigationBar({Key? key, required this.title, this.showDivider})
      : preferredSize = const Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: preferredSize,
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title!, style: Theme.of(context).textTheme.bodyLarge).bP16,
              showDivider == true
                  ? Divider(height: 1, color: Theme.of(context).dividerColor)
                  : Container()
            ],
          ),
        ));
  }
}
