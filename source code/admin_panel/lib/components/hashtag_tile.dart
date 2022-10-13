import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';

class HashtagTile extends StatelessWidget {
  final Hashtag model;
  final VoidCallback actionCallback;
  const HashtagTile({Key? key, required this.model, required this.actionCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      height: 70,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: model.image,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
            const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            height: 50,
            width: 50,
          ).round(10)
          //     .ripple(() {
          //   Get.to(() => NewsSourceDetail(userId: model.id));
          // })
          ,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                model.name,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                '${model.totalFollowers} ${LocalizationString.followers.toLowerCase()}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ).lP8,
          const Spacer(),
        ],
      ),
    );
  }
}
