import 'package:flutter/material.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';

class DrawerListItemGroup extends StatefulWidget {
  final List<Widget> items;
  final String title;

  const DrawerListItemGroup(
      {Key? key, required this.items, required this.title})
      : super(key: key);

  @override
  _DrawerListItemGroupState createState() => _DrawerListItemGroupState();
}

class _DrawerListItemGroupState extends State<DrawerListItemGroup> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
            height: 55,
            width: double.infinity,
            color: Theme.of(context).backgroundColor.lighten(0.05),
            child: Align(
                alignment: Responsive.isTablet(context)
                    ? Alignment.center
                    : Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.title,
                        style: Theme.of(context).textTheme.titleMedium),
                    ThemeIconWidget(
                      isOpen == true ? ThemeIcon.upArrow : ThemeIcon.downArrow,
                      color: Theme.of(context).iconTheme.color,
                      size: 25,
                    )
                  ],
                ).hP16.ripple(() {
                  setState(() {
                    if (isOpen == true) {
                      isOpen = false;
                    } else {
                      isOpen = true;
                    }
                  });
                }))).round(10).hP8,
        isOpen == true
            ? Column(
                children: [for (Widget item in widget.items) item],
              )
            : Container()
      ],
    );
  }
}

class DrawerListItem extends StatelessWidget {
  final ThemeIconWidget icon;
  final String title;
  final bool isSelected;

  const DrawerListItem(
      {Key? key,
      required this.icon,
      required this.title,
      required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Row(
        mainAxisAlignment: Responsive.isTablet(context)
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          icon,
          Responsive.isTablet(context)
              ? Container()
              : Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    isSelected == true
                        ? Container(
                            height: 10,
                            width: 10,
                            color: Theme.of(context).primaryColor,
                          ).circular
                        : Container()
                  ],
                )
        ],
      ),
    ).hP16;
  }
}
