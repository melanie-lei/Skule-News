import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';

class AddBlogController extends GetxController {
  Rx<TextEditingController> thumbnailImage = TextEditingController().obs;
  Rx<TextEditingController> postFile = TextEditingController().obs;
  Rx<TextEditingController> postTitle = TextEditingController().obs;
  Rx<TextEditingController> postDescription = TextEditingController().obs;
  Rx<TextEditingController> hashtags = TextEditingController().obs;

  Rx<BlogPostModel?> post = Rx<BlogPostModel?>(null);

  Uint8List? videoFileBytes;
  Uint8List? thumbnailImageBytes;

  RxInt contentType = 1.obs;

  RxString categoryId = ''.obs;
  RxString categoryName  = ''.obs;

  RxBool isPremium = false.obs;

  Rx<AvailabilityStatus> availabilityStatus = AvailabilityStatus.active.obs;

  setAvailabilityStatus(AvailabilityStatus status) {
    availabilityStatus.value = status;
    update();
  }

  setPremiumStatus(bool status) {
    isPremium.value = status;
    update();
  }

  setPost(BlogPostModel model) {
    post.value = model;

    postTitle.value.text = model.title;
    hashtags.value.text = model.hashtags.map((e) => '#$e').join(',');

    postDescription.value.text = model.content;
    categoryId.value = model.categoryId;
    categoryName.value = model.categoryName;
    thumbnailImage.value.text = model.thumbnailImage;
    // isPremium.value = model.isPremium;
    isPremium.value = false;
    contentType.value = model.contentType;
    availabilityStatus.value = model.status == 0
        ? AvailabilityStatus.deactivated
        : AvailabilityStatus.active;

    update();
  }

  setCategory(CategoryModel category) {
    categoryId.value = category.id;
    categoryName.value = category.name;
  }

  setContentType(int type) {
    contentType.value = type;
    update();
  }

  submitBlog() async {
    if (thumbnailImageBytes == null && post.value?.thumbnailImage == null) {
      AppUtil.showToast(
          message: LocalizationString.pleaseUploadThumbnailImage,
          isSuccess: false);
      return;
    } else if (videoFileBytes == null &&
        post.value?.videoUrl == null &&
        contentType.value == 2) {
      AppUtil.showToast(
          message: LocalizationString.pleaseUploadVideo, isSuccess: false);

      return;
    } else if (postTitle.value.text.isEmpty) {
      AppUtil.showToast(
          message: LocalizationString.pleaseEnterPostTitle, isSuccess: false);

      return;
    } else if (postDescription.value.text.isEmpty) {
      AppUtil.showToast(
          message: LocalizationString.pleaseEnterPostDescription,
          isSuccess: false);

      return;
    } else if (categoryName.isEmpty) {
      AppUtil.showToast(
        message: LocalizationString.pleaseEnterCategoryName,
        isSuccess: false);

        return;
    }

    EasyLoading.show(status: LocalizationString.loading);

    var postId = post.value?.id ?? getRandString(25);
    var thumbnail = post.value?.thumbnailImage;
    var videoUrl = post.value?.videoUrl;

    if (thumbnailImageBytes != null) {
      thumbnail = await uploadImage(postId);
    } else {
      thumbnail = post.value?.thumbnailImage;
    }

    if (videoFileBytes != null) {
      videoUrl = await uploadBlogFile(postId);
    } else {
      videoUrl = post.value?.videoUrl;
    }

    getIt<FirebaseManager>()
        .insertBlogPost(
            post: post.value,
            isUpdate: post.value != null,
            postId: postId,
            postTitle: postTitle.value.text,
            content: postDescription.value.text,
            hashtags: hashtags.value.text
                .split(',')
                .map((e) => e.replaceAll('#', ''))
                .toList(),
            isPremium: isPremium.value,
            postThumbnail: thumbnail!,
            postVideoPath: videoUrl,
            categoryId: categoryId.value,
            category: categoryName.value,
            status: availabilityStatus.value)
        .then((response) {
      EasyLoading.dismiss();
      if (response.status == true) {
        thumbnailImageBytes = null;
        videoFileBytes = null;

        thumbnailImage.value.text = '';
        postFile.value.text = '';
        categoryName.value = '';
        postTitle.value.text = '';
        postDescription.value.text = '';
        hashtags.value.text = '';
        categoryId.value = '';

        AppUtil.showToast(
            message: post.value == null
                ? LocalizationString.blogAdded
                : LocalizationString.blogUpdated,
            isSuccess: true);
      } else {
        AppUtil.showToast(message: response.message ?? '', isSuccess: false);
      }
    });
  }

  Future<String> uploadImage(String blogId) async {
    String songCoverPath = '';
    await getIt<FirebaseManager>()
        .uploadBlogImage(
            uniqueId: blogId,
            bytes: thumbnailImageBytes!,
            fileName: thumbnailImage.value.text)
        .then((imagePath) {
      songCoverPath = imagePath;
    });

    return songCoverPath;
  }

  Future<String> uploadBlogFile(String postId) async {
    String songFilePath = '';

    await getIt<FirebaseManager>()
        .uploadBlogVideo(
            uniqueId: postId,
            bytes: videoFileBytes!,
            fileName: postFile.value.text)
        .then((filePath) {
      songFilePath = filePath;
    });
    return songFilePath;
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'mov'],
    );

    if (result != null) {
      PlatformFile pFile = result.files.first;

      videoFileBytes = pFile.bytes!;
      postFile.value.text = pFile.name;

      update();
    } else {
      // User canceled the picker
    }
  }

  pickThumbnailImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );

    if (result != null) {
      PlatformFile pFile = result.files.first;

      thumbnailImageBytes = pFile.bytes!;
      thumbnailImage.value.text = pFile.name;

      update();
    } else {
      // User canceled the picker
    }
  }
}
