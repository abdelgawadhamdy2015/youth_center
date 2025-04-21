import 'package:cloud_firestore/cloud_firestore.dart';

class CupModel {
  final String id;
   String name;
  final List teems;
  Timestamp timeStart;
  final String youthCenterId;
  List<dynamic> matches;
  bool finished;

   CupModel(
      {required this.id,
      required this.name,
      required this.teems,
      required this.timeStart,
      required this.youthCenterId,
     required this.matches,
        required this.finished

      });


  toJson() {

    return {
      "name": name,
      "teems": teems,
      "timeStart": timeStart,
      "youthCenterId": youthCenterId,
    "matches": matches,
      "finished": finished,

    };
  }

  factory CupModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return CupModel(
        id: document.id,
        name: data!["name"],
        teems: data["teems"],
        timeStart: data["timeStart"],
        youthCenterId: data["youthCenterId"],
       matches: data['matches']  ,
        finished: data['finished']
        );
  }



  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "teems": teems,
      "timeStart": timeStart,
      "youthCenterId": youthCenterId,
      "matches": matches,
      "finished": finished,
    };
  }
  bool getStatus() {
    return finished;
  }
  void setStatus(bool finished) {
   this.finished=finished;
  }
  void setTime(Timestamp timeStart) {
    this.timeStart=timeStart;
  }
  Timestamp getTime() {
    return timeStart;
  }
  void setName(String name) {
    this.name=name;
  }
}
