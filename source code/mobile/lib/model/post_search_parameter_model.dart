class PostSearchParamModel {
  String? searchText;
  String? categoryId;
  String? userId;
  List<String>? hashtags;
  List<String>? userIds;
  List<String>? categoryIds;
  List<String>? postIds;

  PostSearchParamModel(
      {this.searchText, this.categoryId, this.userId, this.hashtags, this.userIds, this.categoryIds, this.postIds});
}
