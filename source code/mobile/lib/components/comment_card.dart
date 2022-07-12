import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class CommentCard extends StatefulWidget {
  final CommentModel model;

  const CommentCard({Key? key, required this.model}) : super(key: key);

  @override
  CommentCardState createState() => CommentCardState();
}

class CommentCardState extends State<CommentCard> {
  late final CommentModel model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
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
                  child: InkWell(
                      onTap: () {
                        // Get.to(() => OtherUserProfile(userId: model.userId));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AvatarView(url: model.userPicture, size: 35),
                          const SizedBox(width: 10),
                          Flexible(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                model.userName,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                model.comment,
                                style: Theme.of(context).textTheme.bodyMedium,
                              )
                            ],
                          ))
                        ],
                      ))),
              Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(model.date,
                      style: Theme.of(context).textTheme.bodyMedium))
            ]));
  }
}
