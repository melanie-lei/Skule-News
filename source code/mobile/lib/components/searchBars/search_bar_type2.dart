import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class SearchBarType2 extends StatefulWidget {
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchStarted;
  final ValueChanged<String> onSearchCompleted;

  final Color? iconColor;
  final bool? showSearchIocn;
  final String? hintText;

  const SearchBarType2(
      {Key? key,
        required this.onSearchCompleted,

        this.hintText,
        this.onSearchStarted,
        this.onSearchChanged,
        this.iconColor,
        this.showSearchIocn
      })
      : super(key: key);

  @override
  SearchBarType2State createState() => SearchBarType2State();
}

class SearchBarType2State extends State<SearchBarType2> {
  late ValueChanged<String>? onSearchChanged;
  late VoidCallback? onSearchStarted;
  late ValueChanged<String> onSearchCompleted;
  TextEditingController controller = TextEditingController();
  late Color? iconColor;
  String? searchText;
  bool? showSearchIocn;
  late String? hintText;

  @override
  void initState() {
    // TODO: implement initState
    onSearchChanged = widget.onSearchChanged;
    onSearchStarted = widget.onSearchStarted;
    onSearchCompleted = widget.onSearchCompleted;
    iconColor = widget.iconColor;
    showSearchIocn = widget.showSearchIocn;
    hintText = widget.hintText;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      // color: Colors.yellow,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            showSearchIocn == true
                ? ThemeIconWidget(
              ThemeIcon.search,
              color: iconColor,
              size: 25,
            ).ripple(() {
              if (searchText != null && searchText!.length > 2) {
                onSearchChanged!(searchText!);
              }
            })
                : Container(),
            Expanded(
              child: Column(
                children: [
                  TextField(
                      controller: controller,
                      onEditingComplete: () {
                        onSearchCompleted(controller.text);
                      },
                      onChanged: (value) {
                        searchText = value;
                        controller.text = searchText!;
                        if(onSearchChanged!= null){
                          onSearchChanged!(value);
                        }
                        setState(() {});
                      },
                      onTap: (){
                        if(onSearchStarted!= null){
                          onSearchStarted!();
                        }
                      },
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        hintStyle: Theme.of(context).textTheme.bodySmall,
                        hintText: hintText ?? LocalizationString.searchAnything,
                        border: InputBorder.none,
                      )).lP8,
                  Container(
                    height: 0.2,
                    color: Theme.of(context).dividerColor,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}