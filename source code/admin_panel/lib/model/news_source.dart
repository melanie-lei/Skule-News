import 'package:skule_news_admin_panel/helper/common_import.dart';

class AuthorsModel {
  String id;
  String name;
  String? bio;
  int accountType; // invalid=0, admin=1, author=2

  String image;
  int status;
  int totalPosts;
  int totalFollowers;
  DateTime createdAt;

  AuthorsModel({
    required this.id,
    required this.name,
    this.bio,
    required this.accountType,
    required this.image,
    required this.status,
    required this.totalPosts,
    required this.totalFollowers,
    required this.createdAt,
  });

  factory AuthorsModel.fromJson(Map<String, dynamic> json) => AuthorsModel(
    id: json["id"],
    name: json["name"],
    bio: json["bio"] ?? '',
    accountType: json["accountType"] ?? 2,
    image: json["image"] ??
        'https://images.unsplash.com/photo-1535953267280-5fd672f9bfa3?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=435&q=80',
    status: json["status"],
    totalPosts: json["totalBlogPosts"] ?? 0,
    totalFollowers: json["totalFollowers"] ?? 0,
    createdAt: json["createdAt"]?.toDate() ?? DateTime.now()
  );

  String get addedOn {
    return DateFormat('yyyy-MM-dd – kk:mm').format(createdAt);
  }
}
