import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/core/widgets/mytextfile.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/screen/booking/booking_controller.dart';
import 'package:youth_center/screen/home/home_controller.dart';

class HelperMethods {
  static Widget buildTextField(
    IconData icon,
    String hint,
    TextEditingController controller, {
     TextInputType? inputType,
    var validator,
    VoidCallback? onTab,
    bool obsecur = false,
    bool readOnly = false,
  }) {
    return MyTextForm(
      obsecure: obsecur,
      readOnly: readOnly,
      onTab: onTab,
      fillColor: ColorManger.whiteColor,
      hint: hint,
      icon: Icon(icon),
      controller: controller,
      validator: validator,
      inputType: inputType,
    );
  }

  static List<String> getWeekDays(BuildContext context) {
    return [
      S.of(context).saturday,
      S.of(context).sunday,
      S.of(context).monday,
      S.of(context).tuesday,
      S.of(context).wednesday,
      S.of(context).thursday,
      S.of(context).friday,
    ];
  }

  static Future<DateTime?> pickTime(
    BuildContext context, {
    DateTime? initialDateTime,
  }) async {
    TimeOfDay initialTime =
        initialDateTime != null
            ? TimeOfDay(
              hour: initialDateTime.hour,
              minute: initialDateTime.minute,
            )
            : TimeOfDay.now();

    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked == null) return null;

    return DateTime(0, 0, 0, picked.hour, picked.minute);
  }

  static verticalSpace(double hight) {
    return SizedBox(height: SizeConfig.screenHeight! * hight);
  }

  static horizintalSpace(double width) {
    return SizedBox(height: SizeConfig.screenWidth! * width);
  }

  static invalidateAllProviders(BuildContext context, dynamic ref) {
    if (ref == null) return;
    MyConstants.centerUser = null;
    ref.invalidate(isAdminProvider);
    ref.invalidate(youthCentersProvider);
    ref.invalidate(filteredBookingsProvider);
    ref.invalidate(selectedCenterNameProvider);
    ref.invalidate(selectedDayProvider);
    ref.invalidate(matchesProvider);
    ref.invalidate(cupsProvider);
    ref.invalidate(centerUserProvider);
    ref.invalidate(addBookingProvider);
    ref.invalidate(youthCenterNamesProvider);
    ref.invalidate(bookingsProvider);
    ref.invalidate(activeCupsProvider);
    ref.invalidate(bookingRequestsProvider);
  }

  static List<String> generateTimes({int stepMinutes = 60}) {
    List<String> times = [];

    for (int i = 0; i < 24 * 60; i += stepMinutes) {
      final hours = (i ~/ 60).toString().padLeft(2, '0');
      final minutes = (i % 60).toString().padLeft(2, '0');
      String formattedTime = "$hours:$minutes";
      times.add(formattedTime);
    }

    return times;
  }

  static DateTime? parseTime(String? timeString) {
    if (timeString == null) return null;
    log('timeString: $timeString');
    final parts = timeString.split(':');
    if (parts.length != 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) return null;

    return DateTime(0, 0, 0, hour, minute);
  }
}
