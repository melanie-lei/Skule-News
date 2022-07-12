import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get/get.dart';

class ProfileTile extends StatelessWidget {
  final UserModel model;
  final VoidCallback actionCallback;
  const ProfileTile({Key? key, required this.model, required this.actionCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      height: 70,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: model.image!,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
            const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            height: 50,
            width: 50,
          ).round(10).ripple(() {
            Get.to(() => NewsSourceDetail(userId: model.id));
          }),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                model.name!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                '${model.totalFollowers} ${LocalizationString.followers.toLowerCase()}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ).lP8,
          const Spacer(),
          SizedBox(
            height: 30,
            width: 100,
            child: BorderButtonType1(
              cornerRadius: 5,
              text: model.isFollowing()
                  ? LocalizationString.following
                  : LocalizationString.follow,
              textStyle: Theme.of(context).textTheme.subtitle1,
              backgroundColor: model.isFollowing()
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).backgroundColor,
              onPress: () {
                actionCallback();
              },
            ),
          ).tP4
        ],
      ),
    );
  }
}
