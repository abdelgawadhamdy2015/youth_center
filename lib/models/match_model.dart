import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youth_center/core/helper/my_constants.dart';

class MatchModel {
  final String? id;
  final String team1;
  final String team2;
  DateTime matchTime;
  int teem1Score;
  int teem2Score;
  String cupName;
  String cupGroup;
  getTime() {
    return matchTime;
  }

  setTime(DateTime dateTime) {
    matchTime = dateTime;
  }

  MatchModel({
    this.id,
    required this.team1,
    required this.team2,
    required this.matchTime,
    required this.teem1Score,
    required this.teem2Score,
    required this.cupName,
    required this.cupGroup,
  });

  toJson() {
    return {
      MyConstants.team1: team1,
      MyConstants.team2: team2,
      MyConstants.matchTime: matchTime.toIso8601String(),
      MyConstants.team1Score: teem1Score,
      MyConstants.team2Score: teem2Score,
      MyConstants.cupName: cupName,
      MyConstants.cupGroup: cupGroup,
    };
  }

  factory MatchModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    return MatchModel(
      id: document.id,
      team1: data![MyConstants.team1],
      team2: data[MyConstants.team2],
      matchTime: DateTime.parse(data[MyConstants.matchTime]),
      teem1Score: data[MyConstants.team1Score],
      teem2Score: data[MyConstants.team2Score],
      cupName: data[MyConstants.cupName],
      cupGroup: data[MyConstants.cupGroup],
    );
  }

  factory MatchModel.fromMap(Map data) {
    return MatchModel(
      id: data[MyConstants.id] ?? '',
      team1: data[MyConstants.team1] ?? '',
      team2: data[MyConstants.team2] ?? '',
      matchTime: DateTime.parse(
        data[MyConstants.matchTime] ?? DateTime.now().toIso8601String(),
      ),
      teem1Score: data[MyConstants.team1Score] ?? '',
      teem2Score: data[MyConstants.team2Score] ?? '',
      cupName: data[MyConstants.cupName],
      cupGroup: MyConstants.cupGroup,
    );
  }
}
