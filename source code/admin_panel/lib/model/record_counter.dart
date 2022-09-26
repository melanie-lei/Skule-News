class RecordCounterModel {
  int blogs;
  int readers;
  int featured;
  int authors;

  RecordCounterModel({
    required this.blogs,
    required this.readers,
    required this.authors,
    required this.featured,
  });

  factory RecordCounterModel.fromJson(Map<String, dynamic> json) =>
      RecordCounterModel(
        blogs: json["totalBlogPosts"] ?? 0,
        readers: json["readers"] ?? 0,
        authors: json["authors"] ?? 0,
        featured: json["featured"] ?? 0,

      );
}
