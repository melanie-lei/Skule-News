
class SupportModel {
  String id;
  String name;
  String email;
  String? phone;
  String message;
  String? reply;

  SupportModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.reply,
    required this.message,
  });

  factory SupportModel.fromJson(Map<String, dynamic> json) => SupportModel(
    id: json["id"] ,
    name: json["name"] ,
    email: json["email"],
    phone: json["phone"] ,
    message: json["message"] ,
    reply: json["replyMessage"] ,
  );

}
