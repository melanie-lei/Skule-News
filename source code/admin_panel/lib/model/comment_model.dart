import 'package:timeago/timeago.dart' as timeago;

class CommentModel {
  String id;
  String postId;

  String userId;
  String userName;
  String userPicture;

  DateTime createdAt;
  String comment;
  int status;

  CommentModel({
    required this.id,
    required this.postId,
    required this.comment,
    required this.createdAt,
    required this.userId,
    required this.userName,
    required this.userPicture,
    required this.status,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json["id"],
        postId: json["postId"],
        status: json["status"],
        comment: json["comment"],
        createdAt: json["createdAt"]?.toDate() ?? DateTime.now(),
        userId: json["userId"],
        userPicture: json["userPicture"],
        userName: json["userName"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'postId': postId,
        'status': status,
        'comment': comment,
        'userId': userId,
        'userPicture': userPicture,
        'userName': userName,
        'createdAt': createdAt,
      };

  String get date {
    return timeago.format(createdAt);
  }
}
