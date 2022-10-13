import 'package:skule_news_admin_panel/helper/common_import.dart';

class AuthorsModel {
  String id;
  String name;
  String email;

  String? bio;

  String image;
  int status;
  int totalPosts;
  int totalFollowers;
  DateTime createdAt;
  String coverImage;

  AuthorsModel({
    required this.id,
    required this.name,
    required this.email,
    this.bio,
    required this.image,
    required this.coverImage,
    required this.status,
    required this.totalPosts,
    required this.totalFollowers,
    required this.createdAt,
  });

  factory AuthorsModel.fromJson(Map<String, dynamic> json) => AuthorsModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        bio: json["bio"] ?? '',
        image: json["image"] ??
            'https://images.unsplash.com/photo-1657558570424-5e5a73d5edb5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyOHx8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=60',
        coverImage: json["coverImage"] ?? AppConfig.backgroundImage,
        status: json["status"],
        totalPosts: json["totalBlogPosts"] ?? 0,
        totalFollowers: json["totalFollowers"] ?? 0,
        createdAt: json["createdAt"] == null
            ? DateTime.now()
            : json["createdAt"].toDate(),
      );

  String get addedOn {
    return DateFormat('yyyy-MM-dd – kk:mm').format(createdAt);
  }
}
