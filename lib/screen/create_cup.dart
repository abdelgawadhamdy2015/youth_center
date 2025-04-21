import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youth_center/models/booking_model.dart';
import 'package:youth_center/models/cup_model.dart';
import 'package:youth_center/models/match_model.dart';
import 'package:youth_center/models/user_model.dart';


import '../FetchData.dart';

class AddCupScreen extends StatefulWidget {
  const AddCupScreen({super.key, required this.center});

  final CenterUser center;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddCup(center: center);
  }
}

class AddCup extends State<AddCupScreen> {
  bool manual = true;

  AddCup({required this.center});

  List<List<dynamic>> listOfGroups = [];
  double groups = 2;
  bool matches = false;
  bool cupSaved = false;

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
  DateTime iniDate = DateTime(2023, 7, 14, 10, 30);
  late Random random;
  CenterUser center;
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
  late Timer timer;
  late Timestamp dateTime = Timestamp(30000, 100000);
  int groupStatus = 0; // 0= manual , 1= automatic
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    for (int i = 0; i < teemsCount; i++) {
      controllers.add(TextEditingController());
    }
    print(center.youthCenterName);
  }

  TextStyle getTextStyle() {
    return const TextStyle(
        fontSize: 18, color: Colors.black, backgroundColor: Colors.amber);
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

  Future saveCup() async {
    List<dynamic> josonMatchesList = fetchData.listToJson(matchesModels);

    Future.delayed(const Duration(milliseconds: 500));
    cupModel = CupModel(
        id: nameController.text.trim(),
        name: nameController.text,
        teems: teems,
        timeStart: dateTime,
        youthCenterId: center.youthCenterName,
        matches: josonMatchesList,
        finished: false);
    db
        .collection("Cups")
        .doc(nameController.text.trim())
        .set(cupModel.toJson())
        .whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("cup added successfully"),
        backgroundColor: Colors.redAccent,
        elevation: 10, //shadow
      ));

      cupSaved = true;
      clear();
    }).catchError(
            (error) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(error.toString()),
                  backgroundColor: Colors.redAccent,
                  elevation: 10, //shadow
                )));
  }

  saveMatches(List anyList) {
    if (anyList.isNotEmpty) {
      matchesModels.add(
        MatchModel(
            firstTeem: anyList.elementAt(0),
            secondTeem: anyList.elementAt(1),
            time: dateTime,
            firstTeemScore: 0,
            secondTeemScore: 0,
            youthCenterId: center.youthCenterName,
            cupName: nameController.text),
      );
      matchesModels.add(MatchModel(
          firstTeem: anyList.elementAt(2),
          secondTeem: anyList.elementAt(3),
          time: dateTime,
          firstTeemScore: 0,
          secondTeemScore: 0,
          youthCenterId: center.youthCenterName,
          cupName: nameController.text));
      matchesModels.add(MatchModel(
          firstTeem: anyList.elementAt(0),
          secondTeem: anyList.elementAt(2),
          time: dateTime,
          firstTeemScore: 0,
          secondTeemScore: 0,
          youthCenterId: center.youthCenterName,
          cupName: nameController.text));
      matchesModels.add(MatchModel(
          firstTeem: anyList.elementAt(2),
          secondTeem: anyList.elementAt(1),
          time: dateTime,
          firstTeemScore: 0,
          secondTeemScore: 0,
          youthCenterId: center.youthCenterName,
          cupName: nameController.text));
      matchesModels.add(MatchModel(
          firstTeem: anyList.elementAt(0),
          secondTeem: anyList.elementAt(3),
          time: dateTime,
          firstTeemScore: 0,
          secondTeemScore: 0,
          youthCenterId: center.youthCenterName,
          cupName: nameController.text));
      matchesModels.add(MatchModel(
          firstTeem: anyList.elementAt(1),
          secondTeem: anyList.elementAt(3),
          time: dateTime,
          firstTeemScore: 0,
          secondTeemScore: 0,
          youthCenterId: center.youthCenterName,
          cupName: nameController.text));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    timeStartController.dispose();
    mobileController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            //controller: ScrollController(),
            scrollDirection: Axis.vertical,
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              Visibility(
                visible: !randomTeems,
                child: Container(
                  color: Colors.grey,
                  // alignment: Alignment.center,
                  //    padding: EdgeInsets.only(left: 50),
                  child: Column(children: [
                    TextField(
                        textAlign: TextAlign.center,
                        controller: nameController,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            /*icon:
                                Icon(Icons.sports_baseball, color: Colors.red),*/
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "اسم البطولة ")),
                    MaterialButton(
                        onPressed: () async {
                          DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: iniDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100));
                          if (newDate == null) return;

                          TimeOfDay? newTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                  hour: iniDate.hour, minute: iniDate.minute));
                          if (newTime == null) return;
                          iniDate = DateTime(newDate.year, newDate.month,
                              newDate.day, newTime.hour, newTime.minute);
                          setState(() {
                            dateTime = Timestamp.fromDate(iniDate);
                          });
                        },
                        child: Text(
                            textAlign: TextAlign.center,
                            fetchData.getDateTime(dateTime.toDate()))),
                    const Text(
                        style: TextStyle(fontSize: 20),
                        "برجاء اختيار عدد الفرق المشاركة في البطولة"),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            teems.clear();
                            controllers.clear();
                            if (teemsCount > 0) {
                              groups = teemsCount / 4;
                              setState(() {
                                teemsCount = teemsCount - 8;
                                for (int i = 0; i < teemsCount; i++) {
                                  controllers.add(TextEditingController());
                                }
                              });
                            }
                          },
                          child: const Text(
                            "<",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Text(
                          teemsCount.toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                        MaterialButton(
                          onPressed: () {
                            teems.clear();
                            controllers.clear();
                            if (teemsCount < 32) {
                              groups = teemsCount / 4;
                              setState(() {
                                teemsCount = teemsCount + 8;
                                for (int i = 0; i < teemsCount; i++) {
                                  controllers.add(TextEditingController());
                                }
                                print(controllers.length.toString());
                              });
                            }
                          },
                          child: const Text(
                            ">",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            if (groupStatus == 0) {
                              setState(() {
                                groupStatus = 1;
                                manual = false;
                              });
                            } else {
                              setState(() {
                                groupStatus = 0;
                                manual = true;
                              });
                            }
                          },
                          child: const Text(
                            "<",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Text(
                          getgroupStatus(),
                          style: const TextStyle(fontSize: 20),
                        ),
                        MaterialButton(
                          onPressed: () {
                            if (groupStatus == 0) {
                              setState(() {
                                groupStatus = 1;
                                manual = false;
                              });
                            } else {
                              setState(() {
                                groupStatus = 0;
                                manual = true;
                              });
                            }
                          },
                          child: const Text(
                            ">",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: manual,
                      child: const Text(
                          "برجاء ادخال الفرق بالترتيب بحيث كل صف يتكون من مجموعة",
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center),
                    ),
                  ]),
                ),
              ),
              SizedBox(
                height: getSizeBoxHight(),
              ),
              Visibility(
                visible: !randomTeems,
                child: GridView.count(
                  primary: false,
                  shrinkWrap: true,
                  // Create a grid with  columns. If you change the scrollDirection to
                  // horizontal, this produces  rows.
                  crossAxisCount: 4,
                  crossAxisSpacing: 5,
                  // Generate  widgets that display their index in the List.
                  children: List.generate(teemsCount, (index) {
                    // print("inex"+index.toString());
                    return Column(children: [
                      TextField(
                          controller: controllers.elementAt(index),
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              /*icon:
                                Icon(Icons.sports_baseball, color: Colors.red),*/
                              filled: true,
                              fillColor: Colors.amber,
                              hintText: "اسم الفريق ")),
                      /* const SizedBox(
                          width: 10,
                        ),*/
                    ]);
                  }),
                ),
              ),
              Visibility(
                  visible: randomTeems,
                  child: Column(
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
                  )),
              SizedBox(
                height: getSizeBoxHight(),
              ),
              Visibility(
                visible: matches,
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
                                Text(
                                  matchesModels.elementAt(index).firstTeem,
                                  maxLines: 2,
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
                                                      minute: iniDate.minute));
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
                                        },
                                        child: Text(
                                            textAlign: TextAlign.center,
                                            //maxLines: 2,
                                            fetchData.getDateTime(matchesModels
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
                                Text(
                                  matchesModels.elementAt(index).secondTeem,
                                  maxLines: 2,
                                )
                              ],
                            ),
                          )),
                      onTap: () => {
                        if (adminValue)
                          {
                            /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateBooking(
                                    booking: bookingDataByCenter
                                        .elementAt(index),
                                  )),
                            ),*/
                          }
                      },
                    );
                  },
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.blue)),
                        child: const Text(
                            style: TextStyle(color: Colors.white), "Back"),
                        onPressed: () => clear()),
                    const SizedBox(
                      width: 70,
                    ),
                    ElevatedButton(
                      statesController: MaterialStatesController(),
                      onPressed: next,
                      child: const Text("Next"),
                    )
                  ]),
            ]),
          ),
        ));
  }

  next() {
    if (teemsCount > 0) {
      if (!randomTeems) {
        if (controllers.length >= teemsCount) {
          for (int i = 0; i < controllers.length; i++) {
            if (controllers.elementAt(i).text.isNotEmpty) {
              teems.add(controllers.elementAt(i).text.toString().trim());
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("please fill all teems names  "),
                backgroundColor: Colors.redAccent,
                elevation: 10, //shadow
              ));
              return;
            }
          }

          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              randomTeems = true;
              if (!manual) {
                teems.shuffle();
              }
            });

            for (int i = 0; i < teems.length; i++) {
              setState(() {
                if (firstList.length < 4 &&
                    !selectedRondomTeems.contains(teems.elementAt(i))) {
                  firstList.add(teems.elementAt(i));
                  selectedRondomTeems.add(teems.elementAt(i));
                  if (firstList.length == 4) {
                    saveMatches(firstList);
                    listOfGroups.add(firstList);
                  }
                } else if (secondList.length < 4 &&
                    !selectedRondomTeems.contains(teems.elementAt(i))) {
                  secondList.add(teems.elementAt(i));
                  selectedRondomTeems.add(teems.elementAt(i));
                  if (secondList.length == 4) {
                    saveMatches(secondList);
                    listOfGroups.add(secondList);
                  }
                } else if (thirdList.length < 4 &&
                    !selectedRondomTeems.contains(teems.elementAt(i))) {
                  thirdList.add(teems.elementAt(i));
                  selectedRondomTeems.add(teems.elementAt(i));
                  if (thirdList.length == 4) {
                    saveMatches(thirdList);
                    listOfGroups.add(thirdList);
                  }
                } else if (fourList.length < 4 &&
                    !selectedRondomTeems.contains(teems.elementAt(i))) {
                  fourList.add(teems.elementAt(i));
                  selectedRondomTeems.add(teems.elementAt(i));
                  if (fourList.length == 4) {
                    saveMatches(fourList);
                    listOfGroups.add(fourList);
                  }
                } else if (fiveList.length < 4 &&
                    !selectedRondomTeems.contains(teems.elementAt(i))) {
                  fiveList.add(teems.elementAt(i));
                  selectedRondomTeems.add(teems.elementAt(i));
                  if (fiveList.length == 4) {
                    saveMatches(fiveList);
                    listOfGroups.add(fiveList);
                  }
                } else if (sixList.length < 4 &&
                    !selectedRondomTeems.contains(teems.elementAt(i))) {
                  sixList.add(teems.elementAt(i));
                  selectedRondomTeems.add(teems.elementAt(i));
                  if (sixList.length == 4) {
                    saveMatches(sixList);
                    listOfGroups.add(sixList);
                  }
                } else if (sevenList.length < 4 &&
                    !selectedRondomTeems.contains(teems.elementAt(i))) {
                  sevenList.add(teems.elementAt(i));
                  selectedRondomTeems.add(teems.elementAt(i));
                  if (sevenList.length == 4) {
                    saveMatches(sevenList);
                    listOfGroups.add(sevenList);
                  }
                } else if (eightList.length < 4 &&
                    !selectedRondomTeems.contains(teems.elementAt(i))) {
                  eightList.add(teems.elementAt(i));
                  selectedRondomTeems.add(teems.elementAt(i));
                  if (eightList.length == 4) {
                    saveMatches(eightList);
                    listOfGroups.add(eightList);
                  }
                }
              });
            }
            /* if (eightList.isNotEmpty) {
                                    saveMatches(eightList);
                                  }*/

            //  Future.delayed(Duration(milliseconds: 400));
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("please fill all teems names  "),
            backgroundColor: Colors.redAccent,
            elevation: 10, //shadow
          ));
        }
      } else if (randomTeems && !matches) {
        setState(() {
          matches = true;
        });
      } else if (randomTeems && matches) {
        saveCup();
      }
    }
  }

  clear() {
    setState(() {
      if (!randomTeems && !matches) {
        teems.clear();
        teemsCount = 0;
        controllers.clear();
      } else if (randomTeems && !matches) {
        randomTeems = false;
        firstList.clear();
        secondList.clear();
        thirdList.clear();
        fourList.clear();
        fiveList.clear();
        sixList.clear();
        sevenList.clear();
        eightList.clear();
        selectedRondomTeems.clear();
        matchesModels.clear();
        listOfGroups.clear();
        teems.clear();
      } else if (randomTeems && matches) {
        matches = false;
      }
      if (cupSaved) {
        teems.clear();
        teemsCount = 0;
        controllers.clear();
        randomTeems = false;
        firstList.clear();
        secondList.clear();
        thirdList.clear();
        fourList.clear();
        fiveList.clear();
        sixList.clear();
        sevenList.clear();
        eightList.clear();
        selectedRondomTeems.clear();
        matchesModels.clear();
        listOfGroups.clear();
        nameController.clear();
        matches = false;
      }
    });
  }

  String getgroupStatus() {
    if (groupStatus == 0) {
      return "يدوي";
    } else {
      return "عشوائي";
    }
  }
}
