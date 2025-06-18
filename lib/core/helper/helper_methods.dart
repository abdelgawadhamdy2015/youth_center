import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/core/themes/text_styles.dart';
import 'package:youth_center/core/widgets/app_text_button.dart';
import 'package:youth_center/core/widgets/mytextfile.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/models/match_model.dart';
import 'package:youth_center/screen/booking/logic/booking_controller.dart';
import 'package:youth_center/screen/home/logic/home_controller.dart';

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
    final parts = timeString.split(':');
    if (parts.length != 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) return null;

    return DateTime(0, 0, 0, hour, minute);
  }

  static buildHeader({
    required BuildContext context,
    String? title,
    required bool isAdmin,
    List<String>? tabs,
    TabController? tabController,
  }) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SvgPicture.asset(
                MyConstants.logoSvg,
                height: SizeConfig.screenHeight! * .05,
              ),
              HelperMethods.horizintalSpace(.02),

              Text(
                S.of(context).appName,
                style: GoogleFonts.tajawal(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          (tabController != null && tabs != null)
              ? Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    SizeConfig.screenWidth! * .2,
                  ),
                ),
                child: TabBar(
                  controller: tabController,
                  unselectedLabelColor: Colors.white60,
                  labelColor: Colors.white,
                  tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                ),
              )
              : Padding(
                padding: SizeConfig().getScreenPadding(),
                child: Text(
                  title ?? "",
                  style: TextStyles.whiteBoldStyle(SizeConfig.fontSize4!),
                ),
              ),
        ],
      ),
    );
  }

  static List<MatchModel> parseMatches(List<dynamic> rawMatches) {
    return rawMatches.map((match) => MatchModel.fromMap(match)).toList();
  }

  static String getDateTime(DateTime dateTime) {
    String dateTimeStr =
        ("${MyConstants.dateFormat.format(dateTime)}\n"
            "${MyConstants.hourFormat.format(dateTime)}");
    return dateTimeStr;
  }

  static String getScore(MatchModel matchModel, int i) {
    if (i == 1) {
      if (matchModel.matchTime.isAfter(DateTime.now())) {
        return "-";
      } else {
        return matchModel.teem1Score.toString();
      }
    } else {
      if (matchModel.matchTime.isAfter(DateTime.now())) {
        return "-";
      } else {
        return matchModel.teem2Score.toString();
      }
    }
  }

  static buildAlertDialog({
    required BuildContext context,
    required String message,
    required List<String> actions,
    Function? onTap,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: Icon(Icons.logout_outlined, color: ColorManger.delayRedColor),
          content: Text(
            textAlign: TextAlign.center,
            message,
            style: TextStyles.blackBoldStyle(SizeConfig.fontSize3!),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  actions
                      .map(
                        (action) => AppButtonText(
                          backGroundColor:
                              actions.indexOf(action) > 0
                                  ? ColorManger.darkBlack
                                  : ColorManger.darkRed,
                          buttonWidth: SizeConfig.screenWidth! * .3,
                          textStyle: TextStyles.whiteBoldStyle(
                            SizeConfig.fontSize3!,
                          ),
                          onPressed: () {
                            if (actions.length > 1 &&
                                actions.indexOf(action) > 0 &&
                                onTap != null) {
                              onTap();
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          butonText: action,
                        ),
                      )
                      .toList(),
            ),
          ],
        );
      },
    );
  }
}
