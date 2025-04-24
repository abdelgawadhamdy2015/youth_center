// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:intl/intl.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/models/booking_model.dart';
import 'package:youth_center/models/cup_model.dart';
import 'package:youth_center/models/match_model.dart';
import 'package:youth_center/models/user_model.dart';
import 'package:youth_center/screen/cup/create_cup.dart';
import 'package:youth_center/screen/cup/cup_detail_screen.dart';

import '../../fetch_data.dart';

class CupScreen extends StatefulWidget {
  const CupScreen({super.key, required this.center});

  final CenterUser center;

  @override
  State<StatefulWidget> createState() {
    return Cup();
  }
}

class Cup extends State<CupScreen> {
  Cup();

  late QuerySnapshot<Map<String, dynamic>> snapshot1;
  List<String> youthCentersNames = ["كفر الحما", "الساقية", "شنواي"];
  final dateFormat = DateFormat('dd/MM/y');
  late List<CupModel> cups = [];

  double groups = 2;
  bool matches = false;
  bool randomTeems = false;
  late CupModel cupModel;
  List selectedRondomTeems = [];
  List firstList = [];
  List secondList = [];
  List thirdList = [];
  List fourList = [];
  List fiveList = [];
  List sixList = [];
  List sevenList = [];
  List eightList = [];
  List<MatchModel> matchesModels = [];
  late DateTime newDateTime = DateTime(2023, 5, 14, 30);

  //late Random random;
  late CenterUser center;
  List<TextEditingController> controllers = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  late BookingModel booking;
  TextEditingController nameController = TextEditingController();
  TextEditingController timeStartController = TextEditingController();
  TextEditingController timeEndController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  List<String> teems = [];
  FetchData fetchData = FetchData();
  bool adminValue = true;
  var dropdownValue = "شنواي";
  int teemsCount = 0;

  DateTime dateTime = DateTime(2023, 7, 18, 10, 30);

  @override
  void initState() {
    super.initState();
    center = widget.center;
    getCups();
    adminValue = center.admin;

    print(cups.length.toString());
  }

  TextStyle getTextStyle() {
    return TextStyle(
      fontSize: 18,
      color: Colors.black,
      backgroundColor: MyColors.primaryColor,
    );
  }

  int getGroups() {
    if (teems.isEmpty) {
      groups = 4;
    } else {
      groups = groups;
    }
    return groups.toInt();
  }

  String getElement(List anyList, int index) {
    if (anyList.isNotEmpty) {
      return anyList.elementAt(index);
    } else {
      return "no element";
    }
  }

  double getSizeBoxHight() {
    return 10;
  }

  getVisibility() {
    if (randomTeems && matches) {
      return true;
    } else if (!randomTeems && matches) {}
  }

  /*showTime() async {
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            // This uses the _timePickerTheme defined above
            timePickerTheme: _timePickerTheme,
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.orange),
                foregroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.white),
                overlayColor: MaterialStateColor.resolveWith(
                    (states) => Colors.deepOrange),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    print(timeOfDay..toString());
  }*/

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    timeStartController.dispose();
    mobileController.dispose();
  }

  Future<List<CupModel>> getCups() async {
    snapshot1 =
        await db
            .collection(MyConstants.cupCollection)
            .where(
              MyConstants.youthCenterIdCollection,
              isEqualTo: adminValue ? center.youthCenterName : dropdownValue,
            )
            .get();
    cups = snapshot1.docs.map((e) => CupModel.fromSnapshot(e)).toList();
    print(cups.length.toString());
    return cups;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Youth Center"),
        backgroundColor: MyColors.primaryColor,
      ),
      body: SwipeDetector(
        onSwipeDown: (offset) => setState(() {}),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/3f.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          //alignment: AlignmentDirectional.topStart,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Stack(
            children: [
              FutureBuilder(
                future: getCups(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          const Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 20),
                                Text(
                                  "Hello for the Youth Center",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
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
                              items:
                                  youthCentersNames.map<
                                    DropdownMenuItem<String>
                                  >((String value) {
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
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: cups.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  child: Card(
                                    //semanticContainer: true,
                                    margin: const EdgeInsets.all(10),
                                    shape: const Border.symmetric(
                                      vertical: BorderSide(
                                        color: Colors.blueAccent,
                                        width: 5,
                                      ),
                                      horizontal: BorderSide(
                                        color: Colors.purple,
                                        width: 5,
                                      ),
                                    ),
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
                                          Text(cups.elementAt(index).name),
                                          const SizedBox(width: 10),
                                          const Icon(Icons.sports_baseball),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                dateFormat
                                                    .format(
                                                      cups
                                                          .elementAt(index)
                                                          .timeStart
                                                          .toDate(),
                                                    )
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            getStatus(cups.elementAt(index)),
                                          ),
                                          const SizedBox(width: 10),
                                          const Icon(Icons.sports_baseball),
                                          const SizedBox(width: 10),
                                          Text(
                                            cups.elementAt(index).youthCenterId,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap:
                                      () => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => CupDetailScreen(
                                                  cupModel: cups.elementAt(
                                                    index,
                                                  ),
                                                  center: center,
                                                ),
                                          ),
                                        ),
                                      },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else if (!snapshot.hasData || cups.isEmpty) {
                      return const Center(child: Text("no data"));
                    } else {
                      return const Center(child: Text("Some thing went wrong"));
                    }
                  } else if (cups.isEmpty) {
                    return const Center(child: Text("no data"));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              Visibility(
                visible: center.admin,
                child: Container(
                  padding: EdgeInsets.all(50),
                  alignment: AlignmentDirectional.bottomEnd,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddCupScreen(center: center),
                        ),
                      );
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getValue() {
    if (adminValue) {
      return center.youthCenterName;
    } else {
      return dropdownValue;
    }
  }

  String getStatus(CupModel cupModel) {
    if (cupModel.finished) {
      return "finished";
    } else {
      return "active";
    }
  }

  /*
  String getTime(int index) {
    var

    DateTime.fromMillisecondsSinceEpoch( (cups.elementAt(index).timeStart) * 1000);
  }*/
}
