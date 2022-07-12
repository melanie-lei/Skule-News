import 'package:music_streaming_admin_panel/helper/common_import.dart';

enum Font {
  lato,
  openSans,
  poppins,
  raleway,
  roboto
}

enum DisplayMode{
  light,
  dark
}

class AppThemeSetting{
  static DisplayMode mode = DisplayMode.light;

  static setDisplayMode(DisplayMode currentMode){
    mode = currentMode;
  }
}
