import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';
import 'dart:convert';

class AddBlog extends StatefulWidget {
  final BlogPostModel? post;

  const AddBlog({Key? key, this.post}) : super(key: key);

  @override
  _AddBlogState createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  final AddBlogController addBlogController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.post != null) {
      addBlogController.setPost(widget.post!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.post != null
          ? BackNavigationBar(title: LocalizationString.back)
          : null,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          TitleBar(title: LocalizationString.addBlog).p25,
          Expanded(
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: addBlog().p25,
            ),
          ),
        ],
      ),
    );
  }

  Widget addBlog() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        contentTypeDropDown(),
        const SizedBox(
          height: 20,
        ),
        postThumbnailWidget(),
        const SizedBox(
          height: 20,
        ),
        Obx(() => addBlogController.contentType.value == 2
            ? Column(
                children: [
                  videoFileWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              )
            : Container()),
        categoryDropDown(),
        const SizedBox(
          height: 20,
        ),
        postTileWidget(),
        const SizedBox(
          height: 20,
        ),
        postHashtagsWidget(),
        const SizedBox(
          height: 20,
        ),
        postContentWidget(),
        const SizedBox(
          height: 20,
        ),
        Obx(() => HandleAvailabilityStatus(
            status: addBlogController.availabilityStatus.value,
            statusHandler: (status) {
              addBlogController.setAvailabilityStatus(status);
            })).vP8,
        const SizedBox(
          height: 40,
        ),
        Center(
          child: SizedBox(
              width: 150,
              height: 60,
              child: FilledButtonType1(
                  enabledTextStyle: Theme.of(context).textTheme.titleMedium,
                  text: LocalizationString.submit,
                  onPress: () {
                    addBlogController.submitBlog();
                  })),
        )
      ],
    ).vP25;
  }

  Widget postTileWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalizationString.blogTitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          height: 10,
        ),
        Obx(() => InputField(
              controller: addBlogController.postTitle.value,
              showBorder: true,
              cornerRadius: 5,
            ))
      ],
    );
  }

  Widget postHashtagsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalizationString.commaSeparatedHashtags,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          height: 10,
        ),
        Obx(() => InputField(
              controller: addBlogController.hashtags.value,
              showBorder: true,
              cornerRadius: 5,
            ))
      ],
    );
  }

  Widget postContentWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalizationString.blogContent,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          height: 10,
        ),
        Obx(() => InputField(
              controller: addBlogController.postDescription.value,
              showBorder: true,
              cornerRadius: 5,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
            ))
      ],
    );
  }

  Widget postThumbnailWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalizationString.thumbnailImage,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: Obx(() => InputField(
                    controller: addBlogController.thumbnailImage.value,
                    showBorder: true,
                    cornerRadius: 5,
                  )),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 60,
              width: 60,
              child: Image.memory(
                  addBlogController.thumbnailImageBytes ??
                      const Base64Codec().decode(
                          "R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7"),
                  fit: BoxFit.cover),
            ).round(5),
            const SizedBox(width: 10),
            SizedBox(
              height: 60,
              width: 120,
              child: FilledButtonType1(
                  enabledTextStyle: Theme.of(context).textTheme.titleMedium,
                  text: LocalizationString.choose,
                  onPress: () {
                    setState(() {
                      addBlogController.pickThumbnailImage(() {
                        setState(() { build(context); });
                      });
                    });
                  }),
            ),
          ],
        ),
      ],
    );
  }

  Widget videoFileWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalizationString.video,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: Obx(() => InputField(
                    controller: addBlogController.postFile.value,
                    showBorder: true,
                    cornerRadius: 5,
                  )),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 60,
              width: 120,
              child: FilledButtonType1(
                  enabledTextStyle: Theme.of(context).textTheme.titleMedium,
                  text: LocalizationString.choose,
                  onPress: () {
                    addBlogController.pickFile();
                  }),
            )
          ],
        ),
      ],
    );
  }

  Widget categoryDropDown() {
    return SizedBox(
      height: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LocalizationString.selectCategory,
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Obx(() => DropdownFiled(
                isDisabled: true,
                text: addBlogController.categoryName.value,
                // showBorder: true,
                cornerRadius: 5,
                hintText: "(none selected)",
                onPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        SelectCategory(callback: (category) {
                      addBlogController.setCategory(category);
                    }),
                  );
                })),
          )
        ],
      ),
    );
  }

  Widget contentTypeDropDown() {
    return SizedBox(
      height: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LocalizationString.contentType,
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              height: 60,
              color: Theme.of(context).backgroundColor.darken(0.05),
              child: GetBuilder<AddBlogController>(
                  init: addBlogController,
                  builder: (ctx) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        hint: Text(
                          LocalizationString.select,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        items: ['Image', 'Video']
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: addBlogController.contentType.value == 2
                            ? 'Video'
                            : 'Image',
                        onChanged: (value) {
                          addBlogController.setContentType(
                              value as String == 'Image' ? 1 : 2);
                        },
                        buttonHeight: 60,
                        buttonWidth: double.infinity,
                        itemHeight: 60,
                      ),
                    ).hP16;
                  }),
            ).round(5),
          )
        ],
      ),
    );
  }
}
