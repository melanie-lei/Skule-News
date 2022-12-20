import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';

class CategoryTile extends StatelessWidget {
  final CategoryModel category;

  const CategoryTile({Key? key, required this.category}) : super(key: key);

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
          child: Text(
            category.name,
            style: AppTheme.configTheme.textTheme.bodyLarge,
          ),
        )
      ],
    );
  }
}

class CategoryHorizontalTile extends StatelessWidget {
  final CategoryModel genre;

  const CategoryHorizontalTile({Key? key, required this.genre})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.network(
          genre.image!,
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ).circular,
        const SizedBox(width: 10),
        Text(genre.name, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
