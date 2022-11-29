import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:flutter/material.dart';

class AuthorTile extends StatelessWidget {
  final AuthorsModel model;
  final VoidCallback? deleteHandler;
  final VoidCallback? reactivateHandler;

  const AuthorTile({Key? key, required this.model, this.deleteHandler, this.reactivateHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Theme.of(context).backgroundColor.darken(0.1),
      child: Row(
        children: [
          AvatarView(
            url: model.image,
            size: 50,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                model.name,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                '${LocalizationString.addedOn} ${model.addedOn}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const Spacer(),
          model.status == 1 
              ? Container(
                  height: 40,
                  width: 40,
                  color: Theme.of(context).primaryColor,
                  child: const ThemeIconWidget(
                    ThemeIcon.delete,
                    size: 20,
                    color: Colors.white,
                  ),
              ).round(8).ripple(() {
                  deleteHandler!();
              }) 
              : Container(
                  height: 40,
                  color: Theme.of(context).primaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ThemeIconWidget(
                        ThemeIcon.add,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(LocalizationString.reactivateUser,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ]
                  ).hP16
                ).round(8).ripple(() {
                  reactivateHandler!();
                })
        ],
      ).p16,
    ).round(10);
  }
}
