
class Hashtag {
  String id;
  String name;
  String image;
  int status;
  int totalPosts;
  int totalFollowers;

  Hashtag({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
    required this.totalPosts,
    required this.totalFollowers,
  });

  factory Hashtag.fromJson(Map<String, dynamic> json) =>
      Hashtag(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        status: json["status"],
        totalPosts: json["totalPosts"],
        totalFollowers: json["totalFollowers"],
      );

}