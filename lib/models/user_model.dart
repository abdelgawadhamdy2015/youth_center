import 'package:cloud_firestore/cloud_firestore.dart';

class CenterUser {
  final String? id;
  final String name;
  final String mobile;
  final String email;
  final String youthCenterName;
  final bool admin;

  const CenterUser(
      {this.id,
      required this.name,
      required this.mobile,
      required this.email,
      required this.youthCenterName,
      required this.admin});

  toJson() {
    return {
      "name": name,
      "mobile": mobile,
      "email": email,
      "youthCenterName": youthCenterName,
      "admin" : admin
    };
  }

  CenterUser.fromJson(Map<String, dynamic> json)
      : this(
           // id: json['id']! as String,
            name: json['name']! as String,
            mobile: json['mobile']! as String,
            email: json['email']! as String,
            admin: json['admin']! ,
            youthCenterName: json['youthCenterName']! as String,
  );

  factory CenterUser.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return CenterUser(
        id: document.id,
        name: data!["name"],
        mobile: data["mobile"],
        email: data["email"],
        admin: data['admin'],
        youthCenterName: data["youthCenterName"]);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "mobile": mobile,
      "timeEnd": email,
      'admin' : admin,
      "youthCenterName": youthCenterName,
    };
  }
}
