import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';
import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

String getRandString(int len) {
  var random = Random.secure();
  var values = List<int>.generate(len, (i) => random.nextInt(255));
  String randomString = base64UrlEncode(values);
  return randomString.replaceAll('=', '');
}

class FirebaseResponse {
  bool? status;
  String? message;
  Object? result;

  FirebaseResponse(this.status, this.message);
}

class FirebaseManager {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseResponse? response;

  final FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  CollectionReference blogPostsCollection =
      FirebaseFirestore.instance.collection('blogPosts');

  CollectionReference pendingApprovalPostsCollection =
      FirebaseFirestore.instance.collection('pendingBlogPosts');

  CollectionReference commentsCollection =
      FirebaseFirestore.instance.collection('comments');

  CollectionReference categoriesCollection =
      FirebaseFirestore.instance.collection('categories');

  CollectionReference authorsCollection =
      FirebaseFirestore.instance.collection('authors');

  CollectionReference counter =
  FirebaseFirestore.instance.collection('counter');

  /////////////////////////*********** User ***********//////////////////////////////////

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<FirebaseResponse> login(String email, String password) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await Firebase.initializeApp();
    User? user;

    await auth.setPersistence(Persistence.LOCAL);

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;

      if (userCredential.additionalUserInfo?.isNewUser == true) {
        insertUser(user!.uid);
      }

      response = FirebaseResponse(true, null);
    } catch (error) {
      response =
          FirebaseResponse(false, LocalizationString.userNameOrPasswordIsWrong);
    }

    return response!;
  }

  insertUser(String id) async {
    final batch = FirebaseFirestore.instance.batch();
    DocumentReference doc = authorsCollection.doc(id);

    batch.set(doc, {'id': id, 'name': 'Admin', 'status': 1});

    await batch.commit().then((value) {}).catchError((error) {});
  }

  loginAnonymously() async {
    await auth.signInAnonymously();
  }

  Future<FirebaseResponse> loginViaEmail({
    required String email,
    required String password,
  }) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await Firebase.initializeApp();
    User? user;

    await auth.setPersistence(Persistence.LOCAL);

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;

      if (user != null) {
        response = FirebaseResponse(true, null);
      }
      // response!.credential = userCredential;
    } catch (error) {
      response =
          FirebaseResponse(false, LocalizationString.userNameOrPasswordIsWrong);
      // response!.credential = null;
    }

    return response!;
  }

  Future<AuthorsModel?> getCurrentUser(String id) async {
    AuthorsModel? user;

    await authorsCollection.doc(id).get().then((doc) {
      user = AuthorsModel.fromJson(doc.data() as Map<String, dynamic>);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return user;
  }

  Future<FirebaseResponse> changeProfilePassword({required String pwd}) async {
    await FirebaseAuth.instance.currentUser?.updatePassword(pwd).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> resetPassword(String email) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  // Future<FirebaseResponse> deleteAuthor(AuthorsModel model) async {
  //   DocumentReference userDoc = authorsCollection.doc(model.id);
  //   DocumentReference counterDoc = counter.doc('counter');
  //
  //   WriteBatch batch = FirebaseFirestore.instance.batch();
  //
  //   batch.update(userDoc, {'status': 0});
  //   batch.update(counterDoc, {'authors': FieldValue.increment(-1)});
  //
  //   await batch.commit().then((value) {
  //     response = FirebaseResponse(true, null);
  //   }).catchError((error) {
  //     response = FirebaseResponse(false, error);
  //   });
  //   return response!;
  // }

  Future<String> updateProfileImage(File imageFile) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef =
        storageRef.child("${FirebaseAuth.instance.currentUser!.uid}.jpg");

    await imageRef.putFile(imageFile);
    String path = await imageRef.getDownloadURL();

    DocumentReference userDoc =
        authorsCollection.doc(FirebaseAuth.instance.currentUser!.uid);

    getIt<UserProfileManager>().user!.image = path;
    await userDoc.update({
      'image': path,
    }).then((value) {
      // response = FirebaseResponse(true, null);
    }).catchError((error) {
      // response = FirebaseResponse(false, error);
    });
    return path;
  }

  Future<List<CategoryModel>> getSourceCategories(String id) async {
    List<CategoryModel> list = [];
    await authorsCollection
        .doc(id)
        .collection('categories')
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        list.add(CategoryModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return list;
  }

  Future<FirebaseResponse> deactivateBlog(BlogPostModel model) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference postDoc = blogPostsCollection.doc(model.id);
    DocumentReference userDoc = authorsCollection.doc(model.authorId);
    DocumentReference counterDoc = counter.doc('counter');

    batch.update(postDoc, {'status': 0});
    batch.update(userDoc, {'totalPosts': FieldValue.increment(-1)});
    batch.update(counterDoc, {'blogs': FieldValue.increment(-1)});

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> deleteBlogReport(BlogPostModel model) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference doc = blogPostsCollection.doc(model.id);
    batch.update(doc, {'reportCount': 0});

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<List<BlogPostModel>> getAllReportedBlogs() async {
    List<BlogPostModel> ringtonesList = [];

    await blogPostsCollection
        .where('reportCount', isGreaterThan: 0)
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        ringtonesList
            .add(BlogPostModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return ringtonesList;
  }

  Future<String> uploadBlogImage(
      {required String uniqueId,
      required Uint8List bytes,
      required String fileName}) async {
    final _firebaseStorage =
        FirebaseStorageWeb(bucket: AppConfig.firebaseStorageBucketUrl);
    String randomImageName = uniqueId + p.extension(fileName);

    final mime = lookupMimeType('', headerBytes: bytes);

    final metadata = SettableMetadata(
      contentType: mime,
    );

    //Upload to Firebase
    var uploadTask = _firebaseStorage
        .ref('blogmaster/coverimage/$randomImageName')
        .putData(bytes, metadata);

    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadBlogFile(
      {required String uniqueId,
      required Uint8List bytes,
      required String fileName}) async {
    final _firebaseStorage =
        FirebaseStorageWeb(bucket: AppConfig.firebaseStorageBucketUrl);
    String randomImageName = uniqueId + p.extension(fileName);

    final metadata = SettableMetadata(
      contentType: 'audio/mpeg',
    );

    //Upload to Firebase
    var uploadTask = _firebaseStorage
        .ref('blogmaster/files/$randomImageName')
        .putData(bytes, metadata);

    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    return downloadUrl;
  }

  Future<FirebaseResponse> increaseSourceSearchCount(
      AuthorsModel source) async {
    DocumentReference sourceDoc = authorsCollection.doc(source.id);

    await sourceDoc.update({
      'searchedCount': FieldValue.increment(1),
      'popularityFactor': FieldValue.increment(1)
    }).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> insertBlogPost(
      {required BlogPostModel? post,
      required bool isUpdate,
      required String postId,
      required String postTitle,
      required String content,
      required String postThumbnail,
      String? postVideoPath,
      required String categoryId,
      required String category,
      required List<String> hashtags,
      required bool isPremium,
      required AvailabilityStatus status}) async {
    var postJson = {
      'authorId': getIt<UserProfileManager>().user!.id,
      'authorName': getIt<UserProfileManager>().user!.name,
      'authorPicture': getIt<UserProfileManager>().user!.image,
      'category': category,
      'categoryId': categoryId,
      'content': content,
      'contentType': postVideoPath == null ? 1 : 2,
      'thumbnailImage': postThumbnail,
      'createdAt': FieldValue.serverTimestamp(),
      'hashtags': hashtags,
      'id': postId,
      'isPremium': isPremium,
      'keywords': postTitle.allPossibleSubstrings(),
      'likesCount': 0,
      'reportCount': 0,
      'savedCount': 0,
      'status': status == AvailabilityStatus.active ? 1 : 0,
      'title': postTitle,
      'totalComments': 0,
      'totalLikes': 0,
      'totalSaved': 0,
      'videoUrl': postVideoPath
    };

    int postCounterIncrementFactor = 1;

    DocumentReference postDoc = blogPostsCollection.doc(postId);
    DocumentReference counterDoc = counter.doc('counter');
    DocumentReference author = authorsCollection.doc(auth.currentUser!.uid);

    if (isUpdate == true) {
      if (post!.status == 1 && status == AvailabilityStatus.deactivated) {
        postCounterIncrementFactor = -1;
      } else if (post.status == 0 && status == AvailabilityStatus.active) {
        postCounterIncrementFactor = 1;
      } else {
        postCounterIncrementFactor = 0;
      }

      WriteBatch batch = FirebaseFirestore.instance.batch();

      batch.update(postDoc, postJson);
      batch.update(author,
          {'totalPosts': FieldValue.increment(postCounterIncrementFactor)});

      if (postCounterIncrementFactor != 0) {
        batch.update(counterDoc,
            {'blogs': FieldValue.increment(postCounterIncrementFactor)});
      }

      await batch.commit().then((value) {
        response = FirebaseResponse(true, null);
      }).catchError((error) {
        response = FirebaseResponse(false, error);
      });
    } else {
      postJson['createdAt'] = FieldValue.serverTimestamp();
      postJson['searchedCount'] = 0;
      postJson['totalDownloads'] = 0;

      WriteBatch batch = FirebaseFirestore.instance.batch();
      batch.set(postDoc, postJson);
      batch.update(counterDoc,
          {'blogs': FieldValue.increment(postCounterIncrementFactor)});
      batch.update(author, {'totalPosts': FieldValue.increment(1)});

      await batch.commit().then((value) {
        response = FirebaseResponse(true, null);
      }).catchError((error) {
        response = FirebaseResponse(false, error);
      });
    }

    return response!;
  }

  addOrRemoveFromFeature(BlogPostModel model) async {
    final batch = FirebaseFirestore.instance.batch();
    DocumentReference postDoc =
        blogPostsCollection.doc(model.id); //.collection('following');
    DocumentReference counterDoc = counter.doc('counter');

    batch.update(postDoc, {
      'featured': model.isFeatured,
    });

    batch.update(counterDoc, {
      'featured': FieldValue.increment(model.isFeatured == true ? 1 : -1),
    });

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  addOrRemoveFromPremium(BlogPostModel model) async {
    final batch = FirebaseFirestore.instance.batch();
    DocumentReference postDoc =
        blogPostsCollection.doc(model.id); //.collection('following');
    DocumentReference counterDoc = counter.doc('counter');

    batch.update(postDoc, {
      'isPremium': model.isPremium,
    });

    batch.update(counterDoc, {
      'premium': FieldValue.increment(model.isPremium == true ? 1 : -1),
    });

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<List<BlogPostModel>> searchPosts(
      {required BlogPostSearchParamModel searchModel}) async {
    List<BlogPostModel> list = [];

    Query query = blogPostsCollection;

    if (searchModel.searchText != null) {
      query =
          query.where("keywords", arrayContainsAny: [searchModel.searchText]);
    }
    if (searchModel.categoryId != null) {
      query = query.where('categoryId', isEqualTo: searchModel.categoryId);
    }
    if (searchModel.categoryIds != null) {
      query = query.where('categoryId', whereIn: searchModel.categoryIds);
    }
    if (searchModel.hashtags != null) {
      query = query.where("hashtags", arrayContainsAny: searchModel.hashtags);
    }
    if (searchModel.userId != null) {
      query = query.where('authorId', isEqualTo: searchModel.userId);
    }
    if (searchModel.userIds != null) {
      query = query.where("authorId", whereIn: searchModel.userIds);
    }
    if (searchModel.featured != null) {
      query = query.where("featured", isEqualTo: searchModel.featured);
    }
    if (searchModel.isRecent != null) {
      query = query.orderBy("createdAt", descending: true).limit(10);
    }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        list.add(BlogPostModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return list;
  }

  Future<List<BlogPostModel>> searchPendingApprovalPosts(
      {required BlogPostSearchParamModel searchModel}) async {
    List<BlogPostModel> list = [];

    Query query = pendingApprovalPostsCollection;

    if (searchModel.searchText != null) {
      query =
          query.where("keywords", arrayContainsAny: [searchModel.searchText]);
    }
    if (searchModel.categoryId != null) {
      query = query.where('categoryId', isEqualTo: searchModel.categoryId);
    }
    if (searchModel.categoryIds != null) {
      query = query.where('categoryId', whereIn: searchModel.categoryIds);
    }
    if (searchModel.hashtags != null) {
      query = query.where("hashtags", arrayContainsAny: searchModel.hashtags);
    }
    if (searchModel.userId != null) {
      query = query.where('authorId', isEqualTo: searchModel.userId);
    }
    if (searchModel.userIds != null) {
      query = query.where("authorId", whereIn: searchModel.userIds);
    }
    if (searchModel.featured != null) {
      query = query.where("featured", isEqualTo: searchModel.featured);
    }
    if (searchModel.isRecent != null) {
      query = query.orderBy("createdAt", descending: true).limit(10);
    }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        list.add(BlogPostModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return list;
  }

  Future<List<BlogPostModel>> getFeaturedPosts() async {
    List<BlogPostModel> list = [];

    Query query = blogPostsCollection.where('featured', isEqualTo: true);

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        list.add(BlogPostModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return list;
  }

  Future<List<CategoryModel>> searchCategories(
      {String? searchText, int? type}) async {
    List<CategoryModel> categoriesList = [];

    Query query = categoriesCollection;

    if (searchText != null) {
      query = query.where("keywords", arrayContainsAny: [searchText]);
    }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        categoriesList
            .add(CategoryModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return categoriesList;
  }

  Future<List<AuthorsModel>> searchSources(
      {String? searchText, int? type, List<String>? sourceIds}) async {
    List<AuthorsModel> list = [];

    Query query = authorsCollection;

    if (searchText != null) {
      query = query.where("keywords", arrayContainsAny: [searchText]);
    }

    if (sourceIds != null && sourceIds.isNotEmpty) {
      query = query.where("id", whereIn: sourceIds);
    }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        list.add(AuthorsModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return list;
  }

  Future<List<CommentModel>> getComments(
      {String? searchText, int? type}) async {
    List<CommentModel> list = [];

    Query query = commentsCollection;

    if (searchText != null) {
      query = query.where("keywords", arrayContainsAny: [searchText]);
    }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        list.add(CommentModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return list;
  }

  Future<FirebaseResponse> sendComment(CommentModel comment) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference commentDoc = commentsCollection.doc(comment.id);
    DocumentReference postDoc = blogPostsCollection.doc(comment.postId);

    var commentJson = comment.toJson();
    commentJson['createdAt'] = FieldValue.serverTimestamp();

    batch.set(commentDoc, commentJson);
    batch.update(postDoc, {
      'totalComments': FieldValue.increment(1),
      'popularityFactor': FieldValue.increment(1)
    });

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }


  /////////////////////////////////************* Category *************////////////////////////////////////////

  Future<FirebaseResponse> insertNewCategory(
      {CategoryModel? category,
      required String id,
      required String name,
      required String image,
      required AvailabilityStatus status}) async {
    DocumentReference categoryDoc = categoriesCollection.doc(id);

    var categoryJson = {
      'id': id,
      'name': name,
      'image': image,
      'status': status == AvailabilityStatus.active ? 1 : 0,
      'keywords': name.allPossibleSubstrings(),
    };

    if (category != null) {
      await categoryDoc.update(categoryJson).then((value) {
        response = FirebaseResponse(true, null);
      }).catchError((error) {
        response = FirebaseResponse(false, error);
      });
    } else {
      await categoryDoc.set(categoryJson).then((value) {
        response = FirebaseResponse(true, null);
      }).catchError((error) {
        response = FirebaseResponse(false, error);
      });
    }

    return response!;
  }

  Future<String> uploadCategoryImage(
      {required String uniqueId,
      required Uint8List bytes,
      required String fileName}) async {
    final _firebaseStorage =
        FirebaseStorageWeb(bucket: AppConfig.firebaseStorageBucketUrl);
    String randomImageName = uniqueId + p.extension(fileName);

    final mime = lookupMimeType('', headerBytes: bytes);

    final metadata = SettableMetadata(
      contentType: mime,
    );

    //Upload to Firebase
    var uploadTask = _firebaseStorage
        .ref('blogmaster/category_cover/$randomImageName')
        .putData(bytes, metadata);

    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

    return downloadUrl;
  }

  Future<FirebaseResponse> deleteCategory(CategoryModel category) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference counterDoc = counter.doc('counter');
    DocumentReference categoryDoc = categoriesCollection.doc(category.id);

    batch.update(categoryDoc, {'status': 0});
    batch.update(counterDoc, {'categories': FieldValue.increment(-1)});

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<List<CategoryModel>> getAllCategoriesBy(
      {required int status, String? searchKeyword}) async {
    List<CategoryModel> categoryList = [];

    Query query = categoriesCollection.where('status', isEqualTo: status);

    if (searchKeyword != null && searchKeyword.isNotEmpty) {
      query = query.where("keywords", arrayContainsAny: [searchKeyword]);
    }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        categoryList
            .add(CategoryModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return categoryList;
  }

  Future<CategoryModel?> getCategory(String id) async {
    CategoryModel? category;

    await categoriesCollection.doc(id).get().then((doc) {
      category = CategoryModel.fromJson(doc.data() as Map<String, dynamic>);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return category;
  }

  Future<RecordCounterModel?> getCounter() async {
    RecordCounterModel? recordCounter;

    await counter.doc('counter').get().then((doc) {
      recordCounter =
          RecordCounterModel.fromJson(doc.data() as Map<String, dynamic>);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return recordCounter;
  }

}