import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/models/cup_model.dart';
import 'package:youth_center/models/match_model.dart';
import 'package:youth_center/models/user_model.dart';
import '../../fetch_data.dart';

class CupDetailScreen extends StatefulWidget {
  final CenterUser center;
  final CupModel cupModel;

  const CupDetailScreen({
    super.key,
    required this.center,
    required this.cupModel,
  });

  @override
  State<CupDetailScreen> createState() => _CupDetailScreenState();
}

class _CupDetailScreenState extends State<CupDetailScreen> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FetchData fetchData = FetchData();
  final TextEditingController nameController = TextEditingController();

  late CupModel cupModel;
  late CenterUser center;
  late Timestamp dateTime;
  late DateTime iniDate;

  List<List<String>> groupedTeams = List.generate(8, (_) => []);
  List<MatchModel> matchesModels = [];

  @override
  void initState() {
    super.initState();
    center = widget.center;
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
    return rawMatches.map((match) => MatchModel(
      team1: match[MyConstants.team1],
      team2: match[MyConstants.team2],
      cupStartDate: match[MyConstants.cupStartDate],
      teem1Score: match[MyConstants.team1Score],
      teem2Score: match[MyConstants.team2Score],
      cupName: match[MyConstants.cupName],
      cupGroup: match[MyConstants.cupGroup],
    )).toList();
  }

  Future<void> _saveCup(S lang) async {
    CupModel updatedCup = CupModel(
      id: cupModel.id,
      name: nameController.text,
      teems: cupModel.teems,
      timeStart: cupModel.timeStart,
      youthCenterId: cupModel.youthCenterId,
      matches: FetchData.listToJson(matchesModels),
      finished: cupModel.finished,
    );

    try {
      await db.collection(MyConstants.cupCollection).doc(cupModel.id).set(updatedCup.toJson());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.successSave), backgroundColor: Colors.green),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString()), backgroundColor: Colors.redAccent),
      );
    }
  }

  String _getStatusText(bool status, S lang) => status ? lang.finished : lang.active;

  TextStyle _headerStyle() => const TextStyle(fontSize: 18, color: Colors.white);

  Widget _buildGroupCard(List<String> group, String title) {
    return Visibility(
      visible: group.isNotEmpty,
      child: Column(
        children: [
          Text(title, style: _headerStyle()),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            width: 100,
            decoration: BoxDecoration(
              color: Colors.cyan.shade700,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: group.map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(e, style: const TextStyle(color: Colors.white)),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.appName),
        backgroundColor: MyColors.primaryColor,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(MyConstants.imag3),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (center.admin)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${lang.finished}?", style: _headerStyle()),
                    Checkbox(
                      value: cupModel.getStatus(),
                      onChanged: (val) => setState(() => cupModel.finished = val!),
                    ),
                  ],
                )
              else
                Text(_getStatusText(cupModel.getStatus(), lang), style: _headerStyle()),

              const SizedBox(height: 10),
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
              const SizedBox(height: 20),

              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: List.generate(groupedTeams.length, (i) => _buildGroupCard(groupedTeams[i], '${lang.group} ${i + 1}')),
              ),

              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: matchesModels.length,
                itemBuilder: (context, index) {
                  final match = matchesModels[index];

                  return SwipeDetector(
                    onSwipeRight: (_) => setState(() => match.teem2Score--),
                    onSwipeLeft: (_) => setState(() => match.teem1Score--),
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onLongPress: () => setState(() => match.teem1Score++),
                              child: Text(match.team1),
                            ),
                            Column(
                              children: [
                                MaterialButton(
                                  onPressed: () async {
                                    DateTime? newDate = await showDatePicker(
                                      context: context,
                                      initialDate: iniDate,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );
                                    if (newDate == null) return;

                                    TimeOfDay? newTime = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(iniDate),
                                    );
                                    if (newTime == null) return;

                                    iniDate = DateTime(
                                      newDate.year,
                                      newDate.month,
                                      newDate.day,
                                      newTime.hour,
                                      newTime.minute,
                                    );
                                    setState(() {
                                      dateTime = Timestamp.fromDate(iniDate);
                                      match.setTime(dateTime);
                                    });
                                  },
                                  child: Text(fetchData.getDateTime(match.cupStartDate.toDate())),
                                ),
                                Text("${match.teem1Score} : ${match.teem2Score}"),
                              ],
                            ),
                            InkWell(
                              onLongPress: () => setState(() => match.teem2Score++),
                              child: Text(match.team2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              if (center.admin)
                ElevatedButton(
                  onPressed: () => _saveCup(lang),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text(lang.save, style: const TextStyle(color: Colors.white)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
