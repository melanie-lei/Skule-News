import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final UserModel model;
  final VoidCallback deleteHandler;

  const UserTile({Key? key, required this.model, required this.deleteHandler})
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
                  deleteHandler();
                })
              : Container()
        ],
      ).p16,
    ).round(10);
  }
}
