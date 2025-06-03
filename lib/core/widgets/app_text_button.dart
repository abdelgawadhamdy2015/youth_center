import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';


class AppButtonText extends StatelessWidget {
  final double? borderRadius;
  final Color? backGroundColor;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? buttonWidth;
  final double? buttonHeight;
  final TextStyle textStyle;
  final String butonText;
  final VoidCallback onPressed;
  final LinearGradient ? linearGradient;
  final IconData? icon;
  const AppButtonText(
      {super.key,
      this.borderRadius,
      this.backGroundColor,
      this.horizontalPadding,
      this.verticalPadding,
      this.buttonWidth,
      this.buttonHeight,
      required this.textStyle,
      required this.butonText,
      required this.onPressed, this.linearGradient, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: linearGradient!=null? BoxDecoration(
         borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
        gradient: linearGradient
      ): null,
      height:buttonHeight?? SizeConfig.screenHeight! * .065,
      width: buttonWidth?? SizeConfig.screenWidth!  *.9,
      child: TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
            
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
              )),
              backgroundColor: WidgetStatePropertyAll(
                  backGroundColor ?? ColorManger.mainBlue),
              padding: WidgetStateProperty.all(
                EdgeInsets.symmetric(
                    horizontal:
                        horizontalPadding ?? SizeConfig.screenWidth! * .016,
                    vertical:
                        verticalPadding ?? SizeConfig.screenHeight! * .016),
              ),
              fixedSize: WidgetStateProperty.all(Size(
                  buttonWidth ?? SizeConfig.screenWidth! *.9,
                  buttonHeight ?? SizeConfig.screenHeight! * .06)),
                  ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                butonText,
                style: textStyle,
              ),
                        if(icon!=null) Icon(icon, color: Colors.white,size: SizeConfig.screenWidth! *.06,),

            ],
          )),
    );
  }
}
