import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youth_center/FetchData.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/helper/shared_pref_helper.dart';
import 'package:youth_center/core/widgets/day_drop_down.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/models/cup_model.dart';
import 'package:youth_center/models/match_model.dart';
import 'package:youth_center/models/user_model.dart';
import 'package:youth_center/models/youth_center_model.dart';
import 'package:youth_center/screen/home/booking_service.dart';
import 'package:youth_center/screen/home/match_card.dart';

class MatchesOfActiveCups extends StatefulWidget {
  const MatchesOfActiveCups({super.key, required this.center});

  final CenterUser center;

  @override
  State<MatchesOfActiveCups> createState() => _MatchesState();
}

class _MatchesState extends State<MatchesOfActiveCups> {
  final BookingService bookingService = BookingService();

  late CenterUser center;
  late Stream<QuerySnapshot<Map<String, dynamic>>> collection;
  final List<MatchModel> matchesModels = [];
  final FetchData fetchData = FetchData();

  String dropdownValue = '';

  List<String> youthCenterNames = [];

  List<YouthCenterModel> youthCenters = [];
  bool get isAdmin => center.admin;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    center = widget.center;
    dropdownValue = center.youthCenterName;
    _fetchData();
    collection = getCollection();
  }

  Future<void> _fetchData() async {
    youthCenterNames = await SharedPrefHelper.getListString(
      MyConstants.prefCenterNames,
    );
    if (youthCenterNames.isEmpty) {
      youthCenters = await bookingService.getAllCenters();
      youthCenterNames = youthCenters.map((e) => e.name).toSet().toList();
      SharedPrefHelper.setData(MyConstants.prefCenterNames, youthCenterNames);
    }
        setState(() {});

  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCollection() {
    Stream<QuerySnapshot<Map<String, dynamic>>> collections =
        FirebaseFirestore.instance
            .collection(MyConstants.cupCollection)
            .where(
              MyConstants.youthCenterIdCollection,
              isEqualTo: isAdmin ? center.youthCenterName : dropdownValue,
            )
            .where(MyConstants.finished, isEqualTo: false)
            .snapshots();

    return collections;
  }

  List<MatchModel> extractMatches(QuerySnapshot snapshot) {
    matchesModels.clear();
    final cups =
        snapshot.docs
            .map(
              (doc) => CupModel.fromSnapshot(
                doc as DocumentSnapshot<Map<String, dynamic>>,
              ),
            )
            .toList();
    for (final cup in cups) {
      for (final match in cup.matches) {
        matchesModels.add(MatchModel.fromMap(match));
      }
    }

    return matchesModels;
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    return Column(
      children: [
        if (!isAdmin)
          DayDropdown(
            lableText: S.of(context).selectCenter,
            days: youthCenterNames,
            selectedDay: dropdownValue,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  dropdownValue = value;
                  collection = getCollection();
                });
              }
            },
          ),


       
        HelperMethods.verticalSpace(.02),

        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: collection,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(lang.wrong));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final matches = extractMatches(snapshot.data!);
              if (matches.isEmpty) {
                return Center(child: Text(lang.NoMatches));
              }

              return ListView.separated(
                itemCount: matches.length,
                separatorBuilder: (_, __) => HelperMethods.verticalSpace(.02),

                itemBuilder: (context, index) {
                  final match = matches[index];
                  return InteractiveMatchCard(
                    canUpdate: false,
                    match: match,
                    isAdmin: isAdmin,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
