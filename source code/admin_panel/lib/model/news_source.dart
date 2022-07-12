import 'package:music_streaming_admin_panel/helper/common_import.dart';

class AuthorsModel {
  String id;
  String name;
  String image;
  int status;
  int totalPosts;
  int totalFollowers;
  DateTime createdAt;

  AuthorsModel({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.totalPosts,
    required this.totalFollowers,
    required this.createdAt,
  });

  factory AuthorsModel.fromJson(Map<String, dynamic> json) =>
      AuthorsModel(
        id: json["id"],
        name: json["name"],
        image: json["image"] ??
            'https://images.unsplash.com/photo-1657558570424-5e5a73d5edb5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyOHx8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=60',
        status: json["status"],
        totalPosts: json["totalPosts"] ?? 0,
        totalFollowers: json["totalFollowers"] ?? 0,
        createdAt: json["createdAt"] == null
            ? DateTime.now()
            : json["createdAt"].toDate(),
      );

  String get addedOn {
    return DateFormat('yyyy-MM-dd – kk:mm').format(createdAt);
  }
}