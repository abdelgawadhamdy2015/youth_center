import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/generated/l10n.dart';


class MyTextForm extends StatefulWidget {
  final String? hint;
  final String? excep;
  final InputBorder? foucesedBorder;
  final InputBorder? enabeledBorder;
  final bool? obsecure;
  final Widget? suffixIcon;
  final String? labelText;
  final TextStyle? hintStyle;
  final TextStyle? inputTextStyle;
  final String? hintText;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final Function(String?)? validator;
  final TextEditingController? controller;
  final Function(String?)? onChanged;
  final InputBorder? errorBorder;
  final Function()? onTab;
  final bool? readOnly;
  final Function(String?)? onSaved;
  final bool? enabled;
  final int? maxLines;
  final Widget? icon;
  final double? hight;
  final TextInputType? inputType;
  final Function()? onEditingComplete;

  const MyTextForm(
      {super.key,
      this.hint,
      this.excep,
      this.controller,
      this.foucesedBorder,
      this.enabeledBorder,
      this.obsecure,
      this.suffixIcon,
      this.labelText,
      this.hintStyle,
      this.inputTextStyle,
      this.hintText,
      this.contentPadding,
      this.fillColor,
      this.validator,
      this.onChanged,
      this.errorBorder,
      this.onTab,
      this.readOnly,
      this.onSaved,
      this.onEditingComplete,
      this.enabled,
      this.maxLines,
      this.icon, this.hight, this.inputType});

  @override
  State<MyTextForm> createState() => _MyTextFormState();
}

class _MyTextFormState extends State<MyTextForm> {
  late double hight;
  @override
  void initState() {
    hight =  SizeConfig.screenHeight! * .06;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:widget.hight?? hight,
      child: Center(
        child: TextFormField(
            keyboardType: widget.inputType ?? TextInputType.text,
            style: widget.inputTextStyle,
            maxLines: widget.maxLines ?? 1,
            enabled: widget.enabled ?? true,
            onEditingComplete: widget.onEditingComplete,
            onSaved: widget.onSaved,
            readOnly: widget.readOnly ?? false,
            onTap: widget.onTab,
           
            controller: widget.controller,
            decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(color: ColorManger.textFormBorderColor),borderRadius: BorderRadius.circular(SizeConfig.screenWidth! *.02)),
              prefixIcon:
                widget.icon,
               
              labelStyle: widget.hintStyle,
              labelText: widget.labelText,
              fillColor: widget.fillColor ?? ColorManger.morelightGray,
              filled: true,
              suffixIcon: widget.suffixIcon,
              hintText: widget.hint,
              hintStyle: widget.hintStyle ??
                  TextStyle(
                    fontSize: 14.sp,
                  ),
              focusedBorder: widget.foucesedBorder ??
                  OutlineInputBorder(
                     borderRadius:BorderRadius.circular(SizeConfig.screenWidth! *.02),
                    borderSide:
                        BorderSide(color:ColorManger.textFormBorderColor, width: .6.w),
                    //borderRadius: BorderRadius.circular(16),
                  ),
              enabledBorder: widget.enabeledBorder ??
                  OutlineInputBorder(
                     borderRadius:BorderRadius.circular(SizeConfig.screenWidth! *.02),
                    borderSide: BorderSide(
                        color: ColorManger.textFormBorderColor, width: 0.9.w),
                  ),
              errorBorder: widget.errorBorder ??
                  OutlineInputBorder(
                     borderRadius:BorderRadius.circular(SizeConfig.screenWidth! *.02),
                    borderSide: BorderSide(color: Colors.red, width: 0.6.w),
                  ),
              focusedErrorBorder: OutlineInputBorder(
                 borderRadius:BorderRadius.circular(SizeConfig.screenWidth! *.02),
                borderSide:
                    BorderSide(color: Colors.red.shade300, width: 0.6.w),
              ),
              errorStyle: TextStyle(fontSize: 15.sp),
              disabledBorder: widget.enabeledBorder ??
                  OutlineInputBorder(
                     borderRadius:BorderRadius.circular(SizeConfig.screenWidth! *.02),
                    borderSide: BorderSide(
                        color: ColorManger.lighterGray, width: 0.6.w),
                  ),
            ),
            validator: (val) {
              if (widget.validator == null) {
                if (val!.isEmpty) {
                  setState(() {
                    hight = SizeConfig.screenHeight! * .08;
                  });
                  return "\u26A0 ${S.of(context).pleaseFill} ${widget.excep}";
                } else {
                  setState(() {
                    hight = SizeConfig.screenHeight! * .05;
                  });
                  return null;
                }
              } else {
                setState(() {
                  hight = SizeConfig.screenHeight! * .08;
                });
                return widget.validator!(val);
              }
            }),
      ),
    );
  }
}
