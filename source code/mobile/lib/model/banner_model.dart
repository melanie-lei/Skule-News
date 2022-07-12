class BannerModel {
  String id;
  String name;
  String image;
  int type;
  String itemId;
  String language;
  int status;

  BannerModel(
      {required this.id,
        required this.name,
        required this.image,
        required this.type,
        required this.itemId,
        required this.status,
        required this.language});

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
    id: json["id"] ?? '',
    name: json["name"] ?? '',
    image: json["image"] ?? '',
    type: json["type"],
    itemId: json["itemId"],
    language: json["language"],
    status: json["status"],

  );
}
