import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/shared_pref_helper.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/core/widgets/app_text_button.dart';
import 'package:youth_center/core/widgets/body_container.dart';
import 'package:youth_center/core/widgets/day_drop_down.dart';
import 'package:youth_center/core/widgets/grediant_container.dart';
import 'package:youth_center/core/widgets/header.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/models/booking_model.dart';
import 'package:youth_center/screen/home/home_screen.dart';

class UpdateBooking extends StatefulWidget {
  const UpdateBooking({super.key, required this.booking});
  final BookingModel booking;

  @override
  State<UpdateBooking> createState() => _UpdateBookingState();
}

class _UpdateBookingState extends State<UpdateBooking> {
  late TextEditingController nameController;
  late TextEditingController mobileController;
  late TextEditingController timeStartController;
  late TextEditingController timeEndController;
 late String dropdownValue ;
  FirebaseFirestore db = FirebaseFirestore.instance;
  late String _selectedDay;
  List<String> _weekdays = [];
  List<String> youthCentersNames = [];

 
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _weekdays = HelperMethods.getWeekDays(context);
    initData();
  }

  initData() async {
    nameController = TextEditingController(text: widget.booking.name);
    mobileController = TextEditingController(text: widget.booking.mobile);
    timeStartController = TextEditingController(text: widget.booking.timeStart);
    timeEndController = TextEditingController(text: widget.booking.timeEnd);
    dropdownValue = widget.booking.youthCenterId;
    _selectedDay = widget.booking.day;

    youthCentersNames = await SharedPrefHelper.getListString(
      MyConstants.prefCenterNames,
    );
  }

  Future<void> updateBooking() async {
    BookingModel updatedBooking = BookingModel(
      day: _selectedDay,
      id: widget.booking.id,
      name: nameController.text.trim(),
      mobile: mobileController.text.trim(),
      timeStart: timeStartController.text.trim(),
      timeEnd: timeEndController.text.trim(),
      youthCenterId: dropdownValue,
    );

    await db
        .collection(MyConstants.bookingCollection)
        .doc(widget.booking.id)
        .set(updatedBooking.toJson());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Booking updated successfully"),
        backgroundColor: Colors.green,
        elevation: 10,
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return HomeScreen(centerUser: MyConstants.centerUser);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      selectedDay: _selectedDay,
          
                      onChanged:
                          MyConstants.centerUser.admin
                              ? (newDay) {
                                setState(() {
                                  _selectedDay = newDay!;
                                });
                              }
                              : null,
                    ),
                    HelperMethods.verticalSpace(.03),
          
                    HelperMethods.buildTextField(
                      readOnly: !MyConstants.centerUser.admin,
                      Icons.person,
                      lang.entername,
                      nameController,
                    ),
                    HelperMethods.verticalSpace(.03),
                    HelperMethods.buildTextField(
                      readOnly: !MyConstants.centerUser.admin,
          
                      Icons.phone,
                      lang.enterMobile,
                      mobileController,
                    ),
                    HelperMethods.verticalSpace(.03),
                    HelperMethods.buildTextField(
                      readOnly: !MyConstants.centerUser.admin,
                      Icons.timer_rounded,
                      lang.enterStartTime,
                      timeStartController,
                    ),
                    HelperMethods.verticalSpace(.03),
                    HelperMethods.buildTextField(
                      readOnly: !MyConstants.centerUser.admin,
                      Icons.timer,
                      lang.enterEndTime,
                      timeEndController,
                    ),
                    HelperMethods.verticalSpace(.03),
          
                    if (MyConstants.centerUser.admin)
                      AppButtonText(
                        backGroundColor: ColorManger.buttonGreen,
                        textStyle: GoogleFonts.tajawal(
                          color: Colors.white,
                          fontSize: SizeConfig.fontSize3!,
                        ),
                        butonText: lang.update,
                        onPressed: updateBooking,
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
