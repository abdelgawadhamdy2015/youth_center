import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/shared_pref_helper.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Youth Center"),
        backgroundColor: Colors.blueGrey,
        leading: const BackButton(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/3f.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Image(
                image: AssetImage("images/icon1.jpg"),
                width: 60,
                height: 60,
              ),
              const SizedBox(height: 20),
              HelperMethods.buildTextField(
                Icons.person,
                "enter who booking name",
                nameController,
              ),
              const SizedBox(height: 10),
              HelperMethods.buildTextField(
                Icons.phone,
                "enter who booking mobile",
                mobileController,
              ),
              const SizedBox(height: 10),
              HelperMethods.buildTextField(
                Icons.timer_rounded,
                "enter start time ex : 22:30",
                timeStartController,
              ),
              const SizedBox(height: 10),
              HelperMethods.buildTextField(
                Icons.timer,
                "enter end time ex : 22:30",
                timeEndController,
              ),
              const SizedBox(height: 10),
              _buildDropdown(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  "add to Bookings",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.blueGrey),
          items:
              youthCentersNames.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(fontSize: 18)),
                );
              }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                dropdownValue = newValue;
              });
            }
          },
        ),
      ),
    );
  }
}
