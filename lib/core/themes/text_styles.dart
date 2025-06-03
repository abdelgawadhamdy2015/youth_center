import 'package:flutter/material.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'font_weight_helper.dart';

class TextStyles {

  static TextStyle lighterGrayBoldStyle(double fontSize,{ String? fontFamily}) {
    return TextStyle(
        fontFamily:fontFamily,
        fontSize: fontSize,
        fontWeight: FontWeightHelper.bold,
        color: ColorManger.lighterGray);
  }

  static TextStyle lighterGrayRegulerStyle(double fontSize,{ String? fontFamily}) {
    return TextStyle(
        fontFamily:fontFamily,
        fontSize: fontSize,
        fontWeight: FontWeightHelper.reguler,
        color: ColorManger.lighterGray);
  }
  static TextStyle blackBoldStyle(double fontSize,{ String? fontFamily}) {
    return TextStyle(
        fontFamily:fontFamily ,
        fontSize: fontSize,
        fontWeight: FontWeightHelper.bold,
        color: ColorManger.darkBlack);
  }

  static TextStyle blackRegulerStyle(double fontSize,{ String? fontFamily}) {
    return TextStyle(
        fontFamily:fontFamily,
        fontSize: fontSize,
        fontWeight: FontWeightHelper.reguler,
        color:ColorManger.darkBlack);
  }

  static TextStyle blackMediumStyle(double fontSize, { String? fontFamily}) {
    return TextStyle(
        fontFamily:fontFamily,
        fontSize: fontSize,
        fontWeight: FontWeightHelper.medium,
        color: ColorManger.darkBlack);
  }
  

  static TextStyle lightRedRegulerStyle(double fontSize,{ String? fontFamily}) {
    return TextStyle(
        fontFamily:fontFamily ,
        fontSize: fontSize,
        fontWeight: FontWeightHelper.reguler,
        color: ColorManger.lightred);
  }

  static TextStyle lightGreenRegulerStyle(double fontSize, { String? fontFamily}) {
    return TextStyle(
        fontFamily:fontFamily ,
        fontSize: fontSize,
        fontWeight: FontWeightHelper.reguler,
        color: ColorManger.lightGreen);
  }

  static TextStyle whiteRegulerStyle(double fontSize,{ String? fontFamily}) {
    return TextStyle(
        fontFamily:fontFamily ,
        fontSize: fontSize,
        fontWeight: FontWeightHelper.reguler,
        color: Colors.white);
  }

  static TextStyle whiteBoldStyle(double fontSize,{ String? fontFamily}) {
    return TextStyle(
        fontFamily:fontFamily ,
        fontSize: fontSize,
        fontWeight: FontWeightHelper.bold,
        color: Colors.white);
  }

  static TextStyle whiteSemiBoldStyle(double fontSize, { String? fontFamily}) {
    return TextStyle(
        fontFamily:fontFamily ,
        fontSize: fontSize,
        fontWeight: FontWeightHelper.semiBold,
        color: Colors.white);
  }

  static TextStyle darkBlueRegulerStyle(double fontSize, { String? fontFamily}) {
    return TextStyle(
        fontFamily:fontFamily ,
        fontSize: fontSize,
        fontWeight: FontWeightHelper.reguler,
        color: ColorManger.darkBlue);
  }

  static TextStyle darkBlueBoldStyle(double fontSize,{ String? fontFamily}) {
    return TextStyle(
        fontFamily:fontFamily ,
        fontSize: fontSize,
        fontWeight: FontWeightHelper.bold,
        color: ColorManger.darkBlue);
  }
}
