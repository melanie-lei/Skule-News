
class SettingsModel {
  String? phone;
  String? email;
  String? facebook;
  String? twitter;
  String? aboutUs;
  String? privacyPolicy;

  SettingsModel({
    this.phone,
    this.email,
    this.facebook,
    this.twitter,
    this.aboutUs,
    this.privacyPolicy,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
    phone: json["phone"] ,
    email: json["email"],
    facebook: json["facebook"] ,
    twitter: json["twitter"] ,
    aboutUs: json["aboutUs"] ,
    privacyPolicy: json["privacyPolicy"] ,
  );

}
