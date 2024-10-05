import 'package:flutter/material.dart';

class ScreenSizeConfig {
  static late double ScreenWidth;
  static late double ScreenHeight;
  static String? fontfamilyN;
  static late double iconSize;
  static late double titleTextsize;
  static const double defaultPadding = 30.0;
  static void init(BuildContext context) {
    ScreenWidth = MediaQuery.of(context).size.width;
    ScreenHeight = MediaQuery.of(context).size.height;
    iconSize = ScreenWidth * 0.07;
    // fontfamilyN = "Nunito";
  }
}
