
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

import 'package:youth_center/FetchData.dart';
import 'package:youth_center/models/booking_model.dart';
import 'package:youth_center/models/match_model.dart';
import 'package:youth_center/models/youth_center_model.dart';
import 'package:youth_center/screen/add_booking.dart';
import 'package:youth_center/screen/cups_screen.dart';
import 'package:youth_center/screen/matches_of_ctive_cups.dart';
import 'package:youth_center/screen/update_booking.dart';
import 'package:youth_center/screen/update_profile.dart';

import '../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key, required this.centerUser,
  });
    final CenterUser centerUser;


  @override
  State<HomeScreen> createState() => Home();
}

class Home extends State<HomeScreen> with SingleTickerProviderStateMixin {
  Home();

  FirebaseFirestore db = FirebaseFirestore.instance;
  late QuerySnapshot<Map<String, dynamic>> snapshot;
  late QuerySnapshot<Map<String, dynamic>> snapshot1;
  late List<BookingModel> bookingData = getAllBookings() as List<BookingModel>;
  late List<BookingModel> bookingDataByCenter =
      getAllBookingsByCenterName() as List<BookingModel>;
  FetchData fetchDate = FetchData();
  late List<YouthCenterModel> youthCenters =
      getAllCenters() as List<YouthCenterModel>;
  List<String> youthCentersNames = [];

  late TabController tabController;
  late String dropdownValue = "";

  late List<MatchModel> matches = [];

  bool adminValue = true;
  @override
  void initState() {
    super.initState();
   // centerUser=FirebaseAuth.instance.currentUser as CenterUser;
    dropdownValue = widget.centerUser.youthCenterName;
    adminValue = widget.centerUser.admin;
    tabController = TabController(length: 2, vsync: this);
  }

  List<MatchModel> getMatchesModel(List<dynamic> map) {
    for (var element in map) {
      matches.add(MatchModel.fromMap(element));
    }
    print(matches.length.toString());
    return matches;
  }

  Future<List<BookingModel>?> getAllBookings() async {
    snapshot = await db.collection("Bookings").get();
    bookingData =
        snapshot.docs.map((e) => BookingModel.fromSnapshot(e)).toList();
    return bookingData;
  }

  Future<List<BookingModel>?> getAllBookingsByCenter(
      CenterUser centerUser) async {
    snapshot1 = await db
        .collection("Bookings")
        .where("youthCenterId", isEqualTo: centerUser.youthCenterName)
        .get();
    bookingDataByCenter =
        snapshot1.docs.map((e) => BookingModel.fromSnapshot(e)).toList();
    return bookingDataByCenter;
  }

  Future<List<BookingModel>?> getBooking() async {
    if (adminValue) {
      print("center111111111111111");
      return getAllBookingsByCenter(widget.centerUser);
    } else {
      print("name55555555555555555");

      return getAllBookingsByCenterName();
    }
  }

  Future<List<BookingModel>?> getAllBookingsByCenterName() async {
    snapshot1 = await db
        .collection("Bookings")
        .where("youthCenterId", isEqualTo: dropdownValue)
        .get();
    bookingDataByCenter =
        snapshot1.docs.map((e) => BookingModel.fromSnapshot(e)).toList();
    return bookingDataByCenter;
  }

  Future<List<YouthCenterModel>?> getAllCenters() async {
    snapshot1 = await db.collection("youthCenters").get();
    youthCenters =
        snapshot1.docs.map((e) => YouthCenterModel.fromSnapshot(e)).toList();
    for (int i = 0; i < youthCenters.length; i++) {
      if (!youthCentersNames.contains(youthCenters.elementAt(i).name)) {
        youthCentersNames.add(youthCenters.elementAt(i).name);
      }
    }
    return youthCenters;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    getAllCenters();
    return Scaffold(
        appBar: AppBar(
          leading: //Image(image: AssetImage("images/logo.jpg"),),
              const Icon(Icons.sports_baseball_sharp,
                  color: Colors.purpleAccent),
          flexibleSpace: SizedBox(
            height: 10,
          ),
          bottom: TabBar(
              padding: EdgeInsets.all(5),
              controller: tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
                color: Colors.green,
              ),
              labelColor: Colors.red,
              unselectedLabelColor: Colors.black,
              tabs: const [
                Tab(child: Text("الحجوزات")),
                Tab(child: Text("البطولات")),
              ]),
          title: const Text("Youth Center"),
          backgroundColor: Colors.amber,
          actions: [
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  fetchDate.buildPopupMenuItem(
                      adminValue, 0, "حسابي", Icons.account_circle_outlined),
                  fetchDate.buildPopupMenuItem(
                      adminValue, 1, "اضافة حجز", Icons.add),
                  fetchDate.buildPopupMenuItem(
                      adminValue, 2, "الدورات", Icons.sports_baseball),
                  fetchDate.buildPopupMenuItem(
                      adminValue, 3, "تسجيل خروج", Icons.logout),
                ];
              },
              color: Colors.white,
              icon: Icon(Icons.menu),
              onSelected: (value) {
                switch (value) {
                  case 0:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UpdateProfile()));
                    break;

                  case 1:
                    if (adminValue) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddBooking(
                                  center: widget.centerUser.youthCenterName)));
                    }
                    break;
                  case 2:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CupScreen(center:widget. centerUser)));

                    break;
                  case 3:
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacementNamed('/');
                }
              },
            )
          ],
        ),
        body: SwipeDetector(
          onSwipeDown: (offset) => setState(() {}),
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/2f.jpg"), fit: BoxFit.fill)),
            child: TabBarView(controller: tabController, children: [
              FutureBuilder(
                future: getBooking(),
                builder: (context, snapshot1) {
                  if (snapshot1.connectionState == ConnectionState.done) {
                    if (snapshot1.hasData) {
                      return Column(children: [
                        const Center(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text("Hello for the Youth Center",
                                    style: TextStyle(fontSize: 13)),
                              ]),
                        ),
                        Visibility(
                          visible: !adminValue,
                          child: DropdownButton<String>(
                              // Step 3.
                              value: getValue(),
                              icon: const Icon(
                                Icons.arrow_drop_down_circle_outlined,
                                color: Colors.purple,
                              ),
                              // Step 4.
                              items: youthCentersNames
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
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
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                            child: ListView.builder(
                          itemCount: bookingDataByCenter.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: Card(
                                  //semanticContainer: true,
                                  margin: const EdgeInsets.all(10),
                                  shape: const Border.symmetric(
                                      vertical: BorderSide(
                                          color: Colors.blueAccent, width: 5),
                                      horizontal: BorderSide(
                                          color: Colors.purple, width: 5)),
                                  color: Colors.deepOrangeAccent,
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(bookingDataByCenter
                                            .elementAt(index)
                                            .name),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Icon(Icons.sports_baseball),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                                "from ${bookingDataByCenter.elementAt(index).timeStart}"),
                                            Text(
                                                "to ${bookingDataByCenter.elementAt(index).timeEnd}"),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Icon(Icons.sports_baseball),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(bookingDataByCenter
                                            .elementAt(index)
                                            .mobile
                                            .toString())
                                      ],
                                    ),
                                  )),
                              onTap: () => {
                                if (adminValue)
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UpdateBooking(
                                                booking: bookingDataByCenter
                                                    .elementAt(index),
                                              )),
                                    ),
                                  }
                              },
                            );
                          },
                        ))
                      ]);
                    } else if (snapshot1.hasError) {
                      print(snapshot1.error);
                      return Center(
                        child: Text(snapshot1.error.toString()),
                      );
                    } else if (!snapshot1.hasData) {
                      return const Center(child: Text("no data"));
                    } else {
                      return const Center(child: Text("Some thing went wrong"));
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              MatchesOfActiveCups(center:widget.centerUser ),
            ]),
          ),
        ));
  }

  String getValue() {
    if (adminValue) {
      return widget.centerUser.youthCenterName;
    } else {
      return dropdownValue;
    }
  }
}
