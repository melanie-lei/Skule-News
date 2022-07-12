import 'package:flutter/material.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class PendingApprovalsBlogs extends StatefulWidget {
  const PendingApprovalsBlogs({Key? key}) : super(key: key);

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
    pendingBlogsController.getPendingBlogs();
    super.initState();
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
                onPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        SelectCategory(callback: (category) {
                      pendingBlogsController.selectCategory(category);
                      pendingBlogsController.getPendingBlogs();
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
            pendingBlogsController.getPendingBlogs();
          },
        ).shadow(context: context).setPadding(top: 25),
        Expanded(
          child: GetBuilder<PendingBlogsController>(
              init: pendingBlogsController,
              builder: (ctx) {
                return ListView.separated(
                  itemCount: pendingBlogsController.pendingApprovalBlogs.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return PendingBlogPostTile(
                      model: pendingBlogsController.pendingApprovalBlogs[index],
                      viewCallback: () {
                        Get.to(() => BlogPreview(
                            model: pendingBlogsController
                                .pendingApprovalBlogs[index]));
                      },
                      approvedCallback: () {
                        pendingBlogsController.approveBlog(
                            pendingBlogsController.pendingApprovalBlogs[index]);
                      },
                      rejectedCallback: () {
                        pendingBlogsController.rejectBlog(
                            pendingBlogsController.pendingApprovalBlogs[index]);
                      },
                    );
                  },
                  separatorBuilder: (BuildContext ctx, int index) {
                    return Container(
                      height: 0.2,
                      color: Theme.of(context).dividerColor,
                      width: double.infinity,
                    ).vP8;
                  },
                ).vP25;
              }),
        ),
      ],
    );
  }
}
