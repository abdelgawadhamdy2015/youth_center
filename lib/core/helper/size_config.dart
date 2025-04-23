import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SizeConfig {
  static double? screenWidth;
  static double? screenHeight;
  static double? defaultSize;
  static Orientation? orientation;
  static double? fontSize4;
  static double? fontSize3;
  static double? fontSize5;
  static double? iconSize5;

  void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    orientation = MediaQuery.of(context).orientation;
    fontSize3 = (MediaQuery.of(context).size.width * .04).sp;
    fontSize4 = (MediaQuery.of(context).size.width * .05).sp;
    fontSize5 = (MediaQuery.of(context).size.width * .06).sp;
    iconSize5 = (MediaQuery.of(context).size.width * .05);
    defaultSize = orientation == Orientation.landscape
        ? screenHeight! * .024
        : screenWidth! * .024;
  }

  getScreenPadding({double? horizintal, double? vertical}) {
    return EdgeInsets.symmetric(
        horizontal: SizeConfig.screenWidth! * (horizintal ?? .04),
        vertical: SizeConfig.screenHeight! * (vertical ?? .01));
  }
}
