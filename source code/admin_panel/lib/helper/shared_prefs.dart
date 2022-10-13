import 'package:skule_news_admin_panel/helper/pub_imports.dart';

class SharedPrefs {
  //Set/Get UserLoggedIn Status
  void setUserLoggedIn(bool loggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', loggedIn);
    // ConstantUtil.isLoggedIn = loggedIn;
  }

  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  //Set/Get UserLoggedIn Status
  void setAuthorizationKey(String authKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('authKey', authKey);
    prefs.setBool('isLoggedIn', true);
    // ConstantUtil.isLoggedIn = true;
  }

  Future<String> getAuthorizationKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get('authKey') as String;
  }

  void clearPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  setDarkMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
  }
}
