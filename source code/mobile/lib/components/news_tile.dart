import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class NewsTile extends StatelessWidget {
  final NewsModel model;
  final VoidCallback? onDelete;

  const NewsTile({Key? key, required this.model, this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).dividerColor.withOpacity(0.1),
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: model.coverImage,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                height: 120,
                width: 120,
              ),
              Positioned(
                  left: 8,
                  right: 8,
                  bottom: 5,
                  child: Container(
                      color: Theme.of(context).primaryColor,
                      child: Center(
                        child: Text(model.category.toUpperCase(),
                                style: Theme.of(context).textTheme.bodyMedium)
                            .p8,
                      )).round(5))
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(model.title.toUpperCase(),
                        maxLines: 1, style: Theme.of(context).textTheme.bodySmall)
                    .vP8,
                Text(model.shortContent,
                        maxLines: 2, style: Theme.of(context).textTheme.titleSmall)
                    .vP4,
                const Spacer(),
                Row(
                  children: [
                    Row(
                      children: [
                        AvatarView(
                          url: model.authorPicture,
                          size: 25,
                        ),
                        Text(model.authorName,
                                style: Theme.of(context).textTheme.bodyLarge)
                            .hP8,
                      ],
                    ),
                    const Spacer(),
                    Text(model.date, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ).vP8
              ],
            ).hP16,
          )
        ],
      ),
    ).round(10);
  }
}
