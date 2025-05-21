import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youth_center/core/helper/helper_methods.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/models/cup_model.dart';
import 'package:youth_center/models/match_model.dart';
import 'package:youth_center/models/user_model.dart';
import 'package:youth_center/screen/home/match_card.dart';
import '../../fetch_data.dart';

class MatchesOfActiveCups extends StatefulWidget {
  const MatchesOfActiveCups({super.key, required this.center});

  final CenterUser center;

  @override
  State<MatchesOfActiveCups> createState() => _MatchesState();
}

class _MatchesState extends State<MatchesOfActiveCups> {
  late CenterUser center;
  late Stream<QuerySnapshot<Map<String, dynamic>>> collection;
  final List<MatchModel> matchesModels = [];
  final FetchData fetchData = FetchData();

  String dropdownValue = '';
  bool get isAdmin => center.admin;

  @override
  void initState() {
    super.initState();
    center = widget.center;
    dropdownValue = center.youthCenterName;
    collection = getCollection();
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
    return  Column(
      children: [
        if (!isAdmin)
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_drop_down),
            items:
                [dropdownValue]
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  dropdownValue = value;
                  collection = getCollection();
                });
              }
            },
          ),
      if(!isAdmin)                                   HelperMethods.verticalSpace(.02),

        Text(
          lang.activeCupMatches,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                separatorBuilder: (_, __) =>                                  HelperMethods.verticalSpace(.02),

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


