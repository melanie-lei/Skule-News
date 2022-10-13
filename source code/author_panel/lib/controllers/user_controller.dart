import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';

class UserController extends GetxController {
  Rx<TextEditingController> nameTf = TextEditingController().obs;
  Rx<TextEditingController> bioTf = TextEditingController().obs;

  Uint8List? thumbnailImageBytes;
  Uint8List? coverImageBytes;

  RxString imagePath = ''.obs;
  RxString coverImagePath = ''.obs;

  setProfileData() {
    nameTf.value.text = getIt<UserProfileManager>().user!.name;
    bioTf.value.text = getIt<UserProfileManager>().user!.bio ?? '';
    imagePath.value = getIt<UserProfileManager>().user!.image;
    coverImagePath.value = getIt<UserProfileManager>().user!.coverImage;

    update();
  }

  updateUser({required bool onlyUploadingProfileImage}) {
    if (nameTf.value.text.isEmpty && onlyUploadingProfileImage == false) {
      showMessage(LocalizationString.pleaseEnterName, true);
      return;
    }

    EasyLoading.show(status: LocalizationString.loading);
    getIt<UserProfileManager>().user!.name = nameTf.value.text;
    getIt<UserProfileManager>().user!.bio = bioTf.value.text;
    getIt<UserProfileManager>().user!.image = imagePath.value;
    getIt<UserProfileManager>().user!.coverImage = coverImagePath.value;

    getIt<FirebaseManager>()
        .updateUser(
            name: nameTf.value.text,
            bio: bioTf.value.text,
            image: imagePath.value,
            coverImage: coverImagePath.value)
        .then((value) {
      EasyLoading.dismiss();
      showMessage(LocalizationString.profileUpdated, false);
      update();
    });
  }

  uploadProfileImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );

    if (result != null) {
      PlatformFile pFile = result.files.first;

      thumbnailImageBytes = pFile.bytes!;
      EasyLoading.show(status: LocalizationString.loading);
      getIt<FirebaseManager>()
          .updateProfileImage(
              bytes: thumbnailImageBytes!,
              fileName:
                  '${getIt<UserProfileManager>().user!.name}_profileImage')
          .then((value) {
        EasyLoading.dismiss();
        imagePath.value = value;
        updateUser(onlyUploadingProfileImage: true);
      });
    } else {
      // User canceled the picker
    }
  }

  uploadCoverImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );

    if (result != null) {
      PlatformFile pFile = result.files.first;

      coverImageBytes = pFile.bytes!;
      EasyLoading.show(status: LocalizationString.loading);
      getIt<FirebaseManager>()
          .updateProfileImage(
              bytes: coverImageBytes!,
              fileName: '${getIt<UserProfileManager>().user!.name}_coverImage')
          .then((value) {
        EasyLoading.dismiss();
        coverImagePath.value = value;
        updateUser(onlyUploadingProfileImage: true);
      });
    } else {
      // User canceled the picker
    }
  }

  showMessage(String message, bool isError) {
    AppUtil.showToast(message: message, isSuccess: !isError);
  }
}
