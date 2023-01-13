import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:csv/csv.dart';
import 'dart:convert';

class AddUsersController extends GetxController {
  Rx<TextEditingController> usersFileName = TextEditingController().obs;
  Rx<TextEditingController> newAdminEmail = TextEditingController().obs;
  Rx<TextEditingController> newAdminPassword = TextEditingController().obs;

  List<List<dynamic>>? usersList;

  addAdmin() async {
    getIt<FirebaseManager>()
        .addAdmin(newAdminEmail.value.text, newAdminPassword.value.text);
  }

  pickUsersFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile pFile = result.files.first;
      String fileAsString = utf8.decode(pFile.bytes!.toList());

      usersList = const CsvToListConverter().convert(fileAsString);
      usersFileName.value.text = pFile.name;

      update();
    }
  }

  submit() async {
    if (usersList == null) {
      AppUtil.showToast(
          message: LocalizationString.pleaseUploadUsers, isSuccess: false);
      return;
    }

    EasyLoading.show(status: LocalizationString.loading);

    getIt<FirebaseManager>().addUsers(usersList!).then((response) {
      EasyLoading.dismiss();
      if (response.status == true) {
        // Reset all user list values.
        usersList = null;
        usersFileName.value.text = '';

        AppUtil.showToast(
            message: LocalizationString.usersAdded, isSuccess: true);
      } else {
        AppUtil.showToast(
            message: response.message ?? 'Bad Response', isSuccess: false);
      }
    });
  }
}
