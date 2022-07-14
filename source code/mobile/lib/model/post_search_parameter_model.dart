import 'package:cloud_firestore/cloud_firestore.dart';

class PostSearchParamModel {
  String? searchText;
  String? categoryId;
  String? userId;
  List<String>? hashtags;
  List<String>? userIds;
  List<String>? categoryIds;
  List<String>? postIds;
  // QueryDocumentSnapshot? startsAt;
  bool? isFeatured;

  PostSearchParamModel(
      {this.searchText,
      this.categoryId,
      this.userId,
      this.hashtags,
      this.userIds,
      this.categoryIds,
      this.postIds,
      this.isFeatured,
      // this.startsAt
      });
}
