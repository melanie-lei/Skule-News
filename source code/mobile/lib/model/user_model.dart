import 'package:music_streaming_mobile/helper/common_import.dart';

class UserModel {
  String id;
  String? name;
  String? phone;

  String? bio;

  String? image;

  List<String> followingProfiles;
  List<String> followingLocations;
  List<String> followingHashtags;
  List<String> followingCategories;

  List<String> likedPost;
  List<String> savedPost;

  int status;
  int totalPosts;
  int totalFollowers;

  bool isPro = false;

  DateTime? subscriptionDate;
  DateTime todayDate;
  int subscriptionDays;
  String? subscriptionTerm;

  UserModel({
    required this.id,
    required this.name,
    this.phone,
    required this.bio,
    this.image,
    required this.followingProfiles,
    required this.followingLocations,
    required this.followingHashtags,
    required this.followingCategories,
    required this.likedPost,
    required this.savedPost,
    required this.totalPosts,
    required this.totalFollowers,
    required this.status,
    required this.subscriptionDate,
    required this.todayDate,
    required this.subscriptionDays,
    this.subscriptionTerm,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"] ?? '',
        phone: json["phone"] ?? '',
        bio: json["bio"] ?? '',
        image: json["image"],
        totalPosts: json["totalPosts"] ?? 0,
        totalFollowers: json["totalFollowers"] ?? 0,
        followingProfiles: json["followingProfiles"] == null
            ? []
            : (json["followingProfiles"] as List<dynamic>)
                .map((e) => e.toString())
                .toList(),
        followingLocations: json["followingLocations"] == null
            ? []
            : (json["followingLocations"] as List<dynamic>)
                .map((e) => e.toString())
                .toList(),
        followingHashtags: json["followingHashtags"] == null
            ? []
            : (json["followingHashtags"] as List<dynamic>)
                .map((e) => e.toString())
                .toList(),
        followingCategories: json["followingCategories"] == null
            ? []
            : (json["followingCategories"] as List<dynamic>)
                .map((e) => e.toString())
                .toList(),
        likedPost: json["likedPosts"] == null
            ? []
            : (json["likedPosts"] as List<dynamic>)
                .map((e) => e.toString())
                .toList(),
        savedPost: json["savedPosts"] == null
            ? []
            : (json["savedPosts"] as List<dynamic>)
                .map((e) => e.toString())
                .toList(),
        status: json["status"],
        subscriptionDays: json["numberOfDays"] ?? 0,
        subscriptionTerm: json["subscriptionTerm"],
        subscriptionDate: json["subscriptionDate"] == null
            ? null
            : json["subscriptionDate"].toDate(),
        todayDate: json["todayDate"] == null
            ? DateTime.now()
            : json["todayDate"].toDate(),
      );

  isFollowing() {
    if (getIt<UserProfileManager>().user == null) {
      return false;
    }
    return getIt<UserProfileManager>().user!.followingProfiles.contains(id);
  }

  String get infoToShow {
    if ((getIt<UserProfileManager>().user!.name ?? '').isNotEmpty) {
      return getIt<UserProfileManager>().user!.name!;
    }
    if ((getIt<UserProfileManager>().user!.phone ?? '').isNotEmpty) {
      return getIt<UserProfileManager>().user!.phone!;
    }

    return '';
  }

  String get getInitials {
    if ((getIt<UserProfileManager>().user!.name ?? '').isNotEmpty) {
      List<String> nameparts =
          getIt<UserProfileManager>().user!.name!.split(' ');
      return nameparts[0].substring(0, 1).toUpperCase() +
          nameparts[1].substring(0, 1).toUpperCase();
    }
    if ((getIt<UserProfileManager>().user!.phone ?? '').isNotEmpty) {
      return getIt<UserProfileManager>().user!.phone!.substring(0, 1);
    }
    List<String> nameparts = AppConfig.projectName.split(' ');
    return nameparts[0].substring(0, 1).toUpperCase() +
        nameparts[1].substring(0, 1).toUpperCase();
  }
}
