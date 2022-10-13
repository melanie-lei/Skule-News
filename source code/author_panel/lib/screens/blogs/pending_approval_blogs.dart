import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class PendingApprovalsBlogs extends StatefulWidget {
  final BlogStatusType statusType;

  const PendingApprovalsBlogs({Key? key, required this.statusType})
      : super(key: key);

  @override
  _PendingApprovalsBlogsState createState() => _PendingApprovalsBlogsState();
}

class _PendingApprovalsBlogsState extends State<PendingApprovalsBlogs> {
  TextEditingController search = TextEditingController();

  final PendingBlogsController pendingBlogsController = Get.find();

  CategoryModel? selectedCategory;

  @override
  void initState() {
    // TODO: implement initState
    pendingBlogsController.getPendingBlogs(widget.statusType);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PendingApprovalsBlogs oldWidget) {
    // TODO: implement didUpdateWidget
    pendingBlogsController.getPendingBlogs(widget.statusType);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleBar(title: LocalizationString.blogs),
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
                text: pendingBlogsController.selectedCategory.value?.name,
                // showBorder: true,
                cornerRadius: 5,
                hintText: "(none selected)",
                onPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        SelectCategory(callback: (category) {
                      pendingBlogsController.selectCategory(category);
                      pendingBlogsController.getPendingBlogs(widget.statusType);
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
          cornerRadius: 10,
          hintText: LocalizationString.searchBlog,
          onChanged: (text) {
            pendingBlogsController.searchTextChanged(text);
            pendingBlogsController.getPendingBlogs(widget.statusType);
          },
        ).shadow(context: context).setPadding(top: 25),
        Expanded(
          child: GetBuilder<PendingBlogsController>(
              init: pendingBlogsController,
              builder: (ctx) {
                return pendingBlogsController.pendingApprovalBlogs.isNotEmpty
                    ? ListView.separated(
                        itemCount:
                            pendingBlogsController.pendingApprovalBlogs.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return Container(
                              color:
                                  Theme.of(context).backgroundColor.darken(0.1),
                              child: PendingBlogPostTile(
                                model: pendingBlogsController
                                    .pendingApprovalBlogs[index],
                              )).round(10).ripple(() {
                            Get.to(() => BlogPreview(
                                model: pendingBlogsController
                                    .pendingApprovalBlogs[index]));
                          });
                        },
                        separatorBuilder: (BuildContext ctx, int index) {
                          return Container(
                            height: 0.2,
                            color: Theme.of(context).dividerColor,
                            width: double.infinity,
                          ).vP8;
                        },
                      ).vP25
                    : noDataFound(context);
              }),
        ),
      ],
    );
  }
}
