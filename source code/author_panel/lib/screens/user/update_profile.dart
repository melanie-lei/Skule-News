import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';
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
          Center(
              child: GetBuilder<UserController>(
                  init: userController,
                  builder: (ctx) {
                    return Stack(
                      children: [
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: userController.coverImagePath.value,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.black12,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ).round(18).p(2),
                        ),
                        Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.black38,
                            )),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Text(
                              LocalizationString.updateCoverImage,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    )
                        .borderWithRadius(
                            value: 2,
                            radius: 20,
                            color: Theme.of(context).primaryColor,
                            context: context)
                        .ripple(() {
                      userController.uploadCoverImage();
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
          const SizedBox(height: 20),
          Obx(() => InputField(
                controller: userController.bioTf.value,
                // showDivider: true,
                hintText: LocalizationString.bio,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
              )),
          const SizedBox(height: 20),
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
