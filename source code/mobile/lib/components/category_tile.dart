import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:music_streaming_mobile/helper/int_extension.dart';

class CategoryTile extends StatelessWidget {
  final CategoryModel category;
  final bool isLargeText;

  const CategoryTile(
      {Key? key, required this.category, required this.isLargeText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black12,
          child: category.image != null
              ? CachedNetworkImage(
                  imageUrl: category.image!,
                  fit: BoxFit.cover,
                  // placeholder: (context, url) =>
                  //     const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  width: double.infinity,
                  height: double.infinity,
                )
              : Container(),
        ).round(5),
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          bottom: 0,
          child: Container(
            color: Colors.black38,
          ).round(5),
        ),
        Positioned(
          left: 10,
          right: 10,
          bottom: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.name,
                style: isLargeText
                    ? Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600)
                    : Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600),
              ),
              category.totalBlogPosts > 0
                  ? Text(
                      '${category.totalBlogPosts.formatNumber} ${LocalizationString.blogs}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white),
                    )
                  : Container(),
            ],
          ),
        )
      ],
    );
  }
}
