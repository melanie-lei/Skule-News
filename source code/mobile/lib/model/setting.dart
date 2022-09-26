class SettingsModel {
  String? phone;
  String? email;
  String? facebook;
  String? twitter;
  String? aboutUs;
  String? privacyPolicy;
  String? iOSInAppPurchaseId;
  String? androidInAppPurchaseId;

  SettingsModel({
    this.phone,
    this.email,
    this.facebook,
    this.twitter,
    this.aboutUs,
    this.privacyPolicy,
    this.iOSInAppPurchaseId,
    this.androidInAppPurchaseId,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
    phone: json["phone"],
    email: json["email"],
    facebook: json["facebook"],
    twitter: json["twitter"],
    aboutUs: json["aboutUs"],
    privacyPolicy: json["privacyPolicy"],
    iOSInAppPurchaseId: json["iOSInAppPurchaseId"],
    androidInAppPurchaseId: json["androidInAppPurchaseId"],
  );
}
