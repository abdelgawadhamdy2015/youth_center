import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String? id;
  final String name;
  final String mobile;
  final String timeEnd;
  final String timeStart;
  final String youthCenterId;
  final String day;
  final String date;

  const BookingModel({
    this.id,
    required this.name,
    required this.mobile,
    required this.timeEnd,
    required this.timeStart,
    required this.youthCenterId,
    required this.day,
    required this.date,
  });

  toJson() {
    return {
      "date": date,
      "day": day,
      "name": name,
      "mobile": mobile,
      "timeStart": timeStart,
      "timeEnd": timeEnd,
      "youthCenterId": youthCenterId,
    };
  }

  factory BookingModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    return BookingModel(
      date: data!["date"],
      id: document.id,
      day: data["day"],
      name: data["name"],
      mobile: data["mobile"],
      timeStart: data["timeStart"],
      timeEnd: data["timeEnd"],
      youthCenterId: data["youthCenterId"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "date": date,
      "day": day,
      "name": name,
      "mobile": mobile,
      "timeEnd": timeEnd,
      "timeStart": timeStart,
      "youthCenterId": youthCenterId,
    };
  }
}
