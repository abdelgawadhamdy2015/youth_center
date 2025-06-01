import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:intl/intl.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/core/widgets/body_container.dart';
import 'package:youth_center/core/widgets/day_drop_down.dart';
import 'package:youth_center/core/widgets/grediant_container.dart';
import 'package:youth_center/core/widgets/header.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/models/cup_model.dart';
import 'package:youth_center/screen/cup/create_cup.dart';
import 'package:youth_center/screen/cup/cup_detail_screen.dart';
import 'package:youth_center/screen/home/home_controller.dart';

class CupScreen extends ConsumerStatefulWidget {
  const CupScreen({super.key});

  @override
  ConsumerState<CupScreen> createState() {
    return Cup();
  }
}

class Cup extends ConsumerState<CupScreen> {
  Cup();

  final dateFormat = DateFormat('dd/MM/y');

  double groups = 2;

  List<TextEditingController> controllers = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController timeStartController = TextEditingController();
  TextEditingController timeEndController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  List<String> teams = [];
// bool randomTeams = false;
//   bool matches = false;

  @override
  void initState() {
    super.initState();
  }

  TextStyle getTextStyle() {
    return TextStyle(
      fontSize: 18,
      color: Colors.black,
      backgroundColor: ColorManger.mainBlue,
    );
  }

  int getGroups() {
    if (teams.isEmpty) {
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

  
  // getVisibility() {
  //   if (randomTeams && matches) {
  //     return true;
  //   } else if (!randomTeams && matches) {}
  // }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    timeStartController.dispose();
    mobileController.dispose();
  }

  // Future<List<CupModel>> getCups() async {
  //   snapshot1 =
  //       await db
  //           .collection(MyConstants.cupCollection)
  //           .where(
  //             MyConstants.youthCenterIdCollection,
  //             isEqualTo: adminValue ? center.youthCenterName : dropdownValue,
  //           )
  //           .get();
  //   cups = snapshot1.docs.map((e) => CupModel.fromSnapshot(e)).toList();
  //   print(cups.length.toString());
  //   return cups;
  // }

  @override
  Widget build(BuildContext context) {
    final adminValue = ref.watch(isAdminProvider);
    return Scaffold(
      floatingActionButton: Visibility(
        visible: adminValue,
        child: Container(
          padding: EdgeInsets.all(50),
          alignment: AlignmentDirectional.bottomEnd,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCupScreen()),
              );
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
      body: SwipeDetector(
        onSwipeDown: (offset) => setState(() {}),
        child: GradientContainer(
          child: Column(
            children: [
              Header(title: S.of(context).tournaments),
              _buildBody(adminValue),
            ],
          ),
        ),
      ),
    );
  }

  _buildBody(bool adminValue) {
    final youthcenterNames = ref.watch(youthCenterNamesProvider);
    final selectedDay = ref.watch(selectedDayProvider);
    final cupsProviderAsync = ref.watch(cupsProvider);
    return BodyContainer(
      height: SizeConfig.screenHeight! * .85,
      child: Stack(
        children: [
          Column(
            children: [
              Visibility(
                visible: !adminValue,
                child: youthcenterNames.when(
                  data:
                      (days) => DayDropdown(
                        days: days,
                        selectedDay: selectedDay,
                        onChanged: (days) {
                          ref.read(selectedDayProvider.notifier).state = days!;
                        },
                      ),
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                ),
              ),
              HelperMethods.verticalSpace(.02),
              cupsProviderAsync.when(
                data: (cups) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: cups.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Card(
                            margin: const EdgeInsets.all(10),
                            color: Colors.white,
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                  HelperMethods.verticalSpace(.02),
                                  Text(getStatus(cups.elementAt(index))),
                                  HelperMethods.verticalSpace(.02),
                                  const Icon(Icons.sports_baseball),
                                  HelperMethods.verticalSpace(.02),
                                  Text(cups.elementAt(index).youthCenterId),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => CupDetailScreen(
                                      cupModel: cups.elementAt(index),
                                    ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // String getValue() {
  //   if (adminValue) {
  //     return center.youthCenterName;
  //   } else {
  //     return dropdownValue;
  //   }
  // }

  String getStatus(CupModel cupModel) {
    if (cupModel.finished) {
      return S.of(context).finished;
    } else {
      return S.of(context).active;
    }
  }
}

/*
  String getTime(int index) {
    var time = DateTime.fromMillisecondsSinceEpoch(
        (cups.elementAt(index).timeStart) * 1000);
  }*/
