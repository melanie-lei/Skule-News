import 'package:flutter/material.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;
  final VoidCallback? handler;

  const CommentsScreen({Key? key, required this.postId, this.handler})
      : super(key: key);

  @override
  CommentsScreenState createState() => CommentsScreenState();
}

class CommentsScreenState extends State<CommentsScreen> {
  TextEditingController textEditingController = TextEditingController();
  final ScrollController _controller = ScrollController();
  final CommentsController commentsController = Get.find();

  @override
  void initState() {
    super.initState();
    commentsController.getComments(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: BackNavigationBar(
          title: LocalizationString.back,
        ),
        body: Column(
          children: <Widget>[
            TitleBar(title: LocalizationString.comments)
                .setPadding(top: 25, left: 25, right: 25),
            Flexible(
                child: GetBuilder<CommentsController>(
                    init: commentsController,
                    builder: (ctx) {
                      return ListView.builder(
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 50, left: 25, right: 25),
                          itemCount: commentsController.comments.length,
                          // reverse: true,
                          controller: _controller,
                          itemBuilder: (context, index) {
                            return CommentCard(
                                model: commentsController.comments[index]);
                          });
                    })),
            buildMessageTextField().hP25,
            const SizedBox(
              height: 20,
            )
          ],
        ));
  }

  Widget buildMessageTextField() {
    return Container(
      height: 50.0,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: LocalizationString.writeComment,
                hintStyle: Theme.of(context).textTheme.titleSmall,
              ),
              textInputAction: TextInputAction.send,
              style: Theme.of(context).textTheme.titleSmall,
              onSubmitted: (_) {
                addNewComment();
              },
              onTap: () {
                Timer(
                    const Duration(milliseconds: 300),
                    () => _controller
                        .jumpTo(_controller.position.maxScrollExtent));
              },
            ).hP8,
          ).borderWithRadius(value: 0.5, radius: 25, context: context)),
          SizedBox(
            width: 50.0,
            child: InkWell(
              onTap: addNewComment,
              child: Icon(
                Icons.send,
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  void addNewComment() {
    if (textEditingController.text.trim().isNotEmpty) {
      commentsController.postCommentsApiCall(
          commentText: textEditingController.text.trim(),
          postId: widget.postId);
      textEditingController.text = '';
      // widget.model?.totalComment = comments.length;

      Timer(const Duration(milliseconds: 500),
          () => _controller.jumpTo(_controller.position.maxScrollExtent));
    }
  }
}
