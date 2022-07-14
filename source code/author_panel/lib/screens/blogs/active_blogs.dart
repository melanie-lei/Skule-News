import 'package:flutter/material.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class BlogsList extends StatefulWidget {
  final BlogStatusType statusType;

  const BlogsList({Key? key, required this.statusType}) : super(key: key);

  @override
  _BlogsListState createState() => _BlogsListState();
}

class _BlogsListState extends State<BlogsList> {
  TextEditingController search = TextEditingController();
  final BlogsController blogsController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  loadData() {
    if (widget.statusType == BlogStatusType.active) {
      blogsController.getActiveBlogs();
    } else if (widget.statusType == BlogStatusType.deactivated) {
      blogsController.getDeActivatedBlogs();
    } else if (widget.statusType == BlogStatusType.featured) {
      blogsController.getFeaturedBlogs();
    }
  }

  @override
  void didUpdateWidget(covariant BlogsList oldWidget) {
    // TODO: implement didUpdateWidget
    loadData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleBar(
              title: widget.statusType == BlogStatusType.deactivated
                  ? LocalizationString.deActivatedBlogs
                  : widget.statusType == BlogStatusType.featured
                      ? LocalizationString.featuredBlogs
                      : LocalizationString.blogs),
          const SizedBox(
            height: 20,
          ),
          categoryDropDown(),
          Expanded(child: blogsWidget()),
        ],
      ).setPadding(left: 25, right: 25, top: 25),
    );
  }

  Widget categoryDropDown() {
    return SizedBox(
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LocalizationString.selectCategory,
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Obx(() => DropdownFiled(
                isDisabled: true,
                text: blogsController.selectedCategory.value?.name,
                // showBorder: true,
                cornerRadius: 5,
                onPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        SelectCategory(callback: (category) {
                      blogsController.selectCategory(category);
                      blogsController.getActiveBlogs();
                    }),
                  );
                })),
          )
        ],
      ),
    );
  }

  Widget blogsWidget() {
    return Column(
      children: [
        InputField(
          controller: search,
          hintText: LocalizationString.searchBlog,
          onChanged: (text) {
            blogsController.searchTextChanged(text);
            blogsController.getActiveBlogs();
          },
          cornerRadius: 10,
        ).shadow(context: context).setPadding(top: 25),
        Expanded(
          child: GetBuilder<BlogsController>(
              init: blogsController,
              builder: (ctx) {
                return blogsController.activeBlogs.isNotEmpty ? ListView.separated(
                  itemCount: blogsController.activeBlogs.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return Container(
                      color: Theme.of(context).backgroundColor.darken(0.1),
                      child: PostTile(
                        model: blogsController.activeBlogs[index],
                      ),
                    ).round(10);
                  },
                  separatorBuilder: (BuildContext ctx, int index) {
                    return Container(
                      height: 0.2,
                      color: Theme.of(context).dividerColor,
                      width: double.infinity,
                    ).vP8;
                  },
                ).vP25 : noDataFound(context);
              }),
        ),
      ],
    );
  }
}
