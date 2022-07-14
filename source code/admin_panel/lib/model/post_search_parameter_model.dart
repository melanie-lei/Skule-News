class BlogPostSearchParamModel {
  String? searchText;
  String? categoryId;
  String? userId;
  List<String>? hashtags;
  List<String>? userIds;
  List<String>? categoryIds;
  List<String>? postIds;
  int? approvedStatus;
  int? status;
  bool? featured;
  bool? isRecent;

  BlogPostSearchParamModel(
      {this.searchText,
      this.categoryId,
      this.userId,
      this.hashtags,
      this.userIds,
      this.categoryIds,
      this.postIds,
      this.approvedStatus,
      this.featured,
      this.isRecent,
      this.status});
}
