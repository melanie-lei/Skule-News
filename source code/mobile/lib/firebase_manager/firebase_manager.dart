import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:skule_news_mobile/model/setting.dart';

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

  FirebaseResponse(this.status, this.message, {this.result});
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

  CollectionReference reports =
      FirebaseFirestore.instance.collection('reports');

  CollectionReference contact =
      FirebaseFirestore.instance.collection('contact');

  CollectionReference counter =
      FirebaseFirestore.instance.collection('counter');

  CollectionReference settingsCollection =
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
      response = FirebaseResponse(false, error.toString());
    });
    return response!;
  }

  Future<FirebaseResponse> updateUser({String? name, String? bio}) async {
    DocumentReference doc =
        userCollection.doc(FirebaseAuth.instance.currentUser!.uid);

    await doc.update({'name': name, 'bio': bio}).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });
    return response!;
  }

  loginAnonymously(VoidCallback callback) async {
    EasyLoading.show(status: LocalizationString.loading);
    await auth.signInAnonymously().then((value) => callback());
    EasyLoading.dismiss();
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
        await insertUser(id: user.uid, name: name, email: email);
        response = FirebaseResponse(true, null);
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
        print(doc.data());
        user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }).catchError((error) {
        print(error);
        response = FirebaseResponse(false, error.toString());
      });
    }).catchError((error) {});

    return user;
  }

  Future<UserModel?> getUser(String id) async {
    UserModel? user;
    await userCollection.doc(id).get().then((doc) {
      user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });

    return user;
  }

  Future<FirebaseResponse> updateUserSubscription(
      {required String receipt, required int purchaseDate}) async {
    DocumentReference userDoc =
        userCollection.doc(FirebaseAuth.instance.currentUser!.uid);

    await userDoc.update({
      'subscriptionReceipt': receipt,
      'isPro': true,
      'subscriptionDate': purchaseDate
    }).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });
    return response!;
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
      // response = FirebaseResponse(false, error.toString(;
    });
    return path;
  }

  Future<AuthorModel?> getAuthorDetail(String id) async {
    AuthorModel? source;
    await authorsCollection.doc(id).get().then((doc) {
      source = AuthorModel.fromJson(doc.data() as Map<String, dynamic>);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });

    return source;
  }

  Future<List<CategoryModel>> getAuthorCategories(String id) async {
    List<CategoryModel> list = [];
    await authorsCollection
        .doc(id)
        .collection('categories')
        .where('status', isEqualTo: 1)
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
      response = FirebaseResponse(false, error.toString());
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
      response = FirebaseResponse(false, error.toString());
    });
    return response!;
  }

  Future<FirebaseResponse> followUser(
      {required String id, required bool isAuthor}) async {
    getIt<UserProfileManager>().user!.likedPost.add(id);

    final batch = FirebaseFirestore.instance.batch();
    DocumentReference currentUserDoc =
        userCollection.doc(auth.currentUser!.uid); //.collection('following');

    batch.update(currentUserDoc, {
      'followingProfiles': FieldValue.arrayUnion([id]),
    });

    if (isAuthor) {
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
      response = FirebaseResponse(false, error.toString());
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
      response = FirebaseResponse(false, error.toString());
    });
    return response!;
  }

  Future<FirebaseResponse> followHashtag({required Hashtag hashtag}) async {
    getIt<UserProfileManager>().user!.followingHashtags.add(hashtag.name);

    final batch = FirebaseFirestore.instance.batch();
    DocumentReference currentUserDoc =
        userCollection.doc(auth.currentUser!.uid); //.collection('following');

    batch.update(currentUserDoc, {
      'followingHashtags': FieldValue.arrayUnion([hashtag.name]),
    });

    DocumentReference itemDoc = hashtagsCollection.doc(hashtag.name);
    batch.update(itemDoc, {
      'totalFollowers': FieldValue.increment(1),
      'popularityFactor': FieldValue.increment(2)
    });

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });
    return response!;
  }

  Future<FirebaseResponse> unFollowHashtag({required Hashtag hashtag}) async {
    getIt<UserProfileManager>().user!.followingHashtags.remove(hashtag.name);

    final batch = FirebaseFirestore.instance.batch();
    DocumentReference currentUserDoc =
        userCollection.doc(auth.currentUser!.uid); //.collection('following');

    batch.update(currentUserDoc, {
      'followingHashtags': FieldValue.arrayRemove([hashtag.name]),
    });

    DocumentReference itemDoc = hashtagsCollection.doc(hashtag.name);
    batch.update(itemDoc, {
      'totalFollowers': FieldValue.increment(-1),
      'popularityFactor': FieldValue.increment(-2)
    });

    await batch.commit().then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
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
  //     response = FirebaseResponse(false, error.toString(;
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
  //     response = FirebaseResponse(false, error.toString(;
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
      response = FirebaseResponse(false, error.toString());
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
      response = FirebaseResponse(false, error.toString());
    });
    return response!;
  }

  Future<FirebaseResponse> increasePostSearchCount(BlogPostModel news) async {
    DocumentReference postDoc = blogPostsCollection.doc(news.id);

    await postDoc.update({
      'searchedCount': FieldValue.increment(1),
      'popularityFactor': FieldValue.increment(1)
    }).then((value) {
      response = FirebaseResponse(true, null);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });
    return response!;
  }

  Future<FirebaseResponse> increaseSourceSearchCount(AuthorModel source) async {
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

  Future<FirebaseResponse> searchPosts(
      {required PostSearchParamModel searchModel}) async {
    List<BlogPostModel> list = [];

    Query query = blogPostsCollection;

    List<String> searchKeywords = [];

    if (searchModel.searchText != null) {
      query =
          query.where("keywords", arrayContainsAny: [searchModel.searchText]);
    }
    if (searchModel.categoryId != null) {
      searchKeywords = [searchModel.categoryId!];
      // query = query.where("keywords", arrayContainsAny: [searchModel.categoryId]);
    }
    if (searchModel.categoryIds != null) {
      searchKeywords.addAll(searchModel.categoryIds!);
      // query = query.where("keywords", arrayContainsAny: searchModel.categoryIds);
    }
    if (searchModel.hashtags != null) {
      searchKeywords.addAll(searchModel.hashtags!);
      // query = query.where("keywords", arrayContainsAny: searchModel.hashtags);
    }
    if (searchModel.userId != null) {
      query = query.where('authorId', isEqualTo: searchModel.userId);
    }
    if (searchModel.userIds != null) {
      query = query.where("authorId", whereIn: searchModel.userIds);
    }
    if (searchModel.postIds != null) {
      query = query.where("id", whereIn: searchModel.postIds);
    }

    query = query.where("approvedStatus", isEqualTo: 1);
    query = query.where("status", isEqualTo: 1);
    query = query.orderBy("createdAt", descending: true);
    // query = query.limit(10);
    // if (searchModel.startsAt != null) {
    //   query = query.startAt([searchModel.startsAt]);
    // }

    if (searchKeywords.isNotEmpty) {
      if (searchKeywords.length < 10) {
        query = query.where("keywords",
            arrayContainsAny: searchKeywords.toSet().toList());
      } else {
        searchKeywords.shuffle();
        searchKeywords = searchKeywords.sublist(0, 10);
        query = query.where("keywords",
            arrayContainsAny: searchKeywords.toSet().toList());
      }
    }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        list.add(BlogPostModel.fromJson(doc.data() as Map<String, dynamic>));
      }
      // final lastVisibleDoc = snapshot.docs[snapshot.size - 1];

      response = FirebaseResponse(true, null, result: list);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });

    return response!;
  }

  Future<FirebaseResponse> followingUsersPosts(
      {required PostSearchParamModel searchModel}) async {
    List<BlogPostModel> list = [];

    Query query = blogPostsCollection;
    if (searchModel.userIds != null) {
      query = query.where("authorId", whereIn: searchModel.userIds);
    }
    query = query.where("approvedStatus", isEqualTo: 1);
    query = query.where("status", isEqualTo: 1);
    query = query.orderBy("createdAt", descending: true);
    // query = query.limit(10);
    // if (searchModel.startsAt != null) {
    //   query = query.startAt([searchModel.startsAt]);
    // }

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        list.add(BlogPostModel.fromJson(doc.data() as Map<String, dynamic>));
      }
      // final lastVisibleDoc = snapshot.docs[snapshot.size - 1];

      response = FirebaseResponse(true, null, result: list);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });

    return response!;
  }

  Future<FirebaseResponse> getFeaturedPosts(
      PostSearchParamModel searchParamModel) async {
    List<BlogPostModel> list = [];

    Query query = blogPostsCollection.where('featured', isEqualTo: true);
    query = query.where("status", isEqualTo: 1);
    query = query.orderBy("createdAt", descending: true);
    // query = query.limit(10);
    // if (searchParamModel.startsAt != null) {
    //   query = query.startAt([searchParamModel.startsAt]);
    // }
    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        list.add(BlogPostModel.fromJson(doc.data() as Map<String, dynamic>));
      }
      // final lastVisibleDoc = snapshot.docs[snapshot.size - 1];

      response = FirebaseResponse(true, null, result: list);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });

    return response!;
  }

  Future<FirebaseResponse> reportAbuse(
      String id, String name, DataType type) async {
    String reportId = '${id}_${auth.currentUser!.uid}';

    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference doc = reports.doc(reportId);

    var reportData = {
      'id': id,
      'name': name,
      'createdAt': FieldValue.serverTimestamp(),
      'type': type == DataType.blogPost ? 1 : 2
    };

    batch.set(doc, reportData);

    if (type == DataType.blogPost) {
      DocumentReference postDoc = blogPostsCollection.doc(id);
      batch.update(postDoc, {'reportCount': FieldValue.increment(1)});
    } else if (type == DataType.author) {
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
    query = query.where("status", isEqualTo: 1);

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

  Future<List<AuthorModel>> searchAuthors(
      {String? searchText, int? type, List<String>? sourceIds}) async {
    List<AuthorModel> list = [];

    Query query = authorsCollection;

    if (searchText != null) {
      query = query.where("keywords", arrayContainsAny: [searchText]);
    }

    if (sourceIds != null && sourceIds.isNotEmpty) {
      query = query.where("id", whereIn: sourceIds);
    }
    query = query.where("status", isEqualTo: 1);

    await query.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        list.add(AuthorModel.fromJson(doc.data() as Map<String, dynamic>));
      }
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
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
  //     response = FirebaseResponse(false, error.toString(;
  //   });
  //
  //   return list;
  // }

  Future<Hashtag?> getHashtagDetail(String id) async {
    Hashtag? hashtag;
    await hashtagsCollection.doc(id).get().then((doc) {
      hashtag = Hashtag.fromJson(doc.data() as Map<String, dynamic>);
    }).catchError((error) {
      response = FirebaseResponse(false, error.toString());
    });

    return hashtag;
  }

  Future<List<Hashtag>> searchHashtags(
      {String? searchText,
      int? type,
      List<String>? hashtags,
      bool? isTrending}) async {
    List<Hashtag> list = [];

    Query query = hashtagsCollection;

    if (searchText != null) {
      query = query.where("keywords", arrayContainsAny: [searchText]);
    }

    if (isTrending == true) {
      query = query.orderBy("popularityFactor", descending: true).limit(50);
    }

    if (hashtags != null && hashtags.isNotEmpty) {
      query = query.where("name", whereIn: hashtags);
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

  Future<List<CommentModel>> getComments({required String posId}) async {
    List<CommentModel> list = [];

    Query query = commentsCollection
        .where("postId", isEqualTo: posId)
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

  Future<SettingsModel?> getSettings() async {
    SettingsModel? setting;

    await settingsCollection.doc('settings').get().then((doc) async {
      setting = SettingsModel.fromJson(doc.data() as Map<String, dynamic>);
    }).catchError((error) {});

    return setting;
  }
}
