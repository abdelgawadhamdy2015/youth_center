import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/models/booking_model.dart';
import 'package:youth_center/models/cup_model.dart';
import 'package:youth_center/models/youth_center_model.dart';


class BookingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<BookingModel>> getAllBookings() async {
    final snapshot = await _db.collection(MyConstants.bookingCollection).get();
    return snapshot.docs.map((e) => BookingModel.fromSnapshot(e)).toList();
  }

  Future<List<BookingModel>> getBookingsByCenter(String centerName) async {
    final snapshot = await _db
        .collection(MyConstants.bookingCollection)
        .where(MyConstants.youthCenterIdCollection, isEqualTo: centerName)
        .get();
    return snapshot.docs.map((e) => BookingModel.fromSnapshot(e)).toList();
  }

  Future<List<YouthCenterModel>> getAllCenters() async {
    final snapshot = await _db.collection(MyConstants.youthCentersCollection).get();
    return snapshot.docs.map((e) => YouthCenterModel.fromSnapshot(e)).toList();
  }

 Future<List<CupModel>> getCups(String centerName,{ bool? finished}) async {
    var query = _db.collection(MyConstants.cupCollection)
      .where(MyConstants.youthCenterIdCollection, isEqualTo: centerName);

    if (finished != null) {
      query = query.where(MyConstants.finished, isEqualTo: finished);
    }

    final snapshot = await query.get();
    log( "Cups fetched for center: $centerName, finished: $finished, count: ${snapshot.docs.length}");
    return snapshot.docs.map((e) => CupModel.fromSnapshot(e)).toList();
  }

  Future<void> addBooking(BookingModel booking) async {
    await _db.collection(MyConstants.bookingCollection).add(booking.toJson());
  }
  
}
