import 'package:music_streaming_mobile/helper/common_import.dart';

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