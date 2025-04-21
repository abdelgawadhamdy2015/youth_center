import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String? id;
  final String name;
  final String mobile;
  final String timeEnd;
  final String timeStart;
  final String youthCenterId;

  const BookingModel(
      {this.id,
      required this.name,
      required this.mobile,
      required this.timeEnd,
      required this.timeStart,
      required this.youthCenterId});

  toJson() {
    return {
      "name": name,
      "mobile": mobile,
      "timeStart": timeStart,
      "timeEnd": timeEnd,
      "youthCenterId": youthCenterId
    };
  }

  factory BookingModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return BookingModel(
        id: document.id,
        name: data!["name"],
        mobile: data["mobile"],
        timeStart: data["timeStart"],
        timeEnd: data["timeEnd"],
        youthCenterId: data["youthCenterId"]);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "mobile": mobile,
      "timeEnd": timeEnd,
      "timeStart": timeStart,
      "youthCenterId": youthCenterId,

    };
  }

}
