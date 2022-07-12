class RecordCounterModel {
  int blogs;
  int users;
  int featured;
  int authors;

  RecordCounterModel({
    required this.blogs,
    required this.users,
    required this.authors,
    required this.featured,
  });

  factory RecordCounterModel.fromJson(Map<String, dynamic> json) =>
      RecordCounterModel(
        blogs: json["blogs"] ?? 0,
        users: json["users"] ?? 0,
        authors: json["authors"] ?? 0,
        featured: json["featured"] ?? 0,

      );
}
