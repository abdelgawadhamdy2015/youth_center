import 'package:flutter/material.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/core/themes/text_styles.dart';
import 'package:youth_center/generated/l10n.dart';

class DayDropdown extends StatelessWidget {
  final List<String> days;
  final String? selectedDay;
  final Function(String?) onChanged;
  

  const DayDropdown({
    super.key,
    required this.days,
    required this.selectedDay,
    required this.onChanged,
   
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      alignment: AlignmentDirectional.bottomCenter,
      isExpanded: true,
  decoration: InputDecoration(
    
    isDense: true,
    filled: true,
    fillColor: ColorManger.darkListColor,
    hintText: S.of(context).selectDay,
    hintStyle: TextStyles.whiteBoldStyle(SizeConfig.fontSize3!),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  ),
  value: selectedDay,
  onChanged: onChanged,
  items: days.map<DropdownMenuItem<String>>((String day) {
    return DropdownMenuItem<String>(
      value: day,
      child: Text(
        day,
        textAlign: TextAlign.center,
        style: TextStyles.blackBoldStyle(SizeConfig.fontSize3!),
        
      ),
    );
  }).toList(),
);

  }
}
