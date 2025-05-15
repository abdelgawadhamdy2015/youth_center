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
import 'package:youth_center/core/widgets/grediant_container.dart';
import 'package:youth_center/core/widgets/header.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/models/booking_model.dart';

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
  String dropdownValue = "شنواي";
  FirebaseFirestore db = FirebaseFirestore.instance;

  List<String> youthCentersNames = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    nameController = TextEditingController(text: widget.booking.name);
    mobileController = TextEditingController(text: widget.booking.mobile);
    timeStartController = TextEditingController(text: widget.booking.timeStart);
    timeEndController = TextEditingController(text: widget.booking.timeEnd);
    dropdownValue = widget.booking.youthCenterId;
    youthCentersNames = await SharedPrefHelper.getListString(
      MyConstants.prefCenterNames,
    );
    setState(() {});
  }

  Future<void> updateBooking() async {
    BookingModel updatedBooking = BookingModel(
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
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Scaffold(
      body: GradientContainer(
        child: Column(
          children: [
            Header(title: S.of(context).bookings),
            BodyContainer(
              height: SizeConfig.screenHeight! * .85,
              padding: SizeConfig().getScreenPadding(vertical: .1,horizintal: .08),
              child: Column(
                children: [
                  HelperMethods.buildTextField(
                    Icons.person,
                    lang.entername,
                    nameController,
                  ),
                  const SizedBox(height: 10),
                  HelperMethods.buildTextField(
                    Icons.phone,
                    lang.enterMobile,
                    mobileController,
                  ),
                  const SizedBox(height: 10),
                  HelperMethods.buildTextField(
                    Icons.timer_rounded,
                    lang.enterStartTime,
                    timeStartController,
                  ),
                  const SizedBox(height: 10),
                  HelperMethods.buildTextField(
                    Icons.timer,
                    lang.enterEndTime,
                    timeEndController,
                  ),
                  const SizedBox(height: 10),
                  //  _buildDropdown(),
                  const SizedBox(height: 20),
                  AppButtonText(
                    backGroundColor: ColorManger.buttonGreen,
                    textStyle: GoogleFonts.tajawal(
                      color: Colors.white,
                      fontSize: SizeConfig.fontSize3!,
                    ),
                    butonText: lang.update,
                    onPressed: updateBooking,
                  ),
                  // ElevatedButton(
                  //   onPressed: updateBooking,
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.blueGrey,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(30),
                  //     ),
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 30,
                  //       vertical: 15,
                  //     ),
                  //   ),
                  //   child: Text(
                  //     lang.update,
                  //     style: TextStyle(color: Colors.white, fontSize: 16),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildDropdown() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 20),
  //     decoration: BoxDecoration(
  //       color: Colors.white.withOpacity(0.9),
  //       borderRadius: BorderRadius.circular(30),
  //     ),
  //     child: DropdownButtonHideUnderline(
  //       child: DropdownButton<String>(
  //         value: dropdownValue,
  //         icon: const Icon(Icons.arrow_drop_down, color: Colors.blueGrey),
  //         items:
  //             youthCentersNames.map((String value) {
  //               return DropdownMenuItem<String>(
  //                 value: value,
  //                 child: Text(value, style: const TextStyle(fontSize: 18)),
  //               );
  //             }).toList(),
  //         onChanged: (String? newValue) {
  //           if (newValue != null) {
  //             setState(() {
  //               dropdownValue = newValue;
  //             });
  //           }
  //         },
  //       ),
  //     ),
  //   );
  // }
}
