import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/core/themes/text_styles.dart';
import 'package:youth_center/core/widgets/app_text_button.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/models/booking_model.dart';
import 'package:youth_center/screen/booking/logic/booking_controller.dart';

class RequestCard extends ConsumerStatefulWidget {
  final BookingModel request;
  final bool? isAvailable;
  final bool isAdmin;
  const RequestCard({
    super.key,
    required this.request,
    this.isAvailable,
    required this.isAdmin,
  });

  @override
  ConsumerState<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends ConsumerState<RequestCard> {
  Future<void> acceptRequestBooking(BookingModel request) async {
    await ref
        .watch(addBookingProvider.notifier)
        .acceptRequestBooking(request)
        .then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).requestAccepted)),
          );
        });
  }

  Future<void> rejectRequestBooking(BookingModel request) async {
    await ref
        .watch(addBookingProvider.notifier)
        .rejectRequestBooking(request)
        .then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).requestRejected)),
          );
        });
  }

  Color getColor() {
    return (widget.request.status == 1)
        ? ColorManger.moreLightGreen
        : (widget.request.status == 2)
        ? ColorManger.moreLightred
        : ColorManger.amper;
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    final isAdmin = widget.isAdmin;
    final lang = S.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: getColor()),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${request.timeStart} - ${request.timeEnd}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: getColor(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  getStatus(context, request.status!),
                  style: TextStyles.lighterGrayRegulerStyle(
                    SizeConfig.fontSize3!,
                  ),
                ),
              ),
            ],
          ),
          HelperMethods.verticalSpace(.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${lang.yothCenter} ${request.youthCenterId}',
                style: TextStyles.lighterGrayRegulerStyle(
                  SizeConfig.fontSize3!,
                ),
              ),

              Text(
                '${lang.day} ${request.day}',
                style: TextStyles.lighterGrayRegulerStyle(
                  SizeConfig.fontSize3!,
                ),
              ),
            ],
          ),
          HelperMethods.verticalSpace(.01),

          Text(
            '${S.of(context).bookedBy} ${request.name}',
            style: TextStyles.lighterGrayRegulerStyle(SizeConfig.fontSize3!),
          ),
          HelperMethods.verticalSpace(.01),

          if (isAdmin)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AppButtonText(
                  backGroundColor: ColorManger.darkRed,
                  verticalPadding: 0,
                  buttonHeight: SizeConfig.screenHeight! * .03,
                  buttonWidth: SizeConfig.screenWidth! * 0.3,
                  butonText: lang.reject,
                  onPressed: () {
                    rejectRequestBooking(request);
                  },
                  textStyle: TextStyles.whiteBoldStyle(SizeConfig.fontSize3!),
                ),
                AppButtonText(
                  backGroundColor: ColorManger.darkBlack,

                  verticalPadding: 0,
                  buttonHeight: SizeConfig.screenHeight! * .03,
                  buttonWidth: SizeConfig.screenWidth! * 0.3,
                  textStyle: TextStyles.whiteBoldStyle(SizeConfig.fontSize3!),
                  butonText: lang.accept,
                  onPressed: () {
                    acceptRequestBooking(request);
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  String getStatus(BuildContext context, int status) {
    switch (status) {
      case 0:
        return S.of(context).pinding;
      case 1:
        return S.of(context).accepted;
      case 2:
        return S.of(context).rejected;
      default:
        return "";
    }
  }
}
