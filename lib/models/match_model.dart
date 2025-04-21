import 'package:cloud_firestore/cloud_firestore.dart';

class MatchModel {
  final String? id;
  final String firstTeem;
  final String secondTeem;
  Timestamp time;
  int firstTeemScore;
  int secondTeemScore;
  final String youthCenterId;
  final String cupName;

  getTime() {
    return time;
  }

  setTime(Timestamp dateTime) {
    time = dateTime;
  }

  MatchModel(
      {this.id,
      required this.firstTeem,
      required this.secondTeem,
      required this.time,
      required this.firstTeemScore,
      required this.secondTeemScore,
      required this.youthCenterId,
      required this.cupName});

  toJson() {
    return {
      "firstTeem": firstTeem,
      "secondTeem": secondTeem,
      "time": time,
      "firstTeemScore": firstTeemScore,
      "secondTeemScore": secondTeemScore,
      "youthCenterId": youthCenterId,
      "cupName": cupName
    };
  }

  factory MatchModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return MatchModel(
        id: document.id,
        firstTeem: data!["firstTeem"],
        secondTeem: data["secondTeem"],
        time: data["time"],
        firstTeemScore: data["firstTeemScore"],
        secondTeemScore: data["secondTeemScore"],
        youthCenterId: data["youthCenterId"],
        cupName: data["cupName"]);
  }

  factory MatchModel.fromMap(Map data) {
    return MatchModel(
        id: data['id'] ?? '',
        firstTeem: data['firstTeem'] ?? '',
        secondTeem: data['secondTeem'] ?? '',
        time: data['time'] ?? '',
        youthCenterId: data['youthCenterId'] ?? '',
        firstTeemScore: data['firstTeemScore'] ?? '',
        secondTeemScore: data['secondTeemScore'] ?? '',
        cupName: data['cupName'] ?? '');
  }

  Map<String, dynamic> toFirestore() {
    return {
      "firstTeem": firstTeem,
      "secondTeem": secondTeem,
      "time": time,
      "secondTeemScore": secondTeemScore,
      "youthCenterId": youthCenterId,
    };
  }
}
