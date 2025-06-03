import 'package:cloud_firestore/cloud_firestore.dart';

class CupModel {
  String id;
  String name;
  List teems;
  Timestamp timeStart;
  String youthCenterId;
  List<dynamic> matches;
String status;
  CupModel({
    required this.id,
    required this.name,
    required this.teems,
    required this.timeStart,
    required this.youthCenterId,
    required this.matches,
    required this.status,
  });

  toJson() {
    return {
      "name": name,
      "teems": teems,
      "timeStart": timeStart,
      "youthCenterId": youthCenterId,
      "matches": matches,
      "status": status
    };
  }

  factory CupModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    return CupModel(
      id: document.id,
      name: data!["name"],
      teems: data["teems"],
      timeStart: data["timeStart"],
      youthCenterId: data["youthCenterId"],
      matches: data['matches'],
      status: data['status'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "teems": teems,
      "timeStart": timeStart,
      "youthCenterId": youthCenterId,
      "matches": matches,
      "status": status,
    };
  }

  String getStatus() {
    return status;
  }

  void setStatus(String status) {
    this.status = status;
  }

  void setTime(Timestamp timeStart) {
    this.timeStart = timeStart;
  }

  Timestamp getTime() {
    return timeStart;
  }

  void setName(String name) {
    this.name = name;
  }
}
