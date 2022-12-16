import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';

class CommentCard extends StatefulWidget {
  final CommentModel model;
  final VoidCallback deleteHandler;

  const CommentCard(
      {Key? key, required this.model, required this.deleteHandler})
      : super(key: key);

  @override
  CommentCardState createState() => CommentCardState();
}

class CommentCardState extends State<CommentCard> {
  late final CommentModel model;
  late final VoidCallback deleteHandler;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    deleteHandler = widget.deleteHandler;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AvatarView(url: model.userPicture, size: 50),
                  const SizedBox(width: 10),
                  Flexible(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            model.userName,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(model.date,
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(width: 10),
                          model.status == 0
                              ? Text(LocalizationString.deleted,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontStyle: FontStyle.italic))
                              : Container()
                        ],
                      ),
                      Text(
                        model.comment,
                        style: Theme.of(context).textTheme.titleSmall,
                      )
                    ],
                  )),
                  model.status == 1
                      ? SizedBox(
                          width: 80,
                          height: 40,
                          child: FilledButtonType1(
                            text: 'Delete',
                            enabledBackgroundColor:
                                Theme.of(context).primaryColor,
                            onPress: deleteHandler,
                          ))
                      : FilledButtonType1(
                          text: 'Restore',
                          enabledBackgroundColor:
                              Theme.of(context).primaryColor,
                          onPress: deleteHandler,
                        )
                ],
              )),
            ]));
  }
}
