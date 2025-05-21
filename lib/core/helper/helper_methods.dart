import 'package:flutter/material.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/core/widgets/mytextfile.dart';
import 'package:youth_center/generated/l10n.dart';

class HelperMethods {
  static Widget buildTextField(
    IconData icon,
    String hint,
    TextEditingController controller, {
    var validator,
    VoidCallback? onTab,
    bool obsecur = false,
  }) {
    return MyTextForm(
      obsecure: obsecur,
      readOnly: onTab!=null? true:false,
      onTab: onTab,
      fillColor: ColorManger.whiteColor,
      hint: hint,
      icon: Icon(icon),
      controller: controller,
      validator: validator,
    );
  }

  static List<String > getWeekDays(BuildContext context){
   return    [
      S.of(context).saturday,
      S.of(context).sunday,
      S.of(context).monday,
      S.of(context).tuesday,
      S.of(context).wednesday,
      S.of(context).thursday,
      S.of(context).friday,
    ];

  }

 static Future<DateTime?> pickTime(BuildContext context, {DateTime? initialDateTime}) async {
  TimeOfDay initialTime = initialDateTime != null
      ? TimeOfDay(hour: initialDateTime.hour, minute: initialDateTime.minute)
      : TimeOfDay.now();

  TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: initialTime,
  );

  if (picked == null) return null;

  return DateTime(0, 0, 0, picked.hour, picked.minute);
}

static verticalSpace(double hight){
  return  SizedBox(height: SizeConfig.screenHeight! * hight);
}
static horizintalSpace(double width){
  return  SizedBox(height: SizeConfig.screenWidth! * width);
}
}
