import 'package:flutter/material.dart';
import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    // Replace with actual values
    options: const FirebaseOptions(
        apiKey: "AIzaSyDf5AWPJF4hhQly7P_U0uu6g17HhxbRR8U",
        authDomain: "musicy-46533.firebaseapp.com",
        projectId: "musicy-46533",
        storageBucket: "musicy-46533.appspot.com",
        messagingSenderId: "226596893656",
        appId: "1:226596893656:web:2ae630fb0a954aa138b8ad",
        measurementId: "G-LE910VELB1"
    ),
  );

  await FirebaseAuth.instance.authStateChanges().first;
  await setupServiceLocator();

  await getIt<UserProfileManager>().refreshProfile();

  Get.put(DashboardController());
  Get.put(BlogsController());
  Get.put(AddBlogController());
  Get.put(PendingBlogsController());
  Get.put(CategoryController());
  Get.put(CommentsController());
  Get.put(BlogPostDetailController());
  Get.put(AuthorController());
  Get.put(AddCategoryController());
  Get.put(ChangePasswordController());
  Get.put(LoginController());
  Get.put(SideMenuContainer());
  Get.put(UserController());
  Get.put(MainScreenContainer());

  setPathUrlStrategy();

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
        path: 'assets/translations', // <-- change the path of the translation files
        fallbackLocale: const Locale('en', 'US'),
        child: const MainApp()
    ),
  );
}

class MainApp extends StatelessWidget{
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: EasyLoading.init(),
      home: FirebaseAuth.instance.currentUser?.uid == null ? const AskForLogin() : const MainScreen(),
      // home:  const MainScreen(),

    );
  }
}
