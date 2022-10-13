import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  MyAccountState createState() => MyAccountState();
}

class MyAccountState extends State<MyAccount> {
  bool isManualLogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var providerData = FirebaseAuth.instance.currentUser!.providerData;
    if (providerData.isNotEmpty) {
      if (providerData.first.providerId == 'password') {
        isManualLogin = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: BackNavigationBar(
          centerTitle: true,
          title: LocalizationString.account,
          backTapHandler: () {
            Get.back();
          },
        ),
        body: ListView.separated(
                padding: const EdgeInsets.only(top: 20),
                itemBuilder: (ctx, index) {
                  if (index == 0) {
                    return updateProfileTile();
                  } else if (index == 1) {
                    return changePasswordTile();
                  }
                  return updateProfileTile();
                },
                separatorBuilder: (ctx, index) {
                  return Container(
                    color: Theme.of(context).dividerColor,
                    height: 0.2,
                    width: double.infinity,
                  ).vP16;
                },
                itemCount: isManualLogin ? 2 : 1)
            .hP16);
  }

  Widget updateProfileTile() {
    return SizedBox(
      height: 35,
      child: Text(
        LocalizationString.updateProfile,
        style: Theme.of(context).textTheme.titleLarge,
      ).ripple(() {
        Get.to(() => const UpdateProfile());
      }),
    );
  }

  Widget changePasswordTile() {
    return SizedBox(
      height: 35,
      child: Text(
        LocalizationString.changePwd,
        style: Theme.of(context).textTheme.titleMedium,
      ).ripple(() {
        Get.to(() => const ChangePassword());
      }),
    );
  }

  Widget appBar() {
    return Text(
      LocalizationString.account,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}
