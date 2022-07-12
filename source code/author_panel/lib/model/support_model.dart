
class SupportModel {
  String id;
  String name;
  String email;
  String? phone;
  String message;
  int status;

  SupportModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.message,
    required this.status,

  });

  factory SupportModel.fromJson(Map<String, dynamic> json) => SupportModel(
    id: json["id"] ,
    name: json["name"] ,
    email: json["email"],
    phone: json["phone"] ,
    message: json["message"] ,
    status: json["status"] ,

  );

}
