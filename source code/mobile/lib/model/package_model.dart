class PackageModel {
  String id = '';
  String name = '';

  String inAppPurchaseIdIOS = '';
  String inAppPurchaseIdAndroid = '';

  PackageModel();

  factory PackageModel.fromJson(dynamic json) {
    PackageModel model = PackageModel();
    model.id = json['id'];
    model.name = json['name'];

    model.inAppPurchaseIdIOS = json['in_app_purchase_id_ios'];
    model.inAppPurchaseIdAndroid = json['in_app_purchase_id_android'];

    return model;
  }
}
