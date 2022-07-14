import 'package:flutter/material.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final UserController userController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userController.setProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TitleBar(title: LocalizationString.updateProfile),
          const SizedBox(
            height: 20,
          ),
          Center(
              child: GetBuilder<UserController>(
                  init: userController,
                  builder: (context) {
                    return AvatarView(
                        size: 100, url: userController.imagePath.value)
                        .ripple(() {
                      userController.uploadProfileImage();
                    });
                  })),
          const SizedBox(
            height: 20,
          ),
          Obx(() => InputField(
            controller: userController.nameTf.value,
            // showDivider: true,
            hintText: LocalizationString.name,
          )),
          const SizedBox(
            height: 10,
          ),
          Obx(() => InputField(
            controller: userController.bioTf.value,
            // showDivider: true,
            hintText: LocalizationString.bio,
            maxLines: 5,
          )),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 50,
            width: 200,
            child: BorderButtonType1(
              text: LocalizationString.update,
              textStyle: Theme.of(context).textTheme.titleMedium,
              cornerRadius: 10,
              onPress: () {
                userController.updateUser(onlyUploadingProfileImage: false);
              },
            ),
          )
        ],
      ).p25,
    );
  }
}
