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
        apiKey: "AIzaSyC7C-de4bewAn2W7I8p9cIB3Q_y7Cef0Sc",
        authDomain: "skule-news.firebaseapp.com",
        projectId: "skule-news",
        storageBucket: "skule-news.appspot.com",
        messagingSenderId: "472349549744",
        appId: "1:472349549744:web:2f3177dc0ef7c496f40775",
        measurementId: "G-ZVTL9XD6EX"
    ),
  );

  await FirebaseAuth.instance.authStateChanges().first;
  await setupServiceLocator();

  await getIt<UserProfileManager>().refreshProfile();

  Get.put(DashboardController());
  Get.put(BlogsController());
  Get.put(UsersController());
  Get.put(AddBlogController());
  Get.put(PendingBlogsController());
  Get.put(CategoryController());
  Get.put(CommentsController());
  Get.put(BlogPostDetailController());
  Get.put(AuthorController());
  Get.put(PackageController());
  Get.put(AddCategoryController());
  Get.put(AddPackageController());
  Get.put(ReportedBlogsController());
  Get.put(SettingsController());
  Get.put(SupportTicketController());
  Get.put(ChangePasswordController());
  Get.put(LoginController());
  Get.put(SupportRequestsController());
  Get.put(SideMenuContainer());
  Get.put(UserController());

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
      home: FirebaseAuth.instance.currentUser?.uid == null ? const LoginScreen() : const MainScreen(),
      // home:  const MainScreen(),

    );
  }
}
