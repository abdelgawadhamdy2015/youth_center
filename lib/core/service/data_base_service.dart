import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youth_center/core/helper/my_constants.dart';
import 'package:youth_center/models/booking_model.dart';
import 'package:youth_center/models/tournament_model.dart';
import 'package:youth_center/models/user_model.dart';
import 'package:youth_center/models/youth_center_model.dart';

class DataBaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<CenterUser?> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final snapshot =
        await _db.collection(MyConstants.userCollection).doc(user.uid).get();

    if (!snapshot.exists) return null;

    return CenterUser.fromSnapshot(snapshot);
  }

  Future<List<BookingModel>> getAllBookings() async {
    final snapshot = await _db.collection(MyConstants.bookingCollection).get();
    return snapshot.docs.map((e) => BookingModel.fromSnapshot(e)).toList();
  }

  Future<List<BookingModel>> getBookingsByCenter(String centerName) async {
    final snapshot =
        await _db
            .collection(MyConstants.bookingCollection)
            .where(MyConstants.youthCenterIdCollection, isEqualTo: centerName)
            .get();
    return snapshot.docs.map((e) => BookingModel.fromSnapshot(e)).toList();
  }

  Future<List<YouthCenterModel>> getAllCenters() async {
    final snapshot =
        await _db.collection(MyConstants.youthCentersCollection).get();
    return snapshot.docs.map((e) => YouthCenterModel.fromSnapshot(e)).toList();
  }

  Future<List<TournamentModel>> getCups(
    String centerName, {
    bool? finished,
  }) async {
    try {
      var query = _db
          .collection(MyConstants.cupCollection)
          .where(MyConstants.youthCenterIdCollection, isEqualTo: centerName);

      if (finished != null && finished) {
        query = query.where(
          MyConstants.cupEndDate,
          isGreaterThanOrEqualTo: DateTime.now(),
        );
      }

      final snapshot = await query.get();

      return snapshot.docs.map((e) => TournamentModel.fromSnapshot(e)).toList();
    } catch (error) {
      log(error.toString());
    }
    return [];
  }

  Future<void> createCup(TournamentModel tournament) async {
    await _db.collection(MyConstants.cupCollection).add(tournament.toJson());
  }

  Future<void> deleteCup(String cupId) async {
    await _db.collection(MyConstants.cupCollection).doc(cupId).delete();
  }

  Future<void> updateCup(TournamentModel tournament) async {
    log(tournament.id!);
    await _db
        .collection(MyConstants.cupCollection)
        .doc(tournament.id)
        .update(tournament.toJson());
  }

  Future<void> addBooking(BookingModel booking) async {
    await _db.collection(MyConstants.bookingCollection).add(booking.toJson());
  }

  Future<void> updateBooking(BookingModel booking) async {
    await _db
        .collection(MyConstants.bookingCollection)
        .doc(booking.id)
        .update(booking.toJson());
  }

  Future<void> deleteBooking(String bookingId) async {
    await _db.collection(MyConstants.bookingCollection).doc(bookingId).delete();
  }

  Future<void> updateCenter(CenterUser center) async {
    await _db
        .collection(MyConstants.userCollection)
        .doc(center.id)
        .update(center.toJson());
  }

  Future<void> requestBooking(BookingModel booking) async {
    await _db.collection(MyConstants.requestCollection).add(booking.toJson());
  }

  Future<List<BookingModel>> getRequests(String centerId) async {
    log('Fetching requests for center: $centerId');
    final snapshot =
        await _db
            .collection(MyConstants.requestCollection)
            .where(MyConstants.youthCenterIdCollection, isEqualTo: centerId)
            .get();
    return snapshot.docs.map((e) => BookingModel.fromSnapshot(e)).toList();
  }

  Future<void> deleteRequest(String requestId) async {
    await _db.collection(MyConstants.requestCollection).doc(requestId).delete();
  }

  Future<void> updateRequest(BookingModel booking) async {
    await _db
        .collection(MyConstants.requestCollection)
        .doc(booking.id)
        .update(booking.toJson());
  }
}
