import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:flutter/material.dart';

class AuthorTile extends StatelessWidget {
  final AuthorsModel model;
  final VoidCallback deleteHandler;
  final VoidCallback reactivateHandler;
  final VoidCallback? convertHandler;

  const AuthorTile(
      {Key? key,
      required this.model,
      required this.deleteHandler,
      required this.reactivateHandler,
      this.convertHandler})
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
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.w900),
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
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      color: Theme.of(context).primaryColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            LocalizationString.convertToUser,
                            style: AppTheme.configTheme.textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ).hP16,
                    ).round(8).ripple(() {
                      convertHandler!();
                    }),
                    const SizedBox(
                      width: 15,
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      color: Theme.of(context).primaryColor,
                      child: const ThemeIconWidget(
                        ThemeIcon.delete,
                        color: Colors.white,
                        size: 20,
                      ),
                    ).round(8).ripple(() {
                      deleteHandler();
                    })
                  ],
                )
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
                            Text(
                              LocalizationString.reactivateAuthor,
                              style: AppTheme.configTheme.textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          ]).hP16)
                  .round(8)
                  .ripple(() {
                  reactivateHandler();
                })
        ],
      ).p16,
    ).round(10);
  }
}
