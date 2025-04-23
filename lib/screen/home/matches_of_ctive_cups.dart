import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/models/booking_model.dart';
import 'package:youth_center/models/cup_model.dart';
import 'package:youth_center/models/match_model.dart';
import 'package:youth_center/models/user_model.dart';

import '../../FetchData.dart';

class MatchesOfActiveCups extends StatefulWidget {
  const MatchesOfActiveCups({super.key, required this.center});

  final CenterUser center;

  @override
  State<MatchesOfActiveCups> createState() => Matches();
}

class Matches extends State<MatchesOfActiveCups> {
  Matches();

  late QuerySnapshot<Map<String, dynamic>> snapshot1;
  List<String> youthCentersNames = ["كفر الحما", "الساقية", "شنواي"];

  late List<CupModel> cups = [];

  late CupModel cupModel;

  List<MatchModel> matchesModels = [];
  late DateTime newDateTime = DateTime(2023, 5, 14, 30);
  late Timestamp dateTime;

  //late Random random;
  late CenterUser center;
  List<TextEditingController> controllers = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  late BookingModel booking;
  TextEditingController nameController = TextEditingController();

  List<String> teems = [];
  FetchData fetchData = FetchData();
  late bool adminValue = center.admin;
  var dropdownValue = "";
  int teemsCount = 0;
  late Stream<QuerySnapshot<Map<String, dynamic>>> collection = getCollection();

  @override
  void initState() {
    super.initState();
    center = widget.center;
    dropdownValue = center.youthCenterName;
    getCollection();
  }

  TextStyle getTextStyle() {
    return  TextStyle(
      fontSize: 18,
      color: Colors.black,
      backgroundColor: MyColors.primaryColor,
    );
  }

  double getSizeBoxHight() {
    return 10;
  }

  @override
  void dispose() {
    super.dispose();
    getCollection();
    nameController.dispose();
  }

  getCollection() {
    if (adminValue) {
      collection =
          FirebaseFirestore.instance
              .collection('Cups')
              .where("youthCenterId", isEqualTo: center.youthCenterName)
              .where("finished", isEqualTo: false)
              .snapshots();
    } else {
      collection =
          FirebaseFirestore.instance
              .collection('Cups')
              .where("youthCenterId", isEqualTo: dropdownValue)
              .where("finished", isEqualTo: false)
              .snapshots();
    }

    return collection;
  }

  getCupsFromSnapshot(AsyncSnapshot<QuerySnapshot<Object?>> s) {
    cups =
        s.data!.docs
            .map(
              (e) => CupModel.fromSnapshot(
                e as DocumentSnapshot<Map<String, dynamic>>,
              ),
            )
            .toList();

    for (var element in cups) {
      getMatchesModel(element.matches);
    }
  }

  List<MatchModel> getMatchesModel(List<dynamic> map) {
    for (var element in map) {
      matchesModels.add(MatchModel.fromMap(element));
    }
    print(matchesModels.length.toString());
    return matchesModels;
  }

  DateTime iniDate = DateTime(2023, 7, 14, 10, 30);

  @override
  Widget build(BuildContext context) {
    CollectionReference reference = db.collection("Cups");
    reference.snapshots().listen((querySnapshot) {
      if (querySnapshot.docChanges.isNotEmpty) {
        for (var change in querySnapshot.docChanges) {
          // Do something with change
          if (change.doc.exists) {
          } else {
            setState(() {
              print("no changes");
            });
          }
        }
      }
    });
    return Scaffold(
      body: Container(
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
            StreamBuilder<QuerySnapshot>(
              stream: collection,
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,
              ) {
                // Handling errors from firebase
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  // Display if still loading data
                  case ConnectionState.waiting:
                    return Text('Loading...');
                  case ConnectionState.none:
                    return Text("no data ");
                  case ConnectionState.done:
                    return Text("done");

                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      getCupsFromSnapshot(snapshot);
                      return Column(
                        children: [
                          const Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 20),
                                Text(
                                  "البطولات",
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
                                  matchesModels.clear();
                                  dropdownValue = newValue!;
                                  getCollection();
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: matchesModels.length,
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
                                      width: 300,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            matchesModels
                                                .elementAt(index)
                                                .firstTeem,
                                            maxLines: 2,
                                          ),
                                          SizedBox(width: getSizeBoxHight()),
                                          const Icon(Icons.sports_baseball),
                                          SizedBox(width: getSizeBoxHight()),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Text(
                                                  matchesModels
                                                      .elementAt(index)
                                                      .cupName,
                                                ),
                                                SizedBox(
                                                  height: getSizeBoxHight(),
                                                ),
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  //maxLines: 2,
                                                  fetchData.getDateTime(
                                                    matchesModels
                                                        .elementAt(index)
                                                        .time
                                                        .toDate(),
                                                  ),
                                                ),
                                                Text(
                                                  "${fetchData.getScore(matchesModels.elementAt(index), 1)} : ${fetchData.getScore(matchesModels.elementAt(index), 2)}",
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),

                                          const SizedBox(width: 10),
                                          const Icon(Icons.sports_baseball),
                                          const SizedBox(width: 10),
                                          InkWell(
                                            onLongPress: () {
                                              if (adminValue) {
                                                setState(() {
                                                  matchesModels
                                                          .elementAt(index)
                                                          .secondTeemScore =
                                                      matchesModels
                                                          .elementAt(index)
                                                          .secondTeemScore +
                                                      1;
                                                });
                                              }
                                            },
                                            child: Text(
                                              matchesModels
                                                  .elementAt(index)
                                                  .secondTeem,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () => {if (adminValue) {}},
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Text("no data ");
                    }
                }
              },
            ),
          ],
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
      return "";
    }
  }
}
