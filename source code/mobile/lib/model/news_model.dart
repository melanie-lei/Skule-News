import 'package:music_streaming_mobile/helper/common_import.dart';
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
  String category;
  String categoryId;
  // String locationId;

  int totalLikes;
  int totalComments;
  int totalSaved;
  int contentType;
  bool? isPremium;

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
    required this.category,
    required this.categoryId,
    // required this.locationId,
    required this.totalLikes,
    required this.totalComments,
    required this.totalSaved,
    required this.contentType,
    this.isPremium,
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
    // authorUserName: json["authorUserName"],
    // authorEmail: json["authorEmail"],
    authorPicture: json["authorPicture"],
    // authorPhone: json["authorPhone"],
    totalLikes: json["totalLikes"],
    totalSaved: json["totalSaved"],
    totalComments: json["totalComments"],
    category: json["category"],
    categoryId: json["categoryId"],
    // locationId: json["locationId"],
    createdAt: json["createdAt"] == null
        ? DateTime.now()
        : json["createdAt"].toDate(),
    contentType: json["contentType"],
    isPremium: json["isPremium"] ?? false,
  );

  String get date {
    return timeago.format(createdAt);
  }

  bool isLiked() {
    if (getIt<UserProfileManager>().user != null) {
      return getIt<UserProfileManager>().user!.likedPost.contains(id) == true;
    }
    return false;
  }

  bool isSaved() {
    if (getIt<UserProfileManager>().user != null) {
      return getIt<UserProfileManager>().user!.savedPost.contains(id) == true;
    }
    return false;
  }

  bool isVideoNews() {
    return contentType == 2;
  }

  bool get isLocked {
    if (isPremium == true) {
      DateTime? subscriptionDate =
          getIt<UserProfileManager>().user!.subscriptionDate;
      if (subscriptionDate != null) {
        DateTime todayDate = getIt<UserProfileManager>().user!.todayDate;
        int daysConsumed = todayDate.difference(subscriptionDate).inDays;
        int noOfDaysInSubscription =
            getIt<UserProfileManager>().user!.subscriptionDays;
        if (noOfDaysInSubscription > daysConsumed) {
          return false;
        } else {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return false;
    }
  }
}
