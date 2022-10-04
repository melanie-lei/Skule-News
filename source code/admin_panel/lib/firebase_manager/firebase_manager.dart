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

  CollectionReference commentsCollection =
      FirebaseFirestore.instance.collection('comments');

  CollectionReference categoriesCollection =
      FirebaseFirestore.instance.collection('categories');

  CollectionReference authorsCollection =
      FirebaseFirestore.instance.collection('authors');

  CollectionReference packagesCollection =
      FirebaseFirestore.instance.collection('packages');

  CollectionReference hashtagsCollection =
      FirebaseFirestore.instance.collection('hashtags');

  CollectionReference banners =
      FirebaseFirestore.instance.collection('banners');

  CollectionReference reports =
      FirebaseFirestore.instance.collection('reports');

  CollectionReference contact =
      FirebaseFirestore.instance.collection('contact');

  CollectionReference counter =
      FirebaseFirestore.instance.collection('counter');

  CollectionReference settings =
      FirebaseFirestore.instance.collection('settings');

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

      await insertUser(user!.uid, user.email!);

      response = FirebaseResponse(true, null);
    } catch (error) {
      print(error);
      response =
          FirebaseResponse(false, LocalizationString.userNameOrPasswordIsWrong);
    }

    return response!;
  }

  insertUser(String id, String email) async {
    await firestore.runTransaction((transaction) async {
      DocumentReference doc = authorsCollection.doc(id);
      final snapshot = await transaction.get(doc);

      if (!snapshot.exists) {
        transaction
            .set(doc, {'id': id, 'name': 'Admin', 'status': 1, 'email': email});
      }
    });
  }

  loginAnonymously() async {
    await auth.signInAnonymously();
  }

  Future<AuthorsModel?> getCurrentUser(String id) async {
    AuthorsModel? user;

    print(authorsCollection.doc(id));
    await authorsCollection.doc(id).get().then((doc) {
      print(doc.data());

      user = AuthorsModel.fromJson(doc.data() as Map<String, dynamic>);
    }).catchError((error) {
      print('error');
      print(error);
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
        .ref('blogmaster/profileImage/$randomImageName')
        .putData(bytes, metadata);

    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    return downloadUrl;
  }

  Future<FirebaseResponse> deleteUser(UserModel model) async {
    DocumentReference userDoc = userCollection.doc(model.id);
    DocumentReference counterDoc = counter.doc('counter');

    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.update(userDoc, {'status': 0});
    batch.update(counterDoc, {'users': FieldValue.increment(-1)});

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });
    return response!;
  }

  Future<FirebaseResponse> updateUser(
      {String? name, String? bio, String? image}) async {
    DocumentReference doc =
        authorsCollection.doc(FirebaseAuth.instance.currentUser!.uid);

    await doc.update({'name': name, 'bio': bio, 'image': image}).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });
    return response!;
  }

  Future<FirebaseResponse> deleteAuthor(AuthorsModel model) async {
    DocumentReference userDoc = authorsCollection.doc(model.id);
    DocumentReference counterDoc = counter.doc('counter');

    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.update(userDoc, {'status': 0});
    batch.update(counterDoc, {'authors': FieldValue.increment(-1)});

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });
    return response!;
  }

  Future<AuthorsModel?> getSourceDetail(String id) async {
    AuthorsModel? source;
    await authorsCollection.doc(id).get().then((doc) {
      source = AuthorsModel.fromJson(doc.data() as Map<String, dynamic>);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });

    return source;
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

  Future<FirebaseResponse> approveBlogPost(BlogPostModel model) async {
    DocumentReference activeBlogPost = blogPostsCollection.doc(model.id);
    DocumentReference artistDoc = authorsCollection.doc(model.authorId);
    // DocumentReference categoryDoc = authorsCollection
    //     .doc(model.authorId)
    //     .collection('categories')
    //     .doc(model.categoryId);
    DocumentReference categoryDoc = categoriesCollection.doc(model.categoryId);
    DocumentReference counterDoc = counter.doc('counter');

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      List<String> newHashtags = [];
      List<Map<String, dynamic>> existingHashtagsData = [];

      for (String hashtag in model.hashtags) {
        DocumentReference hashtagDoc = hashtagsCollection.doc(hashtag);
        final snapshot = await transaction.get(hashtagDoc);

        if (snapshot.exists) {
          existingHashtagsData.add(snapshot.data() as Map<String, dynamic>);
        } else {
          newHashtags.add(hashtag);
        }
      }

      for (String hashtag in newHashtags) {
        DocumentReference hashtagDoc = hashtagsCollection.doc(hashtag);

        transaction.set(hashtagDoc, {
          'name': hashtag,
          'keywords': hashtag.allPossibleSubstrings(),
          'totalBlogPosts': 1,
          'popularityFactor': 1,
        });
      }

      for (Map<String, dynamic> hashtagData in existingHashtagsData) {
        DocumentReference hashtagDoc =
            hashtagsCollection.doc(hashtagData['name']);

        transaction.update(hashtagDoc, {
          'totalBlogPosts': FieldValue.increment(1),
          'popularityFactor': FieldValue.increment(1),
        });
      }

      transaction.update(activeBlogPost, {'approvedStatus': 1});
      transaction.update(artistDoc, {
        'totalBlogPosts': FieldValue.increment(1),
        'usedCategories': FieldValue.arrayUnion([model.categoryId])
      });
      transaction
          .update(counterDoc, {'totalBlogPosts': FieldValue.increment(1)});
      transaction
          .update(categoryDoc, {'totalBlogPosts': FieldValue.increment(1)});
    }).then(
      (value) {
        response = FirebaseResponse(true, null);
      },
      onError: (error) {
        FirebaseResponse(false, error.toString());
      },
    );
    return response!;
  }

  Future<FirebaseResponse> rejectBlogPost(BlogPostModel model) async {
    DocumentReference pendingBlogPost = blogPostsCollection.doc(model.id);

    await pendingBlogPost.update({'approvedStatus': -1}).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });
    return response!;
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
    List<BlogPostModel> list = [];

    await blogPostsCollection
        .where('reportCount', isGreaterThan: 0)
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        list.add(BlogPostModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });

    return list;
  }

  Future<FirebaseResponse> deleteAuthorReport(AuthorsModel model) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference doc = authorsCollection.doc(model.id);
    batch.update(doc, {'reportCount': 0});

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });
    return response!;
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
    keywords.addAll(hashtags.map((e) => '#' + e));
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
      'isPremium': isPremium,
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
      'approvedStatus': 1,
    };

    int postCounterIncrementFactor = 1;
    DocumentReference postDoc = blogPostsCollection.doc(postId);
    DocumentReference counterDoc = counter.doc('counter');
    DocumentReference categoryDoc = categoriesCollection.doc(categoryId);

    DocumentReference author =
        authorsCollection.doc(getIt<UserProfileManager>().user!.id);

    if (isUpdate == true) {
      if (post!.status == 1 && status == AvailabilityStatus.deactivated) {
        postCounterIncrementFactor = -1;
      } else if (post.status == 0 && status == AvailabilityStatus.active) {
        postCounterIncrementFactor = 1;
      } else {
        postCounterIncrementFactor = 0;
      }

      List<String> newHashtags = [];
      List<Map<String, dynamic>> existingHashtagsData = [];

      await firestore.runTransaction((transaction) async {
        for (String hashtag in hashtags) {
          DocumentReference hashtagDoc = hashtagsCollection.doc(hashtag);
          final snapshot = await transaction.get(hashtagDoc);

          if (snapshot.exists) {
            existingHashtagsData.add(snapshot.data() as Map<String, dynamic>);
          } else {
            newHashtags.add(hashtag);
          }
        }

        for (String hashtag in newHashtags) {
          DocumentReference hashtagDoc = hashtagsCollection.doc(hashtag);

          transaction.set(hashtagDoc, {
            'name': hashtag,
            'keywords': hashtag.allPossibleSubstrings(),
            'totalBlogPosts': FieldValue.increment(1),
          });
        }

        for (Map<String, dynamic> hashtagData in existingHashtagsData) {
          DocumentReference hashtagDoc =
              hashtagsCollection.doc(hashtagData['name']);

          transaction.update(hashtagDoc, {
            'totalBlogPosts': FieldValue.increment(1),
            'popularityFactor': FieldValue.increment(1),
          });
        }

        transaction.update(postDoc, postJson);
        transaction.update(author, {
          'totalBlogPosts': FieldValue.increment(postCounterIncrementFactor)
        });

        transaction.update(categoryDoc, {
          'totalBlogPosts': FieldValue.increment(postCounterIncrementFactor)
        });

        if (postCounterIncrementFactor != 0) {
          transaction.update(counterDoc, {
            'totalBlogPosts': FieldValue.increment(postCounterIncrementFactor)
          });
        }

      }).then(
        (value) {
          response = FirebaseResponse(true, null);
        },
        onError: (e) {
          response = FirebaseResponse(false, null);
        },
      );
    } else {
      postJson['createdAt'] = FieldValue.serverTimestamp();

      postJson['searchedCount'] = 0;
      postJson['totalDownloads'] = 0;

      List<String> newHashtags = [];
      List<String> existingHashtags = [];

      await firestore.runTransaction((transaction) async {
        for (String hashtag in hashtags) {
          DocumentReference hashtagDoc = hashtagsCollection.doc(hashtag);
          final snapshot = await transaction.get(hashtagDoc);
          if (snapshot.exists) {
            existingHashtags.add(hashtag);
          } else {
            newHashtags.add(hashtag);
          }
        }

        for (String hashtag in newHashtags) {
          DocumentReference hashtagDoc = hashtagsCollection.doc(hashtag);

          transaction.set(hashtagDoc, {
            'name': hashtag,
            'keywords': hashtag.allPossibleSubstrings(),
            'totalBlogPosts': FieldValue.increment(1),
          });
        }

        for (String hashtag in existingHashtags) {
          DocumentReference hashtagDoc = hashtagsCollection.doc(hashtag);

          transaction.update(hashtagDoc, {
            'name': hashtag,
            'keywords': hashtag.allPossibleSubstrings(),
            'totalBlogPosts': FieldValue.increment(1),
          });
        }

        transaction.set(postDoc, postJson);
        transaction
            .update(counterDoc, {'totalBlogPosts': FieldValue.increment(1)});
        transaction.update(author, {'totalBlogPosts': FieldValue.increment(1)});
        transaction
            .update(categoryDoc, {'totalBlogPosts': FieldValue.increment(1)});
      }).then(
        (value) {
          response = FirebaseResponse(true, null);
        },
        onError: (e) {
          response = FirebaseResponse(false, null);
        },
      );
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
      response = FirebaseResponse(false, error.toString());
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
    if (searchModel.status != null) {
      query = query.where("status", isEqualTo: searchModel.status);
    }
    if (searchModel.approvedStatus != null) {
      query =
          query.where("approvedStatus", isEqualTo: searchModel.approvedStatus);
    }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        list.add(BlogPostModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
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

  Future<FirebaseResponse> reportAbuse(
      String id, String name, DataType type) async {
    String reportId = '${id}_${auth.currentUser!.uid}';

    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference doc = reports.doc(reportId);

    var reportData = {
      'id': id,
      'name': name,
      'type': type == DataType.blog ? 1 : 2
    };

    batch.set(doc, reportData);

    if (type == DataType.blog) {
      DocumentReference postDoc = blogPostsCollection.doc(id);
      batch.update(postDoc, {'reportCount': FieldValue.increment(1)});
    } else if (type == DataType.source) {
      DocumentReference sourceDoc = authorsCollection.doc(id);
      batch.update(sourceDoc, {'reportCount': FieldValue.increment(1)});
    }

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });
    return response!;
  }

  Future<FirebaseResponse> sendContactusMessage(
      String name, String email, String phone, String message) async {
    String id = getRandString(15);
    DocumentReference doc = contact.doc(id);
    await doc.set({
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'message': message,
      'status': 1
    }).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });
    return response!;
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
      response = FirebaseResponse(false, error.toString());
    });

    return categoriesList;
  }

  Future<List<AuthorsModel>> searchAuthors(
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

  Future<List<AuthorsModel>> getAllReportedAuthors() async {
    List<AuthorsModel> list = [];

    await authorsCollection
        .where('reportCount', isGreaterThan: 0)
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        list.add(AuthorsModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });

    return list;
  }

  Future<List<Hashtag>> searchHashtags(
      {String? searchText, int? type, List<String>? hashtags}) async {
    List<Hashtag> list = [];

    Query query = hashtagsCollection;

    if (searchText != null) {
      query = query.where("keywords", arrayContainsAny: [searchText]);
    }

    if (hashtags != null && hashtags.isNotEmpty) {
      query = query.where("id", whereIn: hashtags);
    }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        list.add(Hashtag.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });

    return list;
  }

  Future<List<AuthorsModel>> searchAuthorProfiles(
      {String? searchText, int? type}) async {
    List<AuthorsModel> list = [];

    Query query = authorsCollection;

    if (searchText != null) {
      query = query.where("keywords", arrayContainsAny: [searchText]);
    }

    if (type != null) {
      query = query.where("status", isEqualTo: type);
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

  Future<List<UserModel>> searchUserProfiles(
      {String? searchText, int? type}) async {
    List<UserModel> list = [];

    Query query = userCollection;

    if (searchText != null) {
      query = query.where("keywords", arrayContainsAny: [searchText]);
    }
    if (type != null) {
      query = query.where("status", isEqualTo: type);
    }
    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        list.add(UserModel.fromJson(doc.data() as Map<String, dynamic>));
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

  Future<List<PackageModel>> getPackages() async {
    List<PackageModel> list = [];
    await packagesCollection.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        list.add(PackageModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });

    return list;
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
      'totalBlogPosts': 1,
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
    DocumentReference categoryDoc = categoriesCollection.doc(category.id);

    batch.update(categoryDoc, {'status': 0});
    batch.update(counterDoc, {'categories': FieldValue.increment(-1)});

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
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
      response = FirebaseResponse(false, error.toString());
    });

    return categoryList;
  }

  Future<CategoryModel?> getCategory(String id) async {
    CategoryModel? category;

    await categoriesCollection.doc(id).get().then((doc) {
      category = CategoryModel.fromJson(doc.data() as Map<String, dynamic>);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });

    return category;
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

  Future<FirebaseResponse> saveSetting(
      {required String phone,
      required String email,
      required String facebook,
      required String twitter,
      required String aboutUs,
      required String iosInAppId,
      required String androidAppId,
      required String privacyPolicy}) async {
    DocumentReference doc = settings.doc('settings');

    var settingsData = {
      'phone': phone,
      'email': email,
      'facebook': facebook,
      'twitter': twitter,
      'aboutUs': aboutUs,
      'privacyPolicy': privacyPolicy,
      'iOSInAppPurchaseId': iosInAppId,
      'androidInAppPurchaseId': androidAppId
    };

    await doc.set(settingsData).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });

    return response!;
  }

  Future<SettingsModel?> getSettings() async {
    SettingsModel? setting;

    await settings.doc('settings').get().then((doc) {
      setting = SettingsModel.fromJson(doc.data() as Map<String, dynamic>);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });

    return setting;
  }

  Future<List<SupportModel>> getAllSupportMessages() async {
    List<SupportModel> supportTickets = [];

    await contact.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        supportTickets
            .add(SupportModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });

    return supportTickets;
  }

  Future<FirebaseResponse> sendSupportTicketReply({
    required String ticketId,
    required String replyMessage,
  }) async {
    DocumentReference doc = contact.doc(ticketId);

    var reply = {
      'replyMessage': replyMessage,
    };

    await doc.update(reply).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });

    return response!;
  }

  Future<FirebaseResponse> markRequestAsClosed({
    required String ticketId,
  }) async {
    DocumentReference doc = contact.doc(ticketId);
    var reply = {
      'status': 2,
    };

    await doc.update(reply).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });

    return response!;
  }

  /////////////////////////////////************* Packages *************////////////////////////////////////////

  Future<FirebaseResponse> insertPackage({
    PackageModel? package,
    required String id,
    required String name,
    required String price,
    required String iOSInAppId,
    required String androidInAppId,
  }) async {
    DocumentReference doc = packagesCollection.doc(id);

    var json = {
      'id': id,
      'name': name,
      'price': price,
      'in_app_purchase_id_ios': iOSInAppId,
      'in_app_purchase_id_android': androidInAppId,
    };

    if (package != null) {
      await doc.update(json).then((value) {
        response = FirebaseResponse(true, null);
      }).catchError((error) {
        response = FirebaseResponse(false, error.toString());
      });
    } else {
      await doc.set(json).then((value) {
        response = FirebaseResponse(true, null);
      }).catchError((error) {
        response = FirebaseResponse(false, error.toString());
      });
    }

    return response!;
  }

  Future<List<PackageModel>> getAllPackages() async {
    List<PackageModel> list = [];

    Query query = packagesCollection;

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        list.add(PackageModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });

    return list;
  }

  Future<FirebaseResponse> deletePackage(PackageModel package) async {
    DocumentReference doc = packagesCollection.doc(package.id);

    await doc.delete().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });
    return response!;
  }
}
