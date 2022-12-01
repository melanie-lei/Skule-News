import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final UserModel model;
  final VoidCallback deleteHandler;
  final VoidCallback reactivateHandler;
  final VoidCallback? convertHandler;

  const UserTile(
    {Key? key, required this.model, required this.deleteHandler, 
    required this.reactivateHandler, this.convertHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor.darken(0.1),
      child: Row(
        children: [
          UserAvatarView(
            user: model,
            size: 50,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.infoToShow,
                style: Theme.of(context).textTheme.titleSmall,
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
              // active user
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    color: Theme.of(context).primaryColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(LocalizationString.convertToAuthor,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: Colors.white),
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
              // de-activated user
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
                  reactivateHandler();
                })
        ],
      ).p16,
    ).round(10);
  }
}
