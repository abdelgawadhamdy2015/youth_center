import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:youth_center/models/cup_model.dart';
import 'package:youth_center/models/match_model.dart';
import 'package:youth_center/models/user_model.dart';


import '../FetchData.dart';

class CupDetailScreen extends StatefulWidget {
  const CupDetailScreen(
      {super.key, required this.center, cup, required this.cupModel});

  final CenterUser center;
  final CupModel cupModel;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CupDetail(center: center, cupModel: cupModel);
  }
}

class CupDetail extends State<CupDetailScreen> {
  late Timestamp dateTime;

  TextEditingController nameController = TextEditingController();

  CupDetail({required this.center, required this.cupModel});

  late QuerySnapshot<Map<String, dynamic>> snapshot1;
  bool finished = false;
  late CupModel cupModel;
  List firstList = [];
  List secondList = [];
  List thirdList = [];
  List fourList = [];
  List fiveList = [];
  List sixList = [];
  List sevenList = [];
  List eightList = [];
  late List<MatchModel> matchesModels;

  late DateTime iniDate = DateTime(2023, 5, 14, 30);
  CenterUser center;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FetchData fetchData = FetchData();
  bool adminValue = true;
  var dropdownValue = "شنواي";
  int teemsCount = 0;
  late Timer timer;

  late List<MatchModel> matchesModel = [];
  late List group;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    nameController.text = cupModel.name;
    if (cupModel.teems.isNotEmpty && cupModel.teems.length >= 8) {
      print(cupModel.teems);
      firstList = cupModel.teems.sublist(0, 4);
      secondList = cupModel.teems.sublist(4, 8);
    }
    if (cupModel.teems.length > 8 && cupModel.teems.length >= 16) {
      print(cupModel.teems);
      thirdList = cupModel.teems.sublist(8, 12);
      fourList = cupModel.teems.sublist(12, 16);
    }
    if (cupModel.teems.length > 16 && cupModel.teems.length >= 24) {
      print(cupModel.teems);
      fiveList = cupModel.teems.sublist(16, 20);
      sixList = cupModel.teems.sublist(20, 24);
    }
    if (cupModel.teems.length > 24 && cupModel.teems.length >= 32) {
      print(cupModel.teems);
      sevenList = cupModel.teems.sublist(24, 28);
      eightList = cupModel.teems.sublist(28, 32);
    }
    matchesModels = getMatchesModel(cupModel.matches);
  }

  List<MatchModel> getMatchesModel(List<dynamic> map) {
    for (var element in map) {
      matchesModel.add(MatchModel(
          firstTeem: element["firstTeem"],
          secondTeem: element["secondTeem"],
          time: element["time"],
          firstTeemScore: element["firstTeemScore"],
          secondTeemScore: element["secondTeemScore"],
          youthCenterId: element["youthCenterId"],
        cupName: element["cupName"]!,
      ));
    }
    return matchesModel;
  }

  TextStyle getTextStyle() {
    return const TextStyle(
        fontSize: 18, color: Colors.black, backgroundColor: Colors.amber);
  }

  String getElement(List anyList, int index) {
    if (anyList.isNotEmpty && anyList.length == 4) {
      return anyList.elementAt(index);
    } else {
      return "no element";
    }
  }


  double getSizeBoxHight() {
    return 10;
  }

  Future saveCup() async {
    List<dynamic> josonMatchesList = fetchData.listToJson(matchesModels);
    cupModel = CupModel(
        id: cupModel.id,
        name: nameController.text,
        teems: cupModel.teems,
        timeStart: cupModel.timeStart,
        youthCenterId: cupModel.youthCenterId,
        matches: josonMatchesList,
        finished: cupModel.finished);

    db
        .collection("Cups")
        .doc(cupModel.id)
        .set(cupModel.toJson())
        .whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 1),
        content: Text("cup saved successfully"),
        backgroundColor: Colors.redAccent,
        elevation: 10, //shadow
      ));
    }).catchError(
            (error) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(error.toString()),
                  backgroundColor: Colors.redAccent,
                  elevation: 10, //shadow
                )));
  }
  
  @override
  Widget build(BuildContext context) {
    CollectionReference reference = db.collection("Cups");
    reference.snapshots().listen((querySnapshot) {
      querySnapshot.docs.forEach((change) {
        setState(() {

        });
        // Do something with change
      });
    });
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: const Text("Youth Center"),
          backgroundColor: Colors.amber,
        ),
        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/3f.jpg"), fit: BoxFit.cover)),
            //alignment: AlignmentDirectional.topStart,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: SingleChildScrollView(
              primary: true,
              child: Column(children: [
                //SizedBox
                /** Checkbox Widget **/
                Visibility(
                  visible: center.admin,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Finished ?",
                          style: getTextStyle(),
                        ),
                        const SizedBox(width: 5),
                        Checkbox(
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Colors.blue),
                          checkColor: Colors.black,

                          activeColor: Colors.lightGreenAccent,
                          hoverColor: Colors.indigoAccent,
                          value: cupModel.getStatus(),
                          onChanged: (bool? value) {
                            setState(() {
                              cupModel.finished=value!;
                            });
                          },
                        ),

                      ]),
                ),

                Visibility(
                    visible: !center.admin
                    ,child: Text(getStatus(cupModel.getStatus()))),
                TextField(

                    textAlign: TextAlign.center,
                    controller: nameController,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "اسم البطولة ")),
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: firstList.isNotEmpty,
                          child: Column(
                            children: [
                              Text(
                                "المجموعة الاولى",
                                style: getTextStyle(),
                              ),
                              SizedBox(
                                height: getSizeBoxHight(),
                              ),
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  width: 100,
                                  decoration: const BoxDecoration(
                                      color: Colors.cyan,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Column(
                                    children: [
                                      Text(getElement(firstList, 0)),
                                      SizedBox(height: getSizeBoxHight()),
                                      Text(getElement(firstList, 1)),
                                      SizedBox(height: getSizeBoxHight()),
                                      Text(getElement(firstList, 2)),
                                      SizedBox(height: getSizeBoxHight()),
                                      Text(getElement(firstList, 3)),
                                      SizedBox(height: getSizeBoxHight()),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: getSizeBoxHight(),
                        ),
                        SizedBox(
                          width: getSizeBoxHight(),
                        ),
                        Visibility(
                          visible: secondList.isNotEmpty,
                          child: Column(
                            children: [
                              Text(
                                "المجموعة الثانية",
                                style: getTextStyle(),
                              ),
                              SizedBox(
                                height: getSizeBoxHight(),
                              ),
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  width: 100,
                                  decoration: const BoxDecoration(
                                      color: Colors.cyan,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Column(
                                    children: [
                                      Text(getElement(secondList, 0)),
                                      SizedBox(height: getSizeBoxHight()),
                                      Text(getElement(secondList, 1)),
                                      SizedBox(height: getSizeBoxHight()),
                                      Text(getElement(secondList, 2)),
                                      SizedBox(height: getSizeBoxHight()),
                                      Text(getElement(secondList, 3)),
                                      SizedBox(height: getSizeBoxHight()),
                                    ],
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: getSizeBoxHight(),
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: thirdList.isNotEmpty,
                            child: Column(
                              children: [
                                Text(
                                  "المجموعة الثالثة",
                                  style: getTextStyle(),
                                ),
                                SizedBox(
                                  height: getSizeBoxHight(),
                                ),
                                Container(
                                    padding: const EdgeInsets.all(10),
                                    width: 100,
                                    decoration: const BoxDecoration(
                                        color: Colors.cyan,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Column(
                                      children: [
                                        Text(getElement(thirdList, 0)),
                                        SizedBox(height: getSizeBoxHight()),
                                        Text(getElement(thirdList, 1)),
                                        SizedBox(height: getSizeBoxHight()),
                                        Text(getElement(thirdList, 2)),
                                        SizedBox(height: getSizeBoxHight()),
                                        Text(getElement(thirdList, 3)),
                                        SizedBox(height: getSizeBoxHight()),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: getSizeBoxHight(),
                          ),
                          Visibility(
                            visible: fourList.isNotEmpty,
                            child: Column(
                              children: [
                                Text(
                                  "المجموعة الرابعة",
                                  style: getTextStyle(),
                                ),
                                SizedBox(
                                  height: getSizeBoxHight(),
                                ),
                                Container(
                                    padding: const EdgeInsets.all(10),
                                    width: 100,
                                    decoration: const BoxDecoration(
                                        color: Colors.cyan,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Column(
                                      children: [
                                        Text(getElement(fourList, 0)),
                                        SizedBox(height: getSizeBoxHight()),
                                        Text(getElement(fourList, 1)),
                                        SizedBox(height: getSizeBoxHight()),
                                        Text(getElement(fourList, 2)),
                                        SizedBox(height: getSizeBoxHight()),
                                        Text(getElement(fourList, 3)),
                                        SizedBox(height: getSizeBoxHight()),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ]),
                    SizedBox(
                      height: getSizeBoxHight(),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: fiveList.isNotEmpty,
                          child: Column(
                            children: [
                              Text(
                                "المجموعة الخامسة",
                                style: getTextStyle(),
                              ),
                              SizedBox(
                                height: getSizeBoxHight(),
                              ),
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  width: 100,
                                  decoration: const BoxDecoration(
                                      color: Colors.cyan,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Column(
                                    children: [
                                      Text(getElement(fiveList, 0)),
                                      SizedBox(height: getSizeBoxHight()),
                                      Text(getElement(fiveList, 1)),
                                      SizedBox(height: getSizeBoxHight()),
                                      Text(getElement(fiveList, 2)),
                                      SizedBox(height: getSizeBoxHight()),
                                      Text(getElement(fiveList, 3)),
                                      SizedBox(height: getSizeBoxHight()),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: getSizeBoxHight(),
                        ),
                        Visibility(
                          visible: sixList.isNotEmpty,
                          child: Column(
                            children: [
                              Text(
                                "المجموعة السادسة",
                                style: getTextStyle(),
                              ),
                              SizedBox(
                                height: getSizeBoxHight(),
                              ),
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  width: 100,
                                  decoration: const BoxDecoration(
                                      color: Colors.cyan,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Column(
                                    children: [
                                      Text(getElement(sixList, 0)),
                                      SizedBox(height: getSizeBoxHight()),
                                      Text(getElement(sixList, 1)),
                                      SizedBox(height: getSizeBoxHight()),
                                      Text(getElement(sixList, 2)),
                                      SizedBox(height: getSizeBoxHight()),
                                      Text(getElement(sixList, 3)),
                                      SizedBox(height: getSizeBoxHight()),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getSizeBoxHight(),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: sevenList.isNotEmpty,
                          child: Column(
                            children: [
                              Text(
                                "المجموعة السابعة",
                                style: getTextStyle(),
                              ),
                              SizedBox(
                                height: getSizeBoxHight(),
                              ),
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  width: 100,
                                  decoration: const BoxDecoration(
                                      color: Colors.cyan,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Column(
                                    children: [
                                      Text(getElement(sevenList, 0)),
                                      SizedBox(height: getSizeBoxHight()),
                                      Text(getElement(sevenList, 1)),
                                      SizedBox(height: getSizeBoxHight()),
                                      Text(getElement(sevenList, 2)),
                                      SizedBox(height: getSizeBoxHight()),
                                      Text(getElement(sevenList, 3)),
                                      SizedBox(height: getSizeBoxHight()),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: getSizeBoxHight(),
                        ),
                        Visibility(
                          visible: eightList.isNotEmpty,
                          child: Column(
                            children: [
                              Text(
                                "المجموعة الثامنة",
                                style: getTextStyle(),
                              ),
                              SizedBox(
                                height: getSizeBoxHight(),
                              ),
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  width: 100,
                                  decoration: const BoxDecoration(
                                      color: Colors.cyan,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Column(
                                    children: [
                                      Text(getElement(eightList, 0)),
                                      SizedBox(height: getSizeBoxHight()),
                                      Text(getElement(eightList, 1)),
                                      SizedBox(height: getSizeBoxHight()),
                                      Text(getElement(eightList, 2)),
                                      SizedBox(height: getSizeBoxHight()),
                                      Text(getElement(eightList, 3)),
                                      SizedBox(height: getSizeBoxHight()),
                                    ],
                                  )),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: getSizeBoxHight(),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: matchesModels.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: SwipeDetector(
                        onSwipeRight: (offset) {
                          if (center.admin) {
                            setState(() {
                              matchesModels.elementAt(index).secondTeemScore =
                                  matchesModels
                                          .elementAt(index)
                                          .secondTeemScore -
                                      1;
                            });
                          }
                        },
                        onSwipeLeft: (offset) {
                          if (center.admin) {
                            setState(() {
                              matchesModels.elementAt(index).firstTeemScore =
                                  matchesModels
                                          .elementAt(index)
                                          .firstTeemScore -
                                      1;
                            });
                          }
                        },
                        child: Card(
                            //semanticContainer: true,
                            margin: const EdgeInsets.all(10),
                            shape: const Border.symmetric(
                                vertical: BorderSide(
                                    color: Colors.blueAccent, width: 5),
                                horizontal:
                                    BorderSide(color: Colors.purple, width: 5)),
                            color: Colors.deepOrangeAccent,
                            child: Container(
                              width: 300,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onLongPress: () {
                                      if (center.admin) {
                                        setState(() {
                                          matchesModels
                                              .elementAt(index)
                                              .firstTeemScore = matchesModels
                                                  .elementAt(index)
                                                  .firstTeemScore +
                                              1;
                                        });
                                      }
                                    },
                                    child: Text(
                                      matchesModels.elementAt(index).firstTeem,
                                      maxLines: 2,
                                    ),
                                  ),
                                  SizedBox(
                                    width: getSizeBoxHight(),
                                  ),
                                  const Icon(Icons.sports_baseball),
                                  SizedBox(
                                    width: getSizeBoxHight(),
                                  ),
                                  Expanded(
                                    child: Column(children: [
                                      MaterialButton(
                                          onPressed: () async {
                                            if (center.admin) {
                                              DateTime? newDate =
                                                  await showDatePicker(
                                                      context: context,
                                                      initialDate: iniDate,
                                                      firstDate: DateTime(2000),
                                                      lastDate: DateTime(2100));
                                              if (newDate == null) return;

                                              TimeOfDay? newTime =
                                                  await showTimePicker(
                                                      context: context,
                                                      initialTime: TimeOfDay(
                                                          hour: iniDate.hour,
                                                          minute:
                                                              iniDate.minute));
                                              if (newTime == null) return;
                                              iniDate = DateTime(
                                                  newDate.year,
                                                  newDate.month,
                                                  newDate.day,
                                                  newTime.hour,
                                                  newTime.minute);
                                              setState(() {
                                                dateTime =
                                                    Timestamp.fromDate(iniDate);
                                                matchesModels
                                                    .elementAt(index)
                                                    .setTime(dateTime);
                                              });
                                            }
                                          },
                                          child: Text(
                                              textAlign: TextAlign.center,
                                              //maxLines: 2,
                                              fetchData.getDateTime(
                                                  matchesModels
                                                      .elementAt(index)
                                                      .time
                                                      .toDate()))),
                                      Text(
                                          "${fetchData.getScore(matchesModels.elementAt(index), 1)} : ${fetchData.getScore(matchesModels.elementAt(index), 2)}"),
                                    ]),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Icon(Icons.sports_baseball),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onLongPress: () {
                                      if (center.admin) {
                                        setState(() {
                                          matchesModels
                                              .elementAt(index)
                                              .secondTeemScore = matchesModels
                                                  .elementAt(index)
                                                  .secondTeemScore +
                                              1;
                                        });
                                      }
                                    },
                                    child: Text(
                                      matchesModels.elementAt(index).secondTeem,
                                      maxLines: 2,
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                      onTap: () => {if (center.admin) {}},
                    );
                  },
                ),
                Visibility(
                  visible: center.admin,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.blue)),
                      child: const Text(
                          style: TextStyle(color: Colors.white), "save"),
                      onPressed: () => saveCup()),
                )
              ]),
            )));
  }

  String getValue() {
    if (center.admin) {
      return center.youthCenterName;
    } else {
      return dropdownValue;
    }
  }

  String getStatus(bool status) {
    if(status){
      return "Finished";
    }else{
      return "active";
    }
  }
}
