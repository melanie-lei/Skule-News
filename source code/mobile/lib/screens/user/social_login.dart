import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:get/get.dart';

// import 'package:skule_news_mobile/screens/user/instagram_view.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'dart:io' show Platform;

String generateNonce([int length = 32]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

/// Returns the sha256 hash of [input] in hex notation.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

class SocialLogin extends StatefulWidget {
  const SocialLogin({Key? key}) : super(key: key);

  @override
  _SocialLoginState createState() => _SocialLoginState();
}

class _SocialLoginState extends State<SocialLogin> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: loginOptions(),
    ).hp(40);
  }

  List<Widget> loginOptions() {
    List<Widget> options = [
      Container(
          color: Theme.of(context).hoverColor,
          height: 40,
          width: 40,
          child: Center(
              child: Image.asset(
            'assets/images/gmailicon.png',
            height: 20,
            width: 20,
          ))).round(5).ripple(() {
        signInWithGoogle();
      }),
      Container(
          color: Theme.of(context).hoverColor,
          height: 40,
          width: 40,
          child: Center(
              child: Image.asset(
            'assets/images/facebook.png',
            height: 20,
            width: 20,
          ))).round(5).ripple(() {
        fbSignInAction();
      }),
      Container(
          color: Theme.of(context).hoverColor,
          height: 40,
          width: 40,
          child: Center(
              child: Image.asset(
            'assets/images/phone.png',
            height: 20,
            width: 20,
          ))).round(5).ripple(() {
        Get.to(() => const LoginViaPhone());
      }),
    ];

    if (Platform.isIOS) {
      options.insert(
          0,
          Container(
              color: Theme.of(context).hoverColor,
              height: 40,
              width: 40,
              child: Center(
                  child: Image.asset(
                'assets/images/apple.png',
                color: Theme.of(context).primaryColor,
                height: 20,
                width: 20,
              ))).round(5).ripple(() {
            _handleAppleSignIn();
          }));
    }

    return options;
  }

  void signInWithGoogle() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleSignInAuthentication =
        await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );

    UserCredential credentials =
        await FirebaseAuth.instance.signInWithCredential(credential);
    String name = credentials.user?.displayName ?? '';
    String socialId = credentials.user?.uid ?? '';
    String email = credentials.user?.email ?? '';

    socialLogin(
        credentials: credentials, userId: socialId, name: name, email: email);
  }

  void fbSignInAction() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    print(loginResult.message);
    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    UserCredential credentials = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);

    String name = credentials.user?.displayName ?? '';
    String socialId = credentials.user?.uid ?? '';
    String email = credentials.user?.email ?? '';

    socialLogin(
        credentials: credentials, userId: socialId, name: name, email: email);
  }

  void socialLogin(
      {required UserCredential credentials,
      required String userId,
      String? name,
      String? email}) async {
    if (credentials.additionalUserInfo!.isNewUser == true) {
      getIt<FirebaseManager>()
          .insertUser(id: userId, name: name)
          .then((response) async {
        if (response.status == true) {
          await getIt<UserProfileManager>().refreshProfile();

          if (getIt<UserProfileManager>().user!.status == 1) {
            Get.offAll(() => const ChooseCategories());
          } else {
            getIt<UserProfileManager>().logout();
            AppUtil.showToast(
                message: LocalizationString.accountDeleted, isSuccess: false);
          }
        } else {
          AppUtil.showToast(
              message: LocalizationString.errorMessage, isSuccess: false);
        }
      });
    } else {
      await getIt<UserProfileManager>().refreshProfile();
      if (getIt<UserProfileManager>().user!.status == 1) {
        Get.offAll(() => const MainScreen());
      } else {
        getIt<UserProfileManager>().logout();
        AppUtil.showToast(
            message: LocalizationString.accountDeleted, isSuccess: false);
      }
    }
  }

  Future<void> _handleAppleSignIn() async {
    EasyLoading.show(status: 'loading...');

    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.

    UserCredential credentials =
        await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    EasyLoading.dismiss();

    socialLogin(
        credentials: credentials,
        userId: credentials.user!.uid,
        name: credentials.user!.displayName!,
        email: credentials.user!.email!);
  }
}
