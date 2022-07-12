import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class UserDetail extends StatefulWidget {
  final String userId;

  const UserDetail({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  final UserController userController = Get.find();
  final PostCardController postCardController = Get.find();

  @override
  void initState() {
    // TODO: implement initState

    userController.loadPosts(reporterId: widget.userId);
    userController.getReporterDetail(id: widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: [
          GetBuilder<UserController>(
              init: userController,
              builder: (context) {
                return BackNavBar(
                  title: userController.reporter.value?.name ?? '',
                  // centerTitle: true,
                  backTapHandler: () {
                    Get.back();
                  },
                );
              }),
          GetBuilder<UserController>(
              init: userController,
              builder: (context) {
                return creatorInfo().p16;
              }),
          divider(context: context).vP8,
          Expanded(
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: loadView()),
          )
        ],
      ),
    );
  }

  Widget loadView() {
    return GetBuilder<UserController>(
        init: userController,
        builder: (context) {
          return ListView.separated(
              padding: const EdgeInsets.only(top: 20),
              itemBuilder: (BuildContext context, index) {
                return GetBuilder<PostCardController>(
                    init: postCardController,
                    builder: (ctx) {
                      return PostTile(
                        model: userController.posts[index],
                      );
                    });
              },
              separatorBuilder: (BuildContext context, index) {
                return const SizedBox(
                  height: 40,
                );
              },
              itemCount: userController.posts.length);
        });
  }

  Widget creatorInfo() {
    return userController.isLoading == true
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              userController.reporter.value!.image != null
                  ?
              CachedNetworkImage(
                imageUrl: userController.reporter.value!.image!,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                height: 80,
                width: 80,
              ).circular
                  : Image.asset(
                      'assets/common/profile.png',
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(userController.reporter.value!.name!,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      userController.reporter.value!.totalPosts > 0
                          ? Text('${userController.reporter.value!.totalPosts} ${LocalizationString.posts},',
                                  style: Theme.of(context).textTheme.bodySmall)
                              .rP8
                          : Container(),
                      userController.reporter.value!.totalFollowers > 0
                          ? Text('${userController.reporter.value!.totalFollowers} ${LocalizationString.followers},',
                                  style: Theme.of(context).textTheme.bodySmall)
                              .rP8
                          : Container(),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 40,
                width: 120,
                child: Obx(() => BorderButtonType1(
                    text: userController.reporter.value!.isFollowing()
                        ? LocalizationString.following
                        : LocalizationString.follow,
                    backgroundColor:
                        userController.reporter.value!.isFollowing()
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).backgroundColor,
                    textStyle: userController.reporter.value!.isFollowing()
                        ? Theme.of(context).textTheme.bodyMedium
                        : Theme.of(context).textTheme.bodyMedium,
                    onPress: () {
                      userController.followUnfollowUser();
                    })),
              )
            ],
          );
  }
}
