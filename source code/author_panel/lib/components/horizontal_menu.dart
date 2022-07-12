import 'package:flutter/material.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';

class HorizontalMenuBar extends StatefulWidget {
  final Function(int) onSegmentChange;
  final List<Widget> childs;

  final double? height;
  final EdgeInsets? padding;

  const HorizontalMenuBar(
      {Key? key,
      required this.onSegmentChange,
      required this.childs,
      this.height,
      this.padding})
      : super(key: key);

  @override
  _HorizontalMenuBarState createState() => _HorizontalMenuBarState();
}

class _HorizontalMenuBarState extends State<HorizontalMenuBar> {
  List<Widget> childs = [];
  String selectedMenu = 'Sports';
  Widget? selectedChild;
  late double? height;
  late EdgeInsets? padding;

  @override
  void initState() {
    // TODO: implement initState
    childs = widget.childs;
    height = widget.height;
    padding = widget.padding;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 28,
      child: Center(
        child: ListView.builder(
            padding: padding ?? EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, index) {
              return childs[index].hP4.ripple(() {
                setState(() {
                  // selectedMenu = menus[index];
                  widget.onSegmentChange(index);
                });
              });
            },
            itemCount: childs.length),
      ),
    );
  }
}

class StaggeredMenuBar extends StatefulWidget {
  final String? title;
  final Function(int) onSegmentChange;
  final List<Widget> childs;

  const StaggeredMenuBar({
    Key? key,
    this.title,
    required this.childs,
    required this.onSegmentChange,
  }) : super(key: key);

  @override
  _StaggeredMenuBarState createState() => _StaggeredMenuBarState();
}

class _StaggeredMenuBarState extends State<StaggeredMenuBar> {
  List<Widget> childs = [];
  String selectedMenu = 'Sports';
  Widget? selectedChild;
  late String? title;

  @override
  void initState() {
    // TODO: implement initState
    childs = widget.childs;
    title = widget.title;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title != null
            ? Text(title!, style: Theme.of(context).textTheme.bodyLarge)
                .bP16
            : Container(),
        Wrap(
          spacing: 5,
          runSpacing: 10,
          children: <Widget>[for (int i = 0; i < childs.length; i++) childs[i]],
        ),
      ],
    ).vP16;
  }
}

class HorizontalSegmentBar extends StatefulWidget {
  final List<String> segments;
  final Function(int) onSegmentChange;
  final TextStyle? textStyle;
  final TextStyle? selectedTextStyle;
  final double? width;

  const HorizontalSegmentBar({
    Key? key,
    required this.onSegmentChange,
    required this.segments,
    this.textStyle,
    this.selectedTextStyle,
    this.width,
  }) : super(key: key);

  @override
  _HorizontalSegmentBarState createState() => _HorizontalSegmentBarState();
}

class _HorizontalSegmentBarState extends State<HorizontalSegmentBar> {
  List<String> menus = ['Detail', 'Related'];
  int selectedMenuIndex = 0;
  late TextStyle? textStyle;
  late TextStyle? selectedTextStyle;
  late double width;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    menus = widget.segments;
    textStyle = widget.textStyle;
    selectedTextStyle = widget.selectedTextStyle;
    width = 0;
    Future.delayed(Duration.zero, () {
      setState(() {
        width = widget.width ?? MediaQuery.of(context).size.width;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  selectedMenuIndex = index;
                  widget.onSegmentChange(index);
                });
              },
              child: SizedBox(
                width: width / menus.length,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 10),
                    Text(menus[index],
                        style: index == selectedMenuIndex
                            ? selectedTextStyle ??
                            Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).primaryColor)
                            : textStyle ?? Theme.of(context).textTheme.bodyLarge),
                    index == selectedMenuIndex
                        ? Container(
                            height: 2,
                            width: width / menus.length,
                            color: Theme.of(context).primaryColor,
                          ).round(10)
                        : Container(
                            height: 1,
                            width: width / menus.length,
                            color: Theme.of(context).dividerColor,
                          )
                  ],
                ),
              ),
            );
          },
          itemCount: menus.length),
    );
  }
}

class LargeHorizontalMenuBar extends StatefulWidget {
  final Function(int) onSegmentChange;
  final List<Widget> childs;

  const LargeHorizontalMenuBar({
    Key? key,
    required this.onSegmentChange,
    required this.childs,
  }) : super(key: key);

  @override
  _LargeHorizontalMenuBarState createState() => _LargeHorizontalMenuBarState();
}

class _LargeHorizontalMenuBarState extends State<LargeHorizontalMenuBar> {
  List<Widget> childs = [];
  Widget? selectedChild;

  @override
  void initState() {
    // TODO: implement initState
    childs = widget.childs;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, index) {
            return Align(
                alignment: Alignment.centerLeft,
                child: childs[index].rp(25).ripple(() {
                  setState(() {
                    // selectedMenu = menus[index];
                    widget.onSegmentChange(index);
                  });
                }));
          },
          itemCount: childs.length),
    );
  }
}
