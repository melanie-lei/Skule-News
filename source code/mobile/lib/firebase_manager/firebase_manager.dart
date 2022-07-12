import 'dart:math';
import 'dart:convert';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  UserCredential? credential;

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

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<FirebaseResponse> insertUser(
      {required String id, String? name, String? phone, String? email}) async {
    final batch = FirebaseFirestore.instance.batch();
    DocumentReference doc = userCollection.doc(id);
    DocumentReference counterDoc = counter.doc('counter');

    batch.set(doc,
        {'id': id, 'name': name, 'phone': phone, 'status': 1, 'email': email});
    batch.update(counterDoc, {'readers': FieldValue.increment(1)});

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> updateUser({String? name, String? bio}) async {
    DocumentReference doc =
        userCollection.doc(FirebaseAuth.instance.currentUser!.uid);

    await doc.update({'name': name, 'bio': bio}).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  loginAnonymously() async {
    await auth.signInAnonymously();
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
        await insertUser(id: user.uid, name: name, email: email);
      }
    } catch (error) {
      response = FirebaseResponse(false, error.toString());
    }

    return response!;
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
      response!.credential = userCredential;
    } catch (error) {
      response =
          FirebaseResponse(false, LocalizationString.userNameOrPasswordIsWrong);
      response!.credential = null;
    }

    return response!;
  }

  loginViaPhone(
      {required String phoneNumber,
      required Function(String) verificationIdHandler,
      required Function(String) verificationFailedHandler}) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        // if (e.code == 'invalid-phone-number') {}
        verificationFailedHandler('Invalid phone number');
      },
      codeSent: (String verificationId, int? resendToken) {
        verificationIdHandler(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  verifyOTP(String smsCode, String verificationID,
      Function(bool, bool) callback) async {
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: smsCode);

    // Sign the user in (or link) with the credential
    UserCredential userCredential = await auth.signInWithCredential(credential);

    if (userCredential.user != null) {
      if (userCredential.additionalUserInfo?.isNewUser == true) {
        await insertUser(
            id: userCredential.user!.uid,
            name: '',
            email: '',
            phone: userCredential.user!.phoneNumber!);

        callback(true, true);
      } else {
        callback(true, false);
      }
      getIt<UserProfileManager>().refreshProfile();
    } else {
      callback(false, false);
    }
  }

  Future<UserModel?> getCurrentUser(String id) async {
    UserModel? user;

    await userCollection
        .doc(id)
        .update({'todayDate': FieldValue.serverTimestamp()}).then((doc) async {
      await userCollection.doc(id).get().then((doc) {
        user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }).catchError((error) {
        response = FirebaseResponse(false, error);
      });
    }).catchError((error) {});

    return user;
  }

  Future<UserModel?> getUser(String id) async {
    UserModel? user;
    await userCollection.doc(id).get().then((doc) {
      user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return user;
  }

  Future<FirebaseResponse> updateUserSubscription(
      {required int numberOfDays, required String subscriptionTerm}) async {
    DocumentReference userDoc =
        userCollection.doc(FirebaseAuth.instance.currentUser!.uid);

    await userDoc.update({
      'numberOfDays': numberOfDays,
      'subscriptionTerm': subscriptionTerm,
      'subscriptionDate': FieldValue.serverTimestamp()
    }).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
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

  Future<String> updateProfileImage(File imageFile) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef =
        storageRef.child("${FirebaseAuth.instance.currentUser!.uid}.jpg");

    await imageRef.putFile(imageFile);
    String path = await imageRef.getDownloadURL();

    DocumentReference userDoc =
        userCollection.doc(FirebaseAuth.instance.currentUser!.uid);

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

  Future<NewsSourceModel?> getSourceDetail(String id) async {
    NewsSourceModel? source;
    await authorsCollection.doc(id).get().then((doc) {
      source = NewsSourceModel.fromJson(doc.data() as Map<String, dynamic>);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
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
      response = FirebaseResponse(false, error);
    });

    return list;
  }

  Future<FirebaseResponse> likePost(String id) async {
    getIt<UserProfileManager>().user!.likedPost.add(id);

    final batch = FirebaseFirestore.instance.batch();
    DocumentReference currentUserDoc =
        userCollection.doc(auth.currentUser!.uid); //.collection('following');
    DocumentReference itemDoc = blogPostsCollection.doc(id);

    batch.update(currentUserDoc, {
      'likedPosts': FieldValue.arrayUnion([id]),
    });
    batch.update(itemDoc, {
      'totalLikes': FieldValue.increment(1),
      'popularityFactor': FieldValue.increment(2)
    });

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> unlikePost(String id) async {
    getIt<UserProfileManager>().user!.likedPost.remove(id);

    final batch = FirebaseFirestore.instance.batch();
    DocumentReference currentUserDoc =
        userCollection.doc(auth.currentUser!.uid); //.collection('following');
    DocumentReference itemDoc = blogPostsCollection.doc(id);

    batch.update(currentUserDoc, {
      'likedPosts': FieldValue.arrayRemove([id]),
    });
    batch.update(itemDoc, {
      'totalLikes': FieldValue.increment(-1),
      'popularityFactor': FieldValue.increment(-2)
    });

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> followUser(
      {required String id, required bool isSource}) async {
    getIt<UserProfileManager>().user!.likedPost.add(id);

    final batch = FirebaseFirestore.instance.batch();
    DocumentReference currentUserDoc =
        userCollection.doc(auth.currentUser!.uid); //.collection('following');

    batch.update(currentUserDoc, {
      'followingProfiles': FieldValue.arrayUnion([id]),
    });

    if (isSource) {
      DocumentReference itemDoc = authorsCollection.doc(id);
      batch.update(itemDoc, {
        'totalFollowers': FieldValue.increment(1),
        'popularityFactor': FieldValue.increment(2)
      });
    } else {
      DocumentReference itemDoc = userCollection.doc(id);
      batch.update(itemDoc, {
        'totalFollowers': FieldValue.increment(1),
        'popularityFactor': FieldValue.increment(2)
      });
    }

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> unFollowUser(
      {required String id, required bool isSource}) async {
    getIt<UserProfileManager>().user!.likedPost.remove(id);

    final batch = FirebaseFirestore.instance.batch();
    DocumentReference currentUserDoc =
        userCollection.doc(auth.currentUser!.uid); //.collection('following');

    batch.update(currentUserDoc, {
      'followingProfiles': FieldValue.arrayRemove([id]),
    });
    if (isSource) {
      DocumentReference itemDoc = authorsCollection.doc(id);
      batch.update(itemDoc, {
        'totalFollowers': FieldValue.increment(-1),
        'popularityFactor': FieldValue.increment(-2)
      });
    } else {
      DocumentReference itemDoc = userCollection.doc(id);
      batch.update(itemDoc, {
        'totalFollowers': FieldValue.increment(-1),
        'popularityFactor': FieldValue.increment(-2)
      });
    }

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> followHashtag({required String id}) async {
    getIt<UserProfileManager>().user!.followingHashtags.add(id);

    final batch = FirebaseFirestore.instance.batch();
    DocumentReference currentUserDoc =
        userCollection.doc(auth.currentUser!.uid); //.collection('following');

    batch.update(currentUserDoc, {
      'followingHashtags': FieldValue.arrayUnion([id]),
    });

    DocumentReference itemDoc = hashtagsCollection.doc(id);
    batch.update(itemDoc, {
      'totalFollowers': FieldValue.increment(1),
      'popularityFactor': FieldValue.increment(2)
    });

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> unFollowHashtag({required String id}) async {
    getIt<UserProfileManager>().user!.followingHashtags.remove(id);

    final batch = FirebaseFirestore.instance.batch();
    DocumentReference currentUserDoc =
        userCollection.doc(auth.currentUser!.uid); //.collection('following');

    batch.update(currentUserDoc, {
      'followingHashtags': FieldValue.arrayRemove([id]),
    });

    DocumentReference itemDoc = hashtagsCollection.doc(id);
    batch.update(itemDoc, {
      'totalFollowers': FieldValue.increment(-1),
      'popularityFactor': FieldValue.increment(-2)
    });

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  // Future<FirebaseResponse> followLocation({required String id}) async {
  //   getIt<UserProfileManager>().user!.followingLocations.add(id);
  //
  //   final batch = FirebaseFirestore.instance.batch();
  //   DocumentReference currentUserDoc =
  //       userCollection.doc(auth.currentUser!.uid); //.collection('following');
  //
  //   batch.update(currentUserDoc, {
  //     'followingLocations': FieldValue.arrayUnion([id]),
  //   });
  //
  //   DocumentReference itemDoc = newsLocationCollection.doc(id);
  //   batch.update(itemDoc, {
  //     'totalFollowers': FieldValue.increment(1),
  //     'popularityFactor': FieldValue.increment(2)
  //   });
  //
  //   await batch.commit().then((value) {
  //     response = FirebaseResponse(true, null);
  //   }).catchError((error) {
  //     response = FirebaseResponse(false, error);
  //   });
  //   return response!;
  // }
  //
  // Future<FirebaseResponse> unFollowLocation({required String id}) async {
  //   getIt<UserProfileManager>().user!.followingLocations.remove(id);
  //
  //   final batch = FirebaseFirestore.instance.batch();
  //   DocumentReference currentUserDoc =
  //       userCollection.doc(auth.currentUser!.uid); //.collection('following');
  //
  //   batch.update(currentUserDoc, {
  //     'followingLocations': FieldValue.arrayRemove([id]),
  //   });
  //
  //   DocumentReference itemDoc = newsLocationCollection.doc(id);
  //   batch.update(itemDoc, {
  //     'totalFollowers': FieldValue.increment(-1),
  //     'popularityFactor': FieldValue.increment(-2)
  //   });
  //
  //   await batch.commit().then((value) {
  //     response = FirebaseResponse(true, null);
  //   }).catchError((error) {
  //     response = FirebaseResponse(false, error);
  //   });
  //   return response!;
  // }

  Future<FirebaseResponse> savePost(String id) async {
    getIt<UserProfileManager>().user!.savedPost.add(id);

    final batch = FirebaseFirestore.instance.batch();
    DocumentReference currentUserDoc =
        userCollection.doc(auth.currentUser!.uid); //.collection('following');
    DocumentReference itemDoc = blogPostsCollection.doc(id);

    batch.update(currentUserDoc, {
      'savedPosts': FieldValue.arrayUnion([id]),
    });
    batch.update(itemDoc, {
      'totalSaved': FieldValue.increment(1),
      'popularityFactor': FieldValue.increment(2)
    });

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> removeSavedPost(String id) async {
    getIt<UserProfileManager>().user!.savedPost.remove(id);

    final batch = FirebaseFirestore.instance.batch();
    DocumentReference currentUserDoc =
        userCollection.doc(auth.currentUser!.uid); //.collection('following');
    DocumentReference itemDoc = blogPostsCollection.doc(id);

    batch.update(currentUserDoc, {
      'savedPosts': FieldValue.arrayRemove([id]),
    });
    batch.update(itemDoc, {
      'totalSaved': FieldValue.increment(-1),
      'popularityFactor': FieldValue.increment(-2)
    });

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> increasePostSearchCount(NewsModel news) async {
    DocumentReference postDoc = blogPostsCollection.doc(news.id);

    await postDoc.update({
      'searchedCount': FieldValue.increment(1),
      'popularityFactor': FieldValue.increment(1)
    }).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> increaseSourceSearchCount(
      NewsSourceModel source) async {
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

  Future<List<BannerModel>> getAllBanners() async {
    List<BannerModel> bannersList = [];

    await banners.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        bannersList
            .add(BannerModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return bannersList;
  }

  Future<List<NewsModel>> searchPosts(
      {required PostSearchParamModel searchModel}) async {
    List<NewsModel> list = [];
    // List<String> copiedPostsId = List.from(postIds ?? []);

    Query query = blogPostsCollection;

    if (searchModel.searchText != null) {
      query =
          query.where("keywords", arrayContainsAny: [searchModel.searchText]);
    }
    // if (isVideo != null) {
    //   query = query.where("contentType", isEqualTo: isVideo == true ? 2 : 1);
    // }
    if (searchModel.categoryId != null) {
      query = query.where('categoryId', isEqualTo: searchModel.categoryId);
    }
    if (searchModel.categoryIds != null) {
      query = query.where('categoryId', whereIn: searchModel.categoryIds);
    }
    // if (locationId != null) {
    //   query = query.where('locationId', isEqualTo: locationId);
    // }
    if (searchModel.hashtags != null) {
      query = query.where("hashtags", arrayContainsAny: searchModel.hashtags);
    }
    if (searchModel.userId != null) {
      query = query.where('authorId', isEqualTo: searchModel.userId);
    }
    if (searchModel.userIds != null) {
      query = query.where("authorId", whereIn: searchModel.userIds);
    }

    // if (postIds != null && postIds.isNotEmpty) {
    //   query = query.where("id", whereIn: copiedPostsId);
    // }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        list.add(NewsModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return list;
  }

  Future<List<NewsModel>> getFeaturedPosts() async {
    List<NewsModel> list = [];

    Query query = blogPostsCollection.where('featured', isEqualTo: true);

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        list.add(NewsModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
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
      'type': type == DataType.news ? 1 : 2
    };

    batch.set(doc, reportData);

    if (type == DataType.news) {
      DocumentReference postDoc = blogPostsCollection.doc(id);
      batch.update(postDoc, {'reportCount': FieldValue.increment(1)});
    } else if (type == DataType.source) {
      DocumentReference sourceDoc = authorsCollection.doc(id);
      batch.update(sourceDoc, {'reportCount': FieldValue.increment(1)});
    }

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
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
      response = FirebaseResponse(false, error);
    });
    return response!;
  }

  Future<FirebaseResponse> updateCategoryPref(
      {required List<String> ids}) async {
    getIt<UserProfileManager>().user!.followingCategories = ids;

    final batch = FirebaseFirestore.instance.batch();
    DocumentReference currentUserDoc =
        userCollection.doc(auth.currentUser!.uid); //.collection('following');

    batch.update(currentUserDoc, {
      'followingCategories': ids,
    });

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error);
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
      response = FirebaseResponse(false, error);
    });

    return categoriesList;
  }

  Future<List<NewsSourceModel>> searchSources(
      {String? searchText, int? type, List<String>? sourceIds}) async {
    List<NewsSourceModel> list = [];

    Query query = authorsCollection;

    if (searchText != null) {
      query = query.where("keywords", arrayContainsAny: [searchText]);
    }

    if (sourceIds != null && sourceIds.isNotEmpty) {
      query = query.where("id", whereIn: sourceIds);
    }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        list.add(NewsSourceModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return list;
  }

  // Future<List<NewsLocation>> searchLocations(
  //     {String? searchText, int? type, List<String>? locationIds}) async {
  //   List<NewsLocation> list = [];
  //
  //   Query query = newsLocationCollection;
  //
  //   if (searchText != null) {
  //     query = query.where("keywords", arrayContainsAny: [searchText]);
  //   }
  //
  //   if (locationIds != null && locationIds.isNotEmpty) {
  //     query = query.where("id", whereIn: locationIds);
  //   }
  //
  //   await query.get().then((QuerySnapshot snapshot) {
  //     for (var doc in snapshot.docs) {
  //       list.add(NewsLocation.fromJson(doc.data() as Map<String, dynamic>));
  //     }
  //   }).catchError((error) {
  //     response = FirebaseResponse(false, error);
  //   });
  //
  //   return list;
  // }

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
      response = FirebaseResponse(false, error);
    });

    return list;
  }

  Future<List<UserModel>> searchProfiles(
      {String? searchText, int? type}) async {
    List<UserModel> list = [];

    Query query = userCollection;

    if (searchText != null) {
      query = query.where("keywords", arrayContainsAny: [searchText]);
    }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        list.add(UserModel.fromJson(doc.data() as Map<String, dynamic>));
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

  Future<List<PackageModel>> getPackages() async {
    List<PackageModel> list = [];
    await packagesCollection.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        print(doc.data());
        list.add(PackageModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error);
    });

    return list;
  }
}