import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:skule_news_mobile/helper/int_extension.dart';

class HashtagTile extends StatelessWidget {
  final Hashtag model;
  final VoidCallback actionCallback;

  const HashtagTile(
      {Key? key, required this.model, required this.actionCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      height: 70,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '#${model.name}',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${model.totalFollowers.formatNumber} ${LocalizationString.followers.toLowerCase()}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ).lP8,
          ),
          // const Spacer(),
          SizedBox(
            height: 30,
            width: 100,
            child: BorderButtonType1(
              cornerRadius: 5,
              text: model.isFollowing()
                  ? LocalizationString.following
                  : LocalizationString.follow,
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge,
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
