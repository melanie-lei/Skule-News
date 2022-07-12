import 'package:music_streaming_admin_panel/helper/common_import.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerLazySingleton<FirebaseManager>(() => FirebaseManager());
  getIt.registerLazySingleton<UserProfileManager>(() => UserProfileManager());

}
