
class CategoryModel {
  String id;
  String name;
  String? image;
  int status;

  CategoryModel({
    required this.id,
    required this.name,
    this.image,
    required this.status,

  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json["id"] ,
    name: json["name"],
    image: json["image"] ,
    status: json["status"] ?? 1,
  );

}
