import 'package:cloud_firestore/cloud_firestore.dart';

class YouthCenterModel {
  final String? id;
  final String name;
  final String mobile;
  final String telephone;


  const YouthCenterModel(
      {this.id, required this.name, required this.mobile, required this.telephone});

  toJson() {
    return {"name": name, "mobile": mobile, "telephone": telephone};
  }

  factory YouthCenterModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return YouthCenterModel(
        id: document.id,
        name: data!["name"],
        mobile: data["mobile"],
        telephone: data["telephone"]);
  }
}
