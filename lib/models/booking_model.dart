import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String? id;
  final String? userId;
  final String name;
  final String mobile;
  final String timeEnd;
  final String timeStart;
  final String youthCenterId;
  final String day;
  final String date;
  final int? status;

  const BookingModel({
    this.id,
    this.userId,
    required this.name,
    required this.mobile,
    required this.timeEnd,
    required this.timeStart,
    required this.youthCenterId,
    required this.day,
    required this.date,
    this.status,
  });
  BookingModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? mobile,
    String? timeEnd,
    String? timeStart,
    String? youthCenterId,
    String? day,
    String? date,
    int? status,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      timeEnd: timeEnd ?? this.timeEnd,
      timeStart: timeStart ?? this.timeStart,
      youthCenterId: youthCenterId ?? this.youthCenterId,
      day: day ?? this.day,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }
  toJson() {
    return {
      "date": date,
      "day": day,
      "name": name,
      "mobile": mobile,
      "timeStart": timeStart,
      "timeEnd": timeEnd,
      "youthCenterId": youthCenterId,
      "userId": userId,
      "status": status,
    };
  }

  factory BookingModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    return BookingModel(
      id: document.id,
      userId: data!["userId"],
      date: data["date"],
      day: data["day"],
      name: data["name"],
      mobile: data["mobile"],
      timeStart: data["timeStart"],
      timeEnd: data["timeEnd"],
      youthCenterId: data["youthCenterId"],
      status: data["status"],
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
      "userId": userId,
      "status": status,
    };
  }
}
