import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/models/booking_model.dart';

import '../../FetchData.dart';

class AddBooking extends StatefulWidget {
  const AddBooking({super.key, required this.center});

  final String center;

  @override
  State<StatefulWidget> createState() {
    return Add(centerName: center);
  }
}

class Add extends State<AddBooking> {
  Add({required this.centerName});

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

  String centerName;
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print(centerName);
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
        .collection("Bookings")
        .add(booking.toJson())
        .whenComplete(
          () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("success "),
              backgroundColor: Colors.redAccent,
              elevation: 10, //shadow
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Youth Center"),
        backgroundColor:ColorManger.mainBlue,
       
      ),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/3f.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        alignment: AlignmentDirectional.topStart,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage("images/icon1.jpg"),
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      icon: const Icon(Icons.person, color: Colors.red),
                      filled: true,
                      fillColor:ColorManger.mainBlue,
                      hintText: "enter who booking name ",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    obscureText: false,
                    controller: mobileController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      icon: const Icon(Icons.phone, color: Colors.red),
                      filled: true,
                      fillColor:ColorManger.mainBlue,
                      hintText: "enter who booking mobile ",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    obscureText: false,
                    controller: timeStartController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      icon: const Icon(Icons.timer_rounded, color: Colors.red),
                      filled: true,
                      fillColor:ColorManger.mainBlue,
                      hintText: "enter start time ex : 22:30",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    obscureText: false,
                    controller: timeEndController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      icon: const Icon(Icons.timer, color: Colors.red),
                      filled: true,
                      fillColor:ColorManger.mainBlue,
                      hintText: "enter end  time ex : 22:30",
                    ),
                  ),
                  const SizedBox(height: 10),
                  /*Container(
                    color:ColorManger.mainBlue,
                    child: DropdownButton<String>(
                      // Step 3.
                        value: dropdownValue,
                        icon: const Icon(
                          Icons.arrow_drop_down_circle_outlined,
                          color: Colors.purple,
                        ),
                        // Step 4.
                        items: youthCentersNames
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(fontSize: 30),
                            ),
                          );
                        }).toList(),
                        // Step 5.
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });

                        }),
                  ),*/
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                            youthCenterId: centerName,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:ColorManger.mainBlue,
                      ),
                      child: const Text(
                        "add to Bookings",
                        style: TextStyle(fontSize: 15, color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
