import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youth_center/FetchData.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/size_config.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/core/widgets/app_text_button.dart';
import 'package:youth_center/core/widgets/body_container.dart';
import 'package:youth_center/core/widgets/grediant_container.dart';
import 'package:youth_center/core/widgets/header.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/models/cup_model.dart';
import 'package:youth_center/models/match_model.dart';
import 'package:youth_center/screen/cup/cups_controller.dart';
import 'package:youth_center/screen/cup/cups_screen.dart';
import 'package:youth_center/screen/home/home_controller.dart';
import 'package:youth_center/screen/home/match_card.dart';

class CupDetailScreen extends ConsumerStatefulWidget {
  final CupModel cupModel;

  const CupDetailScreen({super.key, required this.cupModel});

  @override
  ConsumerState<CupDetailScreen> createState() => _CupDetailScreenState();
}

class _CupDetailScreenState extends ConsumerState<CupDetailScreen> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FetchData fetchData = FetchData();
  final TextEditingController nameController = TextEditingController();

  late CupModel cupModel;
  late Timestamp dateTime;
  late DateTime iniDate;

  List<List<String>> groupedTeams = List.generate(8, (_) => []);
  List<MatchModel> matchesModels = [];
  final List<dynamic> _jsonMatches = [];

  @override
  void initState() {
    super.initState();
    cupModel = widget.cupModel;
    nameController.text = cupModel.name;
    iniDate = DateTime.now();

    _splitTeams();
    matchesModels = _parseMatches(cupModel.matches);
  }

  void _splitTeams() {
    List teams = cupModel.teems;
    for (int i = 0; i < teams.length && i < 32; i++) {
      groupedTeams[i ~/ 4].add(teams[i]);
    }
  }

  List<MatchModel> _parseMatches(List<dynamic> rawMatches) {
    return rawMatches
        .map(
          (match) => MatchModel(
            team1: match[MyConstants.team1],
            team2: match[MyConstants.team2],
            cupStartDate: match[MyConstants.cupStartDate],
            teem1Score: match[MyConstants.team1Score],
            teem2Score: match[MyConstants.team2Score],
            cupName: match[MyConstants.cupName],
            cupGroup: match[MyConstants.cupGroup],
          ),
        )
        .toList();
  }

  Future<void> _saveCup(S lang) async {
    for (var match in matchesModels) {
      _jsonMatches.add(match.toJson());
    }

    CupModel updatedCup = CupModel(
      id: cupModel.id,
      name: nameController.text,
      teems: cupModel.teems,
      timeStart: cupModel.timeStart,
      youthCenterId: cupModel.youthCenterId,
      matches: _jsonMatches,
      status: cupModel.status,
    );

    ref
        .read(cupsControllerProvider)
        .updateCup(updatedCup)
        .then((_) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(lang.successSave)));
          ref.invalidate(cupsProvider);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CupScreen()),
          );
        })
        .catchError((error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        });
  }

  Future<void> _deleteCup(S lang) async {
    ref
        .read(cupsControllerProvider)
        .deleteCup(cupModel.id)
        .then((_) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(lang.successSave)));
          ref.invalidate(cupsProvider);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CupScreen()),
          );
        })
        .catchError((error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        });
  }

  TextStyle _headerStyle() =>
      const TextStyle(fontSize: 18, color: Colors.white);

  Widget _buildGroupCard(List<String> group, String title) {
    return Visibility(
      visible: group.isNotEmpty,
      child: Column(
        children: [
          Text(title, style: _headerStyle()),
          HelperMethods.verticalSpace(.02),

          Container(
            padding: const EdgeInsets.all(10),
            width: 100,
            decoration: BoxDecoration(
              color: ColorManger.backGroundGray,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children:
                  group
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            e,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final isAdmin = ref.watch(isAdminProvider);
    return Scaffold(
      body: GradientContainer(
        child: Column(
          children: [Header(title: lang.tournament), _buildBody(lang, isAdmin)],
        ),
      ),
    );
  }

  _buildBody(S lang, bool isAdmin) {
    return BodyContainer(
      height: SizeConfig.screenHeight! * .85,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: SingleChildScrollView(
        child: Column(
          children: [
           

            HelperMethods.verticalSpace(.02),

            TextField(
              controller: nameController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: lang.cupName,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: const EdgeInsets.all(10),
              ),
            ),
            HelperMethods.verticalSpace(.02),

            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: SizeConfig.screenWidth! / 5,
              runSpacing: SizeConfig.screenWidth! * .01,
              children: List.generate(
                groupedTeams.length,
                (i) =>
                    _buildGroupCard(groupedTeams[i], '${lang.group} ${i + 1}'),
              ),
            ),

            HelperMethods.verticalSpace(.02),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: matchesModels.length,
              itemBuilder: (context, index) {
                final match = matchesModels[index];
                return InteractiveMatchCard(
                  canUpdate: (isAdmin && !true),
                  match: match,
                  isAdmin: isAdmin,
                );
              },
            ),

            if (isAdmin)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppButtonText(
                    buttonWidth: SizeConfig.screenWidth! * .4,
                    backGroundColor: ColorManger.buttonGreen,
                    textStyle: GoogleFonts.tajawal(
                      color: Colors.white,
                      fontSize: SizeConfig.fontSize3!,
                    ),
                    butonText: lang.save,
                    onPressed: () => _saveCup(lang),
                  ),
                  AppButtonText(
                    buttonWidth: SizeConfig.screenWidth! * .4,
                    backGroundColor: ColorManger.redButtonColor,
                    textStyle: GoogleFonts.tajawal(
                      color: Colors.white,
                      fontSize: SizeConfig.fontSize3!,
                    ),
                    butonText: lang.delete,
                    onPressed: () => _deleteCup(lang),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
