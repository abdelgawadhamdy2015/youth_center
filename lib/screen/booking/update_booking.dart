import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/core/widgets/app_text_button.dart';
import 'package:youth_center/core/widgets/body_container.dart';
import 'package:youth_center/core/widgets/day_drop_down.dart';
import 'package:youth_center/core/widgets/grediant_container.dart';
import 'package:youth_center/core/widgets/header.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/models/booking_model.dart';
import 'package:youth_center/screen/booking/booking_controller.dart';
import 'package:youth_center/screen/home/home_controller.dart';
import 'package:youth_center/screen/home/home_screen.dart';

class UpdateBooking extends ConsumerStatefulWidget {
  const UpdateBooking({super.key, required this.booking});
  final BookingModel booking;

  @override
  ConsumerState<UpdateBooking> createState() => _UpdateBookingState();
}

class _UpdateBookingState extends ConsumerState<UpdateBooking> {
  late TextEditingController nameController;
  late TextEditingController mobileController;
  late TextEditingController timeStartController;
  late TextEditingController timeEndController;

  List<String> _weekdays = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _weekdays = HelperMethods.getWeekDays(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize the dropdown value after the first frame is rendered
      ref.read(selectedCenterNameProvider.notifier).state =
          widget.booking.youthCenterId;
      ref.read(selectedDayProvider.notifier).state = widget.booking.day;
    });
    initData();
  }

  initData() async {
    nameController = TextEditingController(text: widget.booking.name);
    mobileController = TextEditingController(text: widget.booking.mobile);
    timeStartController = TextEditingController(text: widget.booking.timeStart);
    timeEndController = TextEditingController(text: widget.booking.timeEnd);
  }

  Future<void> updateBooking() async {
    BookingModel updatedBooking = BookingModel(
      date: widget.booking.date,
      day: ref.read(selectedDayProvider),
      id: widget.booking.id,
      name: nameController.text.trim(),
      mobile: mobileController.text.trim(),
      timeStart: timeStartController.text.trim(),
      timeEnd: timeEndController.text.trim(),
      youthCenterId: ref.read(selectedCenterNameProvider)!,
    );
    ref.watch(addBookingProvider.notifier).updateBooking(updatedBooking);
  }
  Future<void> deleteBooking() async {
    BookingModel updatedBooking = BookingModel(
      date: widget.booking.date,
      day: ref.read(selectedDayProvider),
      id: widget.booking.id,
      name: nameController.text.trim(),
      mobile: mobileController.text.trim(),
      timeStart: timeStartController.text.trim(),
      timeEnd: timeEndController.text.trim(),
      youthCenterId: ref.read(selectedCenterNameProvider)!,
    );
    ref.watch(addBookingProvider.notifier).deleteBooking(updatedBooking.id!);
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay = ref.watch(selectedDayProvider);
    ref.listen(addBookingProvider, (_, state) {
      state.whenOrNull(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).successSave),
              backgroundColor: ColorManger.buttonGreen,
              elevation: 10,
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return HomeScreen();
              },
            ),
          );
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: ColorManger.darkRed,
              elevation: 10,
            ),
          );
        },
      );
    });
    var lang = S.of(context);
    return Scaffold(
      body: GradientContainer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(title: S.of(context).bookings),
              BodyContainer(
                height: SizeConfig.screenHeight! * .85,
                padding: SizeConfig().getScreenPadding(
                  vertical: .1,
                  horizintal: .08,
                ),
                child: Column(
                  children: [
                    DayDropdown(
                      days: _weekdays,
                      selectedDay: selectedDay,

                      onChanged:
                          MyConstants.centerUser?.admin ?? false
                              ? (newDay) {
                                setState(() {
                                  ref.read(selectedDayProvider.notifier).state =
                                      newDay!;
                                });
                              }
                              : null,
                    ),
                    HelperMethods.verticalSpace(.03),

                    HelperMethods.buildTextField(
                      readOnly: !(MyConstants.centerUser?.admin ?? false),
                      Icons.person,
                      lang.entername,
                      nameController,
                    ),
                    HelperMethods.verticalSpace(.03),
                    HelperMethods.buildTextField(
                      readOnly: !(MyConstants.centerUser?.admin ?? false),

                      Icons.phone,
                      lang.enterMobile,
                      mobileController,
                    ),
                    HelperMethods.verticalSpace(.03),
                    HelperMethods.buildTextField(
                      readOnly: !(MyConstants.centerUser?.admin ?? false),
                      Icons.timer_rounded,
                      lang.enterStartTime,
                      timeStartController,
                    ),
                    HelperMethods.verticalSpace(.03),
                    HelperMethods.buildTextField(
                      readOnly: !(MyConstants.centerUser?.admin ?? false),
                      Icons.timer,
                      lang.enterEndTime,
                      timeEndController,
                    ),
                    HelperMethods.verticalSpace(.03),

                    if (MyConstants.centerUser?.admin ?? false)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppButtonText(
                            buttonWidth: SizeConfig.screenWidth! * .4,
                            backGroundColor: ColorManger.buttonGreen,
                            textStyle: GoogleFonts.tajawal(
                              color: Colors.white,
                              fontSize: SizeConfig.fontSize3!,
                            ),
                            butonText: lang.update,
                            onPressed: updateBooking,
                          ),
                           AppButtonText(
                            buttonWidth: SizeConfig.screenWidth! * .4,
                            backGroundColor: ColorManger.redButtonColor,
                            textStyle: GoogleFonts.tajawal(
                              color: Colors.white,
                              fontSize: SizeConfig.fontSize3!,
                            ),
                            butonText: lang.delete,
                            onPressed: deleteBooking,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
