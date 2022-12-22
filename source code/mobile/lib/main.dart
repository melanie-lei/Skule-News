import 'package:flutter/material.dart';
import 'package:skule_news_mobile/helper/common_import.dart';
import 'package:get/get.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

// kjhhjkhkjh
// comment
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
  Get.put(SavedPostsController());

  bool onBoardingShown = await SharedPrefs().isOnBoardingShown();

  EasyLoading.instance.userInteractions = false;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // foreground notification for ios
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // foreground notifications for android??
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.instance.subscribeToTopic("all");

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
        fallbackLocale: const Locale('en', 'US'),
        child: MainApp(
          onBoardingShown: onBoardingShown,
        )),
  );
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.max,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

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
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_launcher');
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: "@mipmap/ic_launcher",
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(notification.title!),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(notification.body!)],
                ),
              ),
            );
          },
        );
      }
    });

    getToken();
    FirebaseManager firebaseManager = FirebaseManager();
    firebaseManager.updateToken();
  }

  late String token;
  getToken() async {
    token = (await FirebaseMessaging.instance.getToken())!;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // builds app and applies themes
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      // localizationsDelegates: const [
      //   GlobalCupertinoLocalizations.delegate,
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      // ],
      supportedLocales: context.supportedLocales,

      locale: context.locale,
      // navigatorKey: NoomiKeys.navKey,
      builder: EasyLoading.init(),
      // home: FirebaseAuth.instance.currentUser?.uid == null ? const LoginScreen() : const MainScreen(),
      home: widget.onBoardingShown == true
          ? FirebaseAuth.instance.currentUser?.uid == null
              ? const LoginViaEmail()
              : const MainScreen()
          : const OnBoardingScreen(),
    );
  }
}
