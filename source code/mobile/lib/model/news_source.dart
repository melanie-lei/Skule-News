import 'package:music_streaming_mobile/helper/common_import.dart';

class NewsSourceModel {
  String id;
  String name;
  String image;
  int status;
  int totalPosts;
  int totalFollowers;

  NewsSourceModel({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.totalPosts,
    required this.totalFollowers,
  });

  factory NewsSourceModel.fromJson(Map<String, dynamic> json) =>
      NewsSourceModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        status: json["status"],
        totalPosts: json["totalPosts"],
        totalFollowers: json["totalFollowers"],
      );

  isFollowing(){
    if(getIt<UserProfileManager>().user == null){
      return false;
    }
    return getIt<UserProfileManager>().user!.followingProfiles.contains(id);
  }
}
