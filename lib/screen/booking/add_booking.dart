import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/models/booking_model.dart';

import '../../fetch_data.dart';

class AddBooking extends StatefulWidget {
  const AddBooking({super.key, required this.center});

  final String center;

  @override
  State<StatefulWidget> createState() {
    return Add();
  }
}

class Add extends State<AddBooking> {
  Add();

  FirebaseFirestore db = FirebaseFirestore.instance;
  late BookingModel booking;
  TextEditingController nameController = TextEditingController();
  TextEditingController timeStartController = TextEditingController();
  TextEditingController timeEndController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  //var youthCentersNames=["شنواي","الساقية", "كفر الحما"];
  FetchData fetchDate = FetchData();
  bool adminValue = true;
  var dropdownValue = "شنواي";

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print(widget.center);
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    timeStartController.dispose();
    mobileController.dispose();
  }

  Future addBooking(BookingModel booking) async {
    db
        .collection(MyConstants.bookingCollection)
        .add(booking.toJson())
        .whenComplete(
          () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(MyConstants.success),
              backgroundColor: Colors.greenAccent,
              elevation: 10, //shadow
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Youth Center"),
        backgroundColor: MyColors.primaryColor,
      ),

      body: Container(
        height: SizeConfig.screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/3f.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
        child: Column(
          children: [
            HelperMethods.buildTextField(
              Icons.person,
              "enter who booking name ",
              nameController,
            ),
            
            const SizedBox(height: 20),
            HelperMethods.buildTextField(
              Icons.phone,
              "enter who booking mobile ",
              mobileController,
            ),
            
            const SizedBox(height: 20),
            HelperMethods.buildTextField(
             Icons.timer_rounded,
              "enter start time ex : 22:30",
              timeStartController,
            ),
            
            const SizedBox(height: 20),
             HelperMethods.buildTextField(
             Icons.timer,
               "enter end  time ex : 22:30",
              timeEndController,
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(left: 0),
              child: ElevatedButton(
                onPressed: () {
                  addBooking(
                    BookingModel(
                      name: nameController.text.toString().trim(),
                      mobile: mobileController.text.toString().trim(),
                      timeEnd: timeEndController.text.toString().trim(),
                      timeStart:
                          timeStartController.text.toString().trim(),
                      youthCenterId: widget.center,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text(
                  "add to Bookings",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
