import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart'
    show DateTimePickerOption, DateTimePickerStyle, ScrollDateTimePicker;
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';


class CustomScrollDate extends StatelessWidget {

 const CustomScrollDate(
      {super.key,
      required this.selectedDate,
      required this.onDateTimeChanged,
      required this.dateFormat});
  final DateTime selectedDate;
  final Function(DateTime value) onDateTimeChanged;
  final DateFormat dateFormat;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(gradient: ColorManger.bodyGradient),
        height: SizeConfig.screenHeight! * .2,
        child: ScrollDateTimePicker(
          
            style: DateTimePickerStyle(
              
              activeDecoration:
                  BoxDecoration(color: ColorManger.morelighterGray),
            ),
            visibleItem: 3,
            itemExtent: 40,
            infiniteScroll: false,
            dateOption: DateTimePickerOption(
              dateFormat: dateFormat,
              minDate: DateTime(2020, 1),
              maxDate: DateTime(20000, 1),
              initialDate: selectedDate,
            ),
            onChange: (newDate) {
             
                onDateTimeChanged(newDate);
              
            }),
      ),
    );
  }
}
