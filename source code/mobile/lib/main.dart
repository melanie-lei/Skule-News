import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await MobileAds.instance.initialize();

  await setupServiceLocator();

  await Firebase.initializeApp();
  await getIt<UserProfileManager>().refreshProfile();
  bool isDarkTheme = await SharedPrefs().isDarkMode();

  Get.changeThemeMode(isDarkTheme ? ThemeMode.dark : ThemeMode.light);

  Get.put(DashboardController());
  Get.put(CategoryController());
  Get.put(LoginController());
  Get.put(MainScreenController());
  Get.put(SearchController());
  Get.put(UserController());
  Get.put(RecommendationController());
  Get.put(CommentsController());
  Get.put(PostCardController());
  Get.put(TrendingHashtagController());
  Get.put(NewsDetailController());
  Get.put(SeeAllPostsController());
  Get.put(HashtagController());
  Get.put(AuthorController());
  // Get.put(LocationController());
  Get.put(FollowingController());
  Get.put(MyAccountController());
  Get.put(SubscriptionPackageController());
  Get.put(SavedPostsController());

  bool onBoardingShown = await SharedPrefs().isOnBoardingShown();

  runApp(
    EasyLocalization(
        useOnlyLangCode: true,
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ar', 'AE'),
          Locale('ar', 'DZ'),
          Locale('de', 'DE'),
          Locale('fr', 'FR'),
          Locale('ru', 'RU')
        ],
        path: 'assets/translations',
        // <-- change the path of the translation files
        fallbackLocale: const Locale('en', 'US'),
        child: MainApp(
          onBoardingShown: onBoardingShown,
        )),
  );
}

class MainApp extends StatefulWidget {
  final bool onBoardingShown;

  const MainApp({Key? key, required this.onBoardingShown}) : super(key: key);

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // theme: ThemeData(
      //   fontFamily: ,
      // ),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      // localizationsDelegates: context.localizationDelegates,
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
        supportedLocales: const [
          Locale("fa", "IR"),
          Locale("en", "US"),
          Locale('ar', 'AE')
        ],
        // locale: const Locale("fa", "IR"),
      // supportedLocales: context.supportedLocales,
      locale: context.locale,
      // navigatorKey: NoomiKeys.navKey,
      builder: EasyLoading.init(),
      // home: FirebaseAuth.instance.currentUser?.uid == null ? const LoginScreen() : const MainScreen(),
      home: widget.onBoardingShown == true
          ? const MainScreen()
          : const OnBoardingScreen(),
    );
  }
}
