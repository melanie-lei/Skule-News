import 'package:timeago/timeago.dart' as timeago;

class BlogPostModel {
  String id;
  String title;
  // String shortContent;
  List<String> hashtags;

  String content;
  String thumbnailImage;
  String? videoUrl;

  String authorId;
  String authorName;

  DateTime createdAt;
  String authorPicture;
  String categoryName;
  String categoryId;
  // String locationId;

  int totalLikes;
  int totalComments;
  int totalSaved;
  int contentType;
  bool isPremium;
  bool isFeatured;

  int status;

  BlogPostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.thumbnailImage,
    this.videoUrl,
    required this.createdAt,
    // required this.shortContent,
    required this.hashtags,
    required this.authorId,
    required this.authorName,
    required this.authorPicture,
    required this.categoryName,
    required this.categoryId,
    // required this.locationId,
    required this.totalLikes,
    required this.totalComments,
    required this.totalSaved,
    required this.contentType,
    required this.isPremium,
    required this.isFeatured,

    required this.status,
  });

  factory BlogPostModel.fromJson(Map<String, dynamic> json) => BlogPostModel(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        thumbnailImage: json["thumbnailImage"],
        videoUrl: json["videoUrl"],
        // shortContent: json["shortContent"],
        hashtags: (json['hashtags'] as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
        authorId: json["authorId"],
        authorName: json["authorName"],
        authorPicture: json["authorPicture"],
        totalLikes: json["totalLikes"],
        totalSaved: json["totalSaved"],
        totalComments: json["totalComments"],
        categoryName: json["category"],
        categoryId: json["categoryId"],
        // locationId: json["locationId"],
        createdAt: json["createdAt"] == null
            ? DateTime.now()
            : json["createdAt"].toDate(),
        contentType: json["contentType"],
        isPremium: json["isPremium"] ?? false,
    isFeatured: json["featured"] ?? false,
    status: json["status"],
      );

  String get date {
    return timeago.format(createdAt);
  }

  bool isVideoBlog() {
    return contentType == 2;
  }
}
