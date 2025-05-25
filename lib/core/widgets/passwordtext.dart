import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/generated/l10n.dart';


class PasswordText extends StatefulWidget {
  final String hint;
  final bool obsecur;
  final Color? fillColor;
  final TextStyle? hintStyle;
  final TextStyle? inputTextStyle;

  final TextEditingController control;
  const PasswordText(
      {super.key,
      required this.hint,
      required this.obsecur,
      required this.control,
      this.fillColor,
      this.hintStyle,
      this.inputTextStyle});
  @override
  State<PasswordText> createState() => _PasswordTextState();
}

class _PasswordTextState extends State<PasswordText> {
  var myHint = "";
  var obsecured = true;
  late double hight;

  @override
  void initState() {
    super.initState();
    hight = SizeConfig.screenHeight! * .06;
    setState(() {
      myHint = widget.hint;
      obsecured = widget.obsecur;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: hight,
      child: TextFormField(
        
        style: widget.inputTextStyle,
        controller: widget.control,
        textAlignVertical: TextAlignVertical.center,
        obscureText: obsecured,
        obscuringCharacter: "*",
        decoration: InputDecoration(
         prefixIcon: Icon(Icons.lock,),
            fillColor: widget.fillColor ?? ColorManger.morelightGray,
            filled: true,
            hintText: widget.hint,
            hintStyle: widget.hintStyle ??
                TextStyle(
                  fontSize: 14.sp,
                ),
            enabledBorder:  OutlineInputBorder(
            borderRadius:BorderRadius.circular(SizeConfig.screenWidth! *.02),
              borderSide: BorderSide(color: ColorManger.textFormBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
               borderRadius:BorderRadius.circular(SizeConfig.screenWidth! *.02),
              borderSide: BorderSide(color: Colors.blue, width: 0.6.w),
            ),
            errorBorder: OutlineInputBorder(
               borderRadius:BorderRadius.circular(SizeConfig.screenWidth! *.02),
              borderSide: BorderSide(color: Colors.red, width: 0.6.w),
            ),
            focusedErrorBorder: OutlineInputBorder(
               borderRadius:BorderRadius.circular(SizeConfig.screenWidth! *.02),
              borderSide: BorderSide(color: Colors.red.shade300, width: 0.6.w),
            ),
            errorStyle: TextStyle(fontSize: 15.sp),
            suffixIcon: IconButton(
              color: ColorManger.loginButtonColorBlue,
              icon: Icon(Icons.remove_red_eye),
              onPressed: () {
                setState(() {
                  obsecured = !obsecured;
                });
              },
            )),

        // this male validation and i will add string variable and replace it with ''
        //and add the global key in the main form
        validator: (val) {
          if (val!.isEmpty) {
            setState(() {
              hight = SizeConfig.screenHeight! * .07;
            });
            return "\u26A0 ${S.of(context).pleaseFill} ${S.of(context).password}";
          } else {
            setState(() {
              hight = SizeConfig.screenHeight! * .05;
            });
            return null;
          }
        },
      ),
    );
  }
}
