class CategoryModel {
  String id;
  String name;
  String? image;
  int status;
  bool isAdminCategory;

  CategoryModel({
    required this.id,
    required this.name,
    this.image,
    required this.status,
    required this.isAdminCategory,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        status: json["status"] ?? 1,
        isAdminCategory: json["isAdminCategory"] ?? false,
      );
}
