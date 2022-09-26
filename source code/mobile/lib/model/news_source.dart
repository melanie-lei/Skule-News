import 'package:music_streaming_mobile/helper/common_import.dart';

class AuthorModel {
  String id;
  String name;
  String? bio;

  String image;
  String coverImage;
  int status;
  int totalPosts;
  int totalFollowers;
  DateTime createdAt;
  List<String> usedCategories;

  AuthorModel(
      {required this.id,
      required this.name,
      this.bio,
      required this.image,
      required this.coverImage,
      required this.status,
      required this.totalPosts,
      required this.totalFollowers,
      required this.createdAt,
      required this.usedCategories});

  factory AuthorModel.fromJson(Map<String, dynamic> json) => AuthorModel(
        id: json["id"],
        name: json["name"],
        bio: json["bio"] ?? '',
        image: json["image"] ?? AppConfig.dummyProfilePictureUrl,
        coverImage: json["coverImage"] ?? AppConfig.backgroundImage,
        status: json["status"],
        totalPosts: json["totalBlogPosts"] ?? 0,
        totalFollowers: json["totalFollowers"] ?? 0,
        usedCategories: (json["usedCategories"] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        createdAt: json["createdAt"] == null
            ? DateTime.now()
            : json["createdAt"].toDate(),
      );

  String get addedOn {
    return DateFormat('yyyy-MM-dd – kk:mm').format(createdAt);
  }

  isFollowing() {
    if (getIt<UserProfileManager>().user == null) {
      return false;
    }
    return getIt<UserProfileManager>().user!.followingProfiles.contains(id);
  }
}
