import 'package:music_streaming_mobile/helper/common_import.dart';

class NewsLocation {
  String id;
  String name;
  String image;
  int status;
  int totalPosts;
  int totalFollowers;

  NewsLocation({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.totalPosts,
    required this.totalFollowers,
  });

  factory NewsLocation.fromJson(Map<String, dynamic> json) =>
      NewsLocation(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        status: json["status"],
        totalPosts: json["totalBlogPosts"],
        totalFollowers: json["totalFollowers"],
      );

  isFollowing(){
    if(getIt<UserProfileManager>().user == null){
      return false;
    }
    return getIt<UserProfileManager>().user!.followingLocations.contains(id);
  }
}
