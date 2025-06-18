import 'package:flutter/material.dart';

class ColorManger {
  static LinearGradient bodyGradient = LinearGradient(
    colors: [borderGrayColor, darkListColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static LinearGradient mainGradient = LinearGradient(
    colors: [darkBlack, ligthBlack],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color borderGrayColor = Color(0xFFE9ECEF);

  static const Color mainBlue = Color(0xFF0353A4);
  static const Color seconderyBlue = Color(0xFF0466C8);

  static const Color blackGray = Color(0xFF454545);
  static const Color gray = Color(0x68686B7F);
  static const Color datePickerColor = Color(0xFFD2D5D9);
  static const Color darkListColor = Color(0xFFDFE2E5);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color summeryTileColor = Color(0xFFE9ECEF);
  static const Color textFormBorderColor = Color(0xFFABAEB0);
  static const Color grayIconColor = Color(0xFF726C6C);
  static const Color editTextFillColor = Color(0xFFA3A9B3);

  static const Color lighterGray = Color(0xff7B7B7B);
  static const Color lightGray = Color(0xffFDFDFF);
  static const Color morelighterGray = Color(0xFFB2B2B2);
  static const Color morelightGray = Color(0xffC2C2C2);
  static const Color ligthBlack = Color(0xFF787878);
  static const Color darkBlack = Color(0xFF001233);
  static const Color backGroundGray = Color(0xFFF7F7F7);

  static const Color backGroundGreen = Color(0xffEBFFEE);
  static const Color statusGreen = Color(0xff007411);

  static const Color checkBoxGreen = Color(0xff2EA66E);
  static const Color buttonGreen = Color(0xff5DA684);
  static const Color lightGreen = Color(0xff65A624);
  static const Color moreLightGreen = Color(0xff0DD97A);
  static const Color lighterGreen = Color(0xff21A642);
  static const Color greenButtonColor = Color(0xFF047C0E);

  static const Color radioButtonBlue = Color(0xff2C6CBF);
  static const Color loginButtonColorBlue = Color(0xff265DA6);
  static const Color forgetPassswordTextColor = Color(0xffA7B8D9);
  static const Color lightBlue = Color(0xff327AD9);
  static const Color darkBlue = Color(0xff2C7BBF);
  static const Color mutedBlue = Color(0xff57D6F2);
  static const Color moreLiteBlue = Color(0xff306EBF);
  static const Color moreMutedBlue = Color(0xff05C7F2);

  static const Color lightred = Color(0xffF2522E);
  static const Color moreLightred = Color(0xffF25C5C);
  static const Color lighterRed = Color(0xffF21D2F);
  static const Color darkRed = Color(0xffbf0000);
  static const Color redButtonColor = Color(0xFF8F2220);
  static const Color delayRedColor = Color(0xFFA80000);

  // amper
  static const Color whiteAmper = Color.fromARGB(255, 118, 113, 103);
  static const Color amper = Color.fromARGB(255, 245, 182, 82);
}
