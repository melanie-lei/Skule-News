import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';

class SearchBarType1 extends StatefulWidget {
  final ValueChanged<String>? onSearchCompleted;
  final Color iconColor;
  final Color? bgColor;
  final String? searchText;
  final bool? needBackButton;
  final double? radius;
  final String? hintText;

  const SearchBarType1(
      {Key? key,
        this.bgColor,
        this.radius,
        this.searchText,
        required this.onSearchCompleted,
        required this.iconColor,
        this.needBackButton,
        this.hintText
      })
      : super(key: key);

  @override
  SearchBarType1State createState() => SearchBarType1State();
}

class SearchBarType1State extends State<SearchBarType1> {
  late ValueChanged<String>? onSearchCompleted;
  late Color iconColor;
  late Color? bgColor;
  late String? searchText;
  late bool? needBackButton;
  late double? radius;
  late String? hintText;

  @override
  void initState() {
    // TODO: implement initState

    onSearchCompleted = widget.onSearchCompleted;
    iconColor = widget.iconColor;
    bgColor = widget.bgColor;
    searchText = widget.searchText;
    needBackButton = widget.needBackButton;
    radius = widget.radius;
    hintText = widget.hintText;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          needBackButton == true
              ? IconButton(
              onPressed: () {
                // NavigationService.instance.goBack();
              },
              icon: ThemeIconWidget(
                ThemeIcon.backArrow,
                color: Theme.of(context).iconTheme.color
              ))
              : Container(),
          Expanded(
            child: TextField(
                onChanged: (value) {
                  searchText = value;
                },
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  hintStyle: Theme.of(context).textTheme.bodySmall,
                  hintText: hintText,
                  border: InputBorder.none,
                )).lP16,
          ),
          ThemeIconWidget(
            ThemeIcon.search,
            color: iconColor,
            size: 20,
          ).hP16.ripple(() {
            if (searchText != null && searchText!.length > 2) {
              onSearchCompleted!(searchText!);
            }
          })
        ],
      ),
    ).borderWithRadius(value: 0.5, radius: radius ?? 5,context: context);
  }
}


