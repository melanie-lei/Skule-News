class ReportModel {
  String id;
  String name;
  int type;

  ReportModel({
    required this.id,
    required this.name,
    required this.type,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        id: json["id"],
        name: json["name"],
        type: json["type"],
      );
}
