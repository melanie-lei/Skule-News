import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class MiscMenus extends StatefulWidget {
  const MiscMenus({Key? key}) : super(key: key);

  @override
  MiscMenusState createState() => MiscMenusState();
}

class MiscMenusState extends State<MiscMenus> {
  final MyAccountController myAccountController = Get.find();
  final SubscriptionPackageController subscriptionPackageController =
      Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    myAccountController.setCurrentMode();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyAccountController>(
        init: myAccountController,
        builder: (ctx) {
          return Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 5,
                              height: 25,
                              color: Theme.of(context).primaryColor.darken(),
                            ).round(10),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              LocalizationString.account,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(fontWeight: FontWeight.w900),
                            ),
                            const Spacer(),
                            getIt<UserProfileManager>().isLogin() == false
                                ? loginTile()
                                : logoutTile()
                          ],
                        ).p16,
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                            padding: const EdgeInsets.only(top: 20),
                            itemBuilder: (ctx, index) {
                              if (getIt<UserProfileManager>().isLogin()) {
                                if (index == 0) {
                                  return accountTile();
                                } else if (index == 1) {
                                  return followingTile();
                                } else if (index == 2) {
                                  return bookmarksTile();
                                } else if (index == 3) {
                                  return subscriptionTile();
                                } else if (index == 4) {
                                  return chooseYourInterestTile();
                                } else if (index == 5) {
                                  return contactusTile();
                                } else if (index == 6) {
                                  return privacyPolicyTile();
                                } else if (index == 7) {
                                  return termsOfUseTile();
                                }
                                // else if (index == 8) {
                                //   return darkModeTile();
                                // }
                                return Container();
                              } else {
                                if (index == 0) {
                                  return contactusTile();
                                } else if (index == 1) {
                                  return privacyPolicyTile();
                                } else if (index == 2) {
                                  return termsOfUseTile();
                                }
                                // else if (index == 3) {
                                //   return darkModeTile();
                                // }
                                return Container();
                              }
                            },
                            separatorBuilder: (ctx, index) {
                              return Container(
                                color: Theme.of(context).dividerColor,
                                height: 0.2,
                                width: double.infinity,
                              ).vP16;
                            },
                            itemCount:
                                getIt<UserProfileManager>().isLogin() ? 9 : 4)
                        .hP16,
                  ),
                ],
              ));
        });
  }

  Widget accountTile() {
    return SizedBox(
      height: 35,
      child: Text(
        '${LocalizationString.account} : ${getIt<UserProfileManager>().user!.infoToShow}',
        style: Theme.of(context).textTheme.titleLarge,
      ).ripple(() {
        Get.to(() => const MyAccount());
      }),
    );
  }

  Widget followingTile() {
    return SizedBox(
      height: 35,
      child: Text(
        LocalizationString.following,
        style: Theme.of(context).textTheme.titleMedium,
      ).ripple(() {
        Get.to(() => const Following());
      }),
    );
  }

  Widget bookmarksTile() {
    return SizedBox(
        height: 35,
        child: Text(
          LocalizationString.bookmarked,
          style: Theme.of(context).textTheme.titleMedium,
        )).ripple(() {
      Get.to(() => const Saved());
    });
  }

  Widget subscriptionTile() {
    return GetBuilder<MyAccountController>(
        init: myAccountController,
        builder: (ctx) {
          return SizedBox(
            height: 45,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocalizationString.goPremium,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  getIt<UserProfileManager>().user!.isPro
                      ? LocalizationString.alreadyProUser
                      : LocalizationString.becomePremium,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          );
        }).ripple(() {
      Get.to(() => const Subscription());
    });
  }

  Widget chooseYourInterestTile() {
    return SizedBox(
      height: 35,
      child: Text(
        LocalizationString.chooseYourInterest,
        style: Theme.of(context).textTheme.titleMedium,
      ).ripple(() {
        Get.to(() => const ChooseCategories());
      }),
    );
  }

  Widget contactusTile() {
    return SizedBox(
        height: 35,
        child: Text(
          LocalizationString.contactUs,
          style: Theme.of(context).textTheme.titleMedium,
        )).ripple(() {
      Get.to(() => const ContactUs());
    });
  }

  Widget privacyPolicyTile() {
    return SizedBox(
        height: 35,
        child: Text(
          LocalizationString.privacyPolicy,
          style: Theme.of(context).textTheme.titleMedium,
        )).ripple(() {
      Get.to(() => const PrivacyPolicy());
    });
  }

  Widget termsOfUseTile() {
    return SizedBox(
        height: 35,
        child: Text(
          LocalizationString.termsOfUse,
          style: Theme.of(context).textTheme.titleMedium,
        )).ripple(() {
      Get.to(() => const TermsOfUse());
    });
  }
  //
  // Widget darkModeTile() {
  //   return SizedBox(
  //       height: 35,
  //       child: Row(
  //         children: [
  //           Text(
  //             LocalizationString.darkMode,
  //             style: Theme.of(context).textTheme.titleMedium,
  //           ),
  //           const Spacer(),
  //           Obx(() => Switch(
  //               value: myAccountController.darkMode.value,
  //               onChanged: (value) {
  //                 myAccountController.setDarkMode(value);
  //               }))
  //         ],
  //       ));
  // }

  Widget loginTile() {
    return Text(
      LocalizationString.login,
      style: Theme.of(context).textTheme.titleSmall,
    )
        .setPadding(left: 16, right: 16, top: 4, bottom: 4)
        .borderWithRadius(value: 0.5, radius: 5, context: context)
        .ripple(() {
      getIt<FirebaseManager>().logout();
      Get.to(() => const AskForLogin());
    });
  }

  Widget logoutTile() {
    return Text(
      LocalizationString.logout,
      style: Theme.of(context).textTheme.titleSmall,
    )
        .setPadding(left: 16, right: 16, top: 4, bottom: 4)
        .borderWithRadius(value: 0.5, radius: 5, context: context)
        .ripple(() {
      getIt<UserProfileManager>().logout();
      Get.to(() => const AskForLogin());
    });
  }

  Widget appBar() {
    return Text(
      LocalizationString.account,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}
