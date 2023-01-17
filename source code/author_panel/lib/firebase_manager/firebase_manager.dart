import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';
import 'package:skule_news_admin_panel/helper/common_import.dart';
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

  CollectionReference commentsCollection =
      FirebaseFirestore.instance.collection('comments');

  CollectionReference categoriesCollection =
      FirebaseFirestore.instance.collection('categories');

  CollectionReference authorsCollection =
      FirebaseFirestore.instance.collection('authors');

  CollectionReference counter =
      FirebaseFirestore.instance.collection('counter');

  /* Users */

  /// Logs the user out.
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  /// Logs the user in with an account, persisting after the browser window closes.
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

      await authorsCollection
          .where("id", isEqualTo: user!.uid)
          .limit(1)
          .get()
          .then((snap) {
        if (snap.docs.isEmpty) {
          getIt<UserProfileManager>().logout();
          response = FirebaseResponse(false, "Not an author account");
        } else {
          insertUser(id: user!.uid, name: user.displayName!);
          response = FirebaseResponse(true, null);
        }
      });
    } catch (error) {
      response =
          FirebaseResponse(false, LocalizationString.userNameOrPasswordIsWrong);
    }

    return response!;
  }

  /// Inserts an author user into the database.
  Future<FirebaseResponse> insertUser(
      {required String id, String? name}) async {
    final batch = FirebaseFirestore.instance.batch();
    DocumentReference doc = authorsCollection.doc(id);
    DocumentReference counterDoc = counter.doc('counter');

    batch.set(doc, {
      'id': id,
      'name': name,
      'status': 1,
      'accountType': 2,
      'keywords': name!.allPossibleSubstrings(),
      'createdAt': DateTime.now(),
      'tokens': []
    });
    batch.update(counterDoc, {'authors': FieldValue.increment(1)});

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });

    return response!;
  }

  Future<FirebaseResponse> updateUser(
      {String? name, String? bio, String? image, String? coverImage}) async {
    DocumentReference doc =
        authorsCollection.doc(FirebaseAuth.instance.currentUser!.uid);

    await doc.update({
      'name': name,
      'bio': bio,
      'image': image,
      'coverImage': coverImage
    }).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });
    return response!;
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

  Future<FirebaseResponse> signUpViaEmail(
      {required String email,
      required String password,
      required String name}) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;

      if (user != null) {
        response = FirebaseResponse(true, null);
        await insertUser(id: user.uid, name: name);
      }
    } catch (error) {
      print(error);
      response = FirebaseResponse(false, error.toString());
    }

    return response!;
  }

  Future<AuthorsModel?> getCurrentUser(String id) async {
    AuthorsModel? user;

    await authorsCollection.doc(id).get().then((doc) {
      user = AuthorsModel.fromJson(doc.data() as Map<String, dynamic>);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });

    return user;
  }

  Future<FirebaseResponse> changeProfilePassword({required String pwd}) async {
    await FirebaseAuth.instance.currentUser?.updatePassword(pwd).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });
    return response!;
  }

  Future<FirebaseResponse> resetPassword(String email) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });
    return response!;
  }

  Future<String> updateProfileImage(
      {required Uint8List bytes, required String fileName}) async {
    final _firebaseStorage =
        FirebaseStorageWeb(bucket: AppConfig.firebaseStorageBucketUrl);

    final mime = lookupMimeType('', headerBytes: bytes);

    final metadata = SettableMetadata(
      contentType: mime,
    );

    //Upload to Firebase
    var uploadTask = _firebaseStorage
        .ref('blogmaster/profileImage/$fileName')
        .putData(bytes, metadata);

    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    return downloadUrl;
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
      response = FirebaseResponse(false, error.toString());
    });

    return list;
  }

  Future<FirebaseResponse> deactivateBlog(BlogPostModel model) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference postDoc = blogPostsCollection.doc(model.id);
    DocumentReference userDoc = authorsCollection.doc(model.authorId);
    DocumentReference counterDoc = counter.doc('counter');

    batch.update(postDoc, {'status': 0});
    batch.update(userDoc, {'totalBlogPosts': FieldValue.increment(-1)});
    batch.update(counterDoc, {'totalBlogPosts': FieldValue.increment(-1)});

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
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
      response = FirebaseResponse(false, error.toString());
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
      response = FirebaseResponse(false, error.toString());
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

  Future<String> uploadBlogVideo(
      {required String uniqueId,
      required Uint8List bytes,
      required String fileName}) async {
    final _firebaseStorage =
        FirebaseStorageWeb(bucket: AppConfig.firebaseStorageBucketUrl);
    String randomImageName = uniqueId + p.extension(fileName);

    final metadata = SettableMetadata(
      contentType: 'video/mp4',
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
      response = FirebaseResponse(false, error.toString());
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
    var keywords = postTitle.allPossibleSubstrings();
    keywords.addAll(hashtags.map((e) => '#$e'));
    keywords.add(categoryId);

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
      'keywords': keywords,
      'likesCount': 0,
      'reportCount': 0,
      'savedCount': 0,
      'status': status == AvailabilityStatus.active ? 1 : 0,
      'title': postTitle,
      'totalComments': 0,
      'totalLikes': 0,
      'totalSaved': 0,
      'videoUrl': postVideoPath,
      'approvedStatus': 0 // Pending blog status.
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
          {'totalBlogPosts': FieldValue.increment(postCounterIncrementFactor)});

      if (postCounterIncrementFactor != 0) {
        batch.update(counterDoc, {
          'totalBlogPosts': FieldValue.increment(postCounterIncrementFactor)
        });
      }

      await batch.commit().then((value) {
        response = FirebaseResponse(true, null);
      }).catchError((error) {
        response = FirebaseResponse(false, error.toString());
      });
    } else {
      postJson['createdAt'] = FieldValue.serverTimestamp();
      postJson['searchedCount'] = 0;
      postJson['totalDownloads'] = 0;

      WriteBatch batch = FirebaseFirestore.instance.batch();
      batch.set(postDoc, postJson);
      /*
      batch.update(counterDoc,
          {'totalBlogPosts': FieldValue.increment(postCounterIncrementFactor)});

       */
      // batch.update(author, {'totalBlogPosts': FieldValue.increment(1)});

      await batch.commit().then((value) {
        response = FirebaseResponse(true, null);
      }).catchError((error) {
        response = FirebaseResponse(false, error.toString());
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
      response = FirebaseResponse(false, error.toString());
    });
    return response!;
  }

  Future<List<BlogPostModel>> searchPosts(
      {required BlogPostSearchParamModel searchModel}) async {
    List<BlogPostModel> list = [];

    Query query = blogPostsCollection;
    query = query.where('authorId', isEqualTo: searchModel.userId);

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
    if (searchModel.userIds != null) {
      query = query.where("authorId", whereIn: searchModel.userIds);
    }
    if (searchModel.featured != null) {
      query = query.where("featured", isEqualTo: searchModel.featured);
    }
    if (searchModel.status != null) {
      query = query.where("status", isEqualTo: searchModel.status);
    }
    if (searchModel.approvedStatus != null) {
      query =
          query.where("approvedStatus", isEqualTo: searchModel.approvedStatus);
    }

    query = query.orderBy("createdAt", descending: true);

    if (searchModel.isRecent != null) {
      query = query.limit(10);
    }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        list.add(BlogPostModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      print(error);

      response = FirebaseResponse(false, error.toString());
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
      response = FirebaseResponse(false, error.toString());
    });

    return list;
  }

  Future<List<CategoryModel>> searchAdminCategories() async {
    List<CategoryModel> categoriesList = [];

    Query query = categoriesCollection.where('status', isEqualTo: 1);

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        categoriesList
            .add(CategoryModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });

    return categoriesList;
  }

  Future<List<CategoryModel>> searchAuthorCategories(
      {required int status}) async {
    List<CategoryModel> categoriesList = [];

    Query query = authorsCollection
        .doc(auth.currentUser!.uid)
        .collection('categories')
        .where('status', isEqualTo: status);

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        categoriesList
            .add(CategoryModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
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
      response = FirebaseResponse(false, error.toString());
    });

    return list;
  }

  Future<List<CommentModel>> getComments({required String posId}) async {
    List<CommentModel> list = [];

    Query query = commentsCollection
        .where("posId", isEqualTo: posId)
        .orderBy("createdAt", descending: true);

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        list.add(CommentModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
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
      response = FirebaseResponse(false, error.toString());
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
    DocumentReference categoryDoc = authorsCollection
        .doc(auth.currentUser!.uid)
        .collection('categories')
        .doc(id);

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
        response = FirebaseResponse(false, error.toString());
      });
    } else {
      await categoryDoc.set(categoryJson).then((value) {
        response = FirebaseResponse(true, null);
      }).catchError((error) {
        response = FirebaseResponse(false, error.toString());
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
    DocumentReference categoryDoc = authorsCollection.doc(category.id);

    batch.update(categoryDoc, {'status': 0});
    batch.update(counterDoc, {'categories': FieldValue.increment(-1)});

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });
    return response!;
  }

  Future<RecordCounterModel?> getCounter() async {
    RecordCounterModel? recordCounter;

    await counter.doc('counter').get().then((doc) {
      recordCounter =
          RecordCounterModel.fromJson(doc.data() as Map<String, dynamic>);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });

    return recordCounter;
  }
}
