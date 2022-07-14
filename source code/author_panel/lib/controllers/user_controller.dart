import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';

class UserController extends GetxController {
  Rx<TextEditingController> nameTf = TextEditingController().obs;
  Rx<TextEditingController> bioTf = TextEditingController().obs;

  Uint8List? thumbnailImageBytes;
  RxString imagePath = ''.obs;

  setProfileData() {
    nameTf.value.text = getIt<UserProfileManager>().user!.name;
    bioTf.value.text = getIt<UserProfileManager>().user!.bio ?? '';
    imagePath.value = getIt<UserProfileManager>().user!.image;
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

    getIt<FirebaseManager>()
        .updateUser(name: nameTf.value.text, bio: bioTf.value.text,image: imagePath.value)
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
              uniqueId: getIt<UserProfileManager>().user!.id,
              bytes: thumbnailImageBytes!,
              fileName: getIt<UserProfileManager>().user!.name)
          .then((value) {
        EasyLoading.dismiss();
        imagePath.value = value;
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
