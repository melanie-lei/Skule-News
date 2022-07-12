import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';

class AddCategoryController extends GetxController {
  Rx<TextEditingController> name = TextEditingController().obs;
  Rx<TextEditingController> categoryCover = TextEditingController().obs;

  Uint8List? fileBytes;
  String? selectedFilePath;

  CategoryModel? category;
  Rx<AvailabilityStatus> availabilityStatus = AvailabilityStatus.active.obs;

  setAvailabilityStatus(AvailabilityStatus status) {
    availabilityStatus.value = status;
    update();
  }

  setCategory(CategoryModel? category) {
    this.category = category;

    categoryCover.value.text = category?.image ?? '';
    name.value.text = category?.name ?? '';
    availabilityStatus.value = category?.status == 1
        ? AvailabilityStatus.active
        : AvailabilityStatus.deactivated;

    update();
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );

    if (result != null) {
      PlatformFile pFile = result.files.first;

      fileBytes = pFile.bytes!;
      categoryCover.value.text = pFile.name;

      update();
    } else {
      // User canceled the picker
    }
  }

  Future<String> uploadImage(String categoryId) async {
    String coverPath = '';
    await getIt<FirebaseManager>()
        .uploadCategoryImage(
            uniqueId: categoryId,
            bytes: fileBytes!,
            fileName: categoryCover.value.text)
        .then((imagePath) {
      coverPath = imagePath;
    });

    return coverPath;
  }

  addCategory() async {
    if (fileBytes == null && category?.image == null) {
      AppUtil.showToast(
          message: LocalizationString.pleaseUploadImage, isSuccess: false);
      return;
    } else if (name.value.text.isEmpty) {
      AppUtil.showToast(
          message: LocalizationString.pleaseEnterCategoryName,
          isSuccess: false);
      return;
    }

    EasyLoading.show(status: LocalizationString.loading);

    var categoryId = category?.id ?? getRandString(25);
    var coverPath = category?.image ?? '';

    if (fileBytes != null) {
      coverPath = await uploadImage(categoryId);
    } else {
      coverPath = category?.image ?? '';
    }

    getIt<FirebaseManager>()
        .insertNewCategory(
            category: category,
            id: categoryId,
            name: name.value.text,
            image: coverPath,
            status: availabilityStatus.value)
        .then((response) {
      EasyLoading.dismiss();
      if (response.status == true) {
        name.value.text = '';
        categoryCover.value.text = '';
        fileBytes = null;

        AppUtil.showToast(
            message: category == null
                ? LocalizationString.categoryAdded
                : LocalizationString.categoryUpdated,
            isSuccess: true);
      } else {
        AppUtil.showToast(message: response.message!, isSuccess: false);
      }
    });
  }
}
