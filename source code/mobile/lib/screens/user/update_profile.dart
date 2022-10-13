import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController nameTf = TextEditingController();
  TextEditingController bioTf = TextEditingController();

  final UserController userController = Get.find();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    nameTf.text = getIt<UserProfileManager>().user!.name ?? '';
    bioTf.text = getIt<UserProfileManager>().user!.bio ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userController.setProfileImagePath();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: BackNavigationBar(
        centerTitle: true,
        title: LocalizationString.account,
        backTapHandler: () {
          Get.back();
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
          ),
          Center(
              child: GetBuilder<UserController>(
                  init: userController,
                  builder: (context) {
                    return UserAvatarView(
                        user: getIt<UserProfileManager>().user!).ripple((){
                      userController.uploadProfileImage();
                    });
                  })),
          const SizedBox(
            height: 20,
          ),
          InputField(
            controller: nameTf,
            showDivider: true,
            hintText: LocalizationString.name,
          ),
          const SizedBox(
            height: 10,
          ),
          InputField(
            controller: bioTf,
            showDivider: true,
            hintText: LocalizationString.bio,
            maxLines: 5,
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 50,
            child: BorderButtonType1(
              text: LocalizationString.update,
              cornerRadius: 10,
              onPress: () {
                userController.updateUser(name: nameTf.text, bio: bioTf.text);
              },
            ),
          )
        ],
      ).hP16,
    );
  }
}
