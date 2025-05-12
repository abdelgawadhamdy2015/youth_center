import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/core/themes/colors.dart';
import 'package:youth_center/generated/l10n.dart';
import 'package:youth_center/models/cup_model.dart';
import 'package:youth_center/models/match_model.dart';
import 'package:youth_center/models/user_model.dart';
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
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          children: [
            if (!isAdmin)
              DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_drop_down),
                items:
                    [
                          dropdownValue,
                        ] 
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
            const SizedBox(height: 20),
            Text(
              lang.activeCupMatches,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
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
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final match = matches[index];
                      return MatchCard(
                        match: match,
                        isAdmin: isAdmin,
                        onScoreTap: () {
                          if (isAdmin) {
                            setState(() {
                              match.teem2Score++;
                            });
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MatchCard extends StatelessWidget {
  const MatchCard({
    super.key,
    required this.match,
    required this.isAdmin,
    required this.onScoreTap,
  });

  final MatchModel match;
  final bool isAdmin;
  final VoidCallback onScoreTap;

  @override
  Widget build(BuildContext context) {
    final FetchData fetchData = FetchData();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Center(
          child: Text(
            match.cupName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: Text(match.team1, textAlign: TextAlign.center)),
                const Icon(Icons.sports_soccer),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FittedBox(child: Text(fetchData.getDateTime(match.cupStartDate.toDate()), textAlign: TextAlign.center,)),
                      const SizedBox(height: 4),
                      Text(
                        "${fetchData.getScore(match, 1)} : ${fetchData.getScore(match, 2)}",
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.sports_soccer),
                Expanded(
                  child: GestureDetector(
                    onLongPress: onScoreTap,
                    child: Text(match.team2, textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
