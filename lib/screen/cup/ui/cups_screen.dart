import 'dart:developer';

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
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/screen/cup/ui/widgets/tournament_card.dart';
import 'package:youth_center/screen/home/logic/home_controller.dart';

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

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    timeStartController.dispose();
    mobileController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adminValue = ref.watch(isAdminProvider);
    return SwipeDetector(
      onSwipeDown: (offset) => setState(() {}),
      child: GradientContainer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HelperMethods.buildHeader(
                context,
                S.of(context).tournaments,
                adminValue,
              ),
              _buildBody(adminValue),
            ],
          ),
        ),
      ),
    );
  }

  _buildBody(bool adminValue) {
    final youthcenterNames = ref.watch(youthCenterNamesProvider);
    final selectedCenter = ref.watch(selectedCenterNameProvider);
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
                      (centerNames) => DayDropdown(
                        days: centerNames,
                        selectedDay: selectedCenter,
                        onChanged: (days) {
                          ref.read(selectedCenterNameProvider.notifier).state =
                              days!;
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
                  log(cups.length.toString());
                  return Expanded(
                    child: ListView.builder(
                      itemCount: cups.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            TournamentCard(tournament: cups[index]),
                            HelperMethods.verticalSpace(.02),
                          ],
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
}

/*
  String getTime(int index) {
    var time = DateTime.fromMillisecondsSinceEpoch(
        (cups.elementAt(index).timeStart) * 1000);
  }*/
