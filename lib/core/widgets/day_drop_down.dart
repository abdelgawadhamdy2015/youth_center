import 'package:flutter/material.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/core/themes/text_styles.dart';
import 'package:youth_center/generated/l10n.dart';

class DayDropdown extends StatelessWidget {
  final List<String> days;
  final String? selectedDay;
  final Function(String?)? onChanged;
  final String? lableText;
  final FormFieldValidator<String>? validator;
  const DayDropdown({
    super.key,
    required this.days,
    required this.selectedDay,
    required this.onChanged,
    this.lableText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(lableText ?? '',
            style: TextStyles.blackBoldStyle(SizeConfig.fontSize3!),
            textAlign: TextAlign.start),
        DropdownButtonFormField<String>(

          validator: validator,
          alignment: AlignmentDirectional.bottomCenter,
          isExpanded: false,
          decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: ColorManger.darkListColor,
        hintText:lableText?? S.of(context).selectDay,
        hintStyle: TextStyles.whiteBoldStyle(SizeConfig.fontSize3!),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
          ),
          
          value: selectedDay,
          onChanged: onChanged,
          items: {
            DropdownMenuItem<String>(
              value: null,
              child: Text(
                lableText?? S.of(context).selectDay,
                textAlign: TextAlign.center,
                style: TextStyles.lighterGrayRegulerStyle(SizeConfig.fontSize3!),
              ),
            ),
            ...days.map<DropdownMenuItem<String>>((String day) {
              return DropdownMenuItem<String>(
                value: day,
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: TextStyles.blackBoldStyle(SizeConfig.fontSize3!),
                ),
              );
            }),
           }.toList()
          
        ),
      ],
    );

  }
}
